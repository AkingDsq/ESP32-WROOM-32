#include "speechrecognizer.h"

#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QUrlQuery>
#include <QUuid>
#include <QDebug>
#include <QMessageAuthenticationCode>
#include <QCryptographicHash>
#include <QBuffer>

SpeechRecognizer::SpeechRecognizer(QObject *parent) : QObject(parent),
    m_audioSource(nullptr),
    m_audioDevice(nullptr),
    m_isRecording(false),
    m_frameSize(1280), // 每帧音频大小 (40ms的16k采样率音频)
    m_audioStatus(0) // 初始状态为第一帧
{
    // 连接WebSocket信号
    connect(&m_webSocket, &QWebSocket::connected, this, &SpeechRecognizer::onConnected);
    connect(&m_webSocket, &QWebSocket::disconnected, this, &SpeechRecognizer::onDisconnected);
    connect(&m_webSocket, &QWebSocket::textMessageReceived, this, &SpeechRecognizer::onTextMessageReceived);
    connect(&m_webSocket, &QWebSocket::errorOccurred, this, &SpeechRecognizer::onError);

    // 设置心跳定时器
    connect(&m_heartbeatTimer, &QTimer::timeout, this, &SpeechRecognizer::sendHeartbeat);
    m_heartbeatTimer.setInterval(5000); // 5秒发送一次心跳
}

SpeechRecognizer::~SpeechRecognizer()
{
    // 停止录音和连接
    stopRecognize();

    if (m_audioSource) {
        delete m_audioSource;
        m_audioSource = nullptr;
    }
}

void SpeechRecognizer::init(const QString &appId, const QString &apiKey, const QString &apiSecret)
{
    m_appId = appId;
    m_apiKey = apiKey;
    m_apiSecret = apiSecret;
}

bool SpeechRecognizer::startRecognize()
{
    if (m_isRecording) {
        return false;
    }

    m_audioStatus = 0; // 重置音频状态为第一帧
    m_currentText.clear();

    // 创建音频格式 - Qt6方式
    QAudioFormat format;
    format.setSampleRate(16000);
    format.setChannelCount(1);
    format.setSampleFormat(QAudioFormat::Int16); // Qt6 新API

    // 检查设备和格式支持
    const QAudioDevice inputDevice = QMediaDevices::defaultAudioInput();
    if (!inputDevice.isFormatSupported(format)) {
        qWarning() << "Default audio format not supported, using nearest";
        // Qt6中不再需要手动调整为最接近的格式, 只需检查兼容性
        if (inputDevice.id().isEmpty()) {
            emit errorOccurred("没有可用的音频输入设备");
            return false;
        }
    }

    // 创建音频输入设备 - Qt6方式使用QAudioSource
    m_audioSource = new QAudioSource(inputDevice, format, this);
    m_audioSource->setBufferSize(8192); // 设置缓冲区大小

    // 连接WebSocket
    QUrl url = generateAuthorizedUrl();
    qDebug() << "Connecting to WebSocket URL:" << url.toString();
    m_webSocket.open(url);

    m_isRecording = true;
    emit connectionStatusChanged(false, "正在连接...");

    return true;
}

void SpeechRecognizer::stopRecognize()
{
    if (!m_isRecording) {
        return;
    }

    // 发送结束帧
    if (m_webSocket.state() == QAbstractSocket::ConnectedState) {
        sendEndFrame();
    }

    // 停止录音 - Qt6方式
    if (m_audioDevice) {
        m_audioDevice->close();
        m_audioDevice = nullptr;
    }

    if (m_audioSource) {
        m_audioSource->stop();
    }

    // 停止心跳定时器
    m_heartbeatTimer.stop();

    // 关闭WebSocket
    m_webSocket.close();

    m_isRecording = false;
    emit connectionStatusChanged(false, "已断开连接");
}

QUrl SpeechRecognizer::generateAuthorizedUrl()
{
    // 基础WebSocket URL
    QString hostUrl = "wss://iat-api.xfyun.cn/v2/iat";
    QUrl url(hostUrl);

    // 获取当前UTC时间
    QString date = QDateTime::currentDateTimeUtc().toString("ddd, dd MMM yyyy hh:mm:ss").append(" GMT");
    QString host = "ws-api.xfyun.cn";

    // 生成签名原始字符串
    QString signatureOrigin = QString("host: %1\ndate: %2\nGET /v2/iat HTTP/1.1").arg(host).arg(date);

    // 使用HMAC-SHA256计算签名
    QByteArray signature = QMessageAuthenticationCode::hash(
                               signatureOrigin.toUtf8(),
                               m_apiSecret.toUtf8(),
                               QCryptographicHash::Sha256
                               ).toBase64();

    // 构造鉴权头部
    QString authorization = QString("api_key=\"%1\", algorithm=\"hmac-sha256\", headers=\"host date request-line\", signature=\"%2\"")
                                .arg(m_apiKey)
                                .arg(QString(signature));

    // 对鉴权字符串进行Base64编码
    QString authBase64 = QString(authorization.toUtf8().toBase64());

    // 构造URL查询参数
    QUrlQuery query;
    query.addQueryItem("authorization", authBase64);
    query.addQueryItem("date", date);
    query.addQueryItem("host", host);
    url.setQuery(query);

    return url;
}

void SpeechRecognizer::onConnected()
{
    qDebug() << "WebSocket connected";
    emit connectionStatusChanged(true, "已连接");

    // 开始录音 - Qt6方式
    m_audioDevice = m_audioSource->start();
    connect(m_audioDevice, &QIODevice::readyRead, this, &SpeechRecognizer::onAudioDataReady);

    // 发送开始帧
    sendStartFrame();

    // 启动心跳定时器
    m_heartbeatTimer.start();
}

void SpeechRecognizer::onDisconnected()
{
    qDebug() << "WebSocket disconnected";
    emit connectionStatusChanged(false, "已断开连接");

    // 停止心跳定时器
    m_heartbeatTimer.stop();
}

void SpeechRecognizer::onError(QAbstractSocket::SocketError error)
{
    qDebug() << "WebSocket error:" << error << m_webSocket.errorString();
    emit errorOccurred("WebSocket错误: " + m_webSocket.errorString());
}

void SpeechRecognizer::onTextMessageReceived(const QString &message)
{
    qDebug() << "Received text message:" << message;

    // 解析JSON响应
    QJsonDocument doc = QJsonDocument::fromJson(message.toUtf8());
    if (!doc.isObject()) {
        emit errorOccurred("无效的JSON响应");
        return;
    }

    QJsonObject jsonObj = doc.object();
    processResponse(jsonObj);
}

void SpeechRecognizer::onAudioDataReady()
{
    // 读取音频数据
    if (!m_audioDevice) {
        return;
    }

    QByteArray data = m_audioDevice->readAll();
    if (data.isEmpty()) {
        return;
    }

    // 发送音频数据
    sendAudioData(data);
}

void SpeechRecognizer::sendHeartbeat()
{
    // 发送心跳帧
    if (m_webSocket.state() == QAbstractSocket::ConnectedState) {
        QJsonObject dataObj;
        dataObj["status"] = 1; // 中间帧状态
        dataObj["format"] = "audio/L16;rate=16000";
        dataObj["encoding"] = "raw";
        dataObj["audio"] = ""; // 空音频数据

        QJsonObject frameObj;
        frameObj["common"] = m_commonParams;
        frameObj["business"] = m_businessParams;
        frameObj["data"] = dataObj;

        QJsonDocument doc(frameObj);
        QString message = doc.toJson(QJsonDocument::Compact);
        m_webSocket.sendTextMessage(message);

        qDebug() << "Heartbeat sent";
    }
}

void SpeechRecognizer::sendStartFrame()
{
    // 构造开始帧JSON
    QJsonObject commonObj;
    commonObj["app_id"] = m_appId;

    QJsonObject businessObj;
    businessObj["language"] = "zh_cn";    // 中文普通话
    businessObj["domain"] = "iat";        // 语音听写
    businessObj["accent"] = "mandarin";   // 普通话
    businessObj["vad_eos"] = 3000;        // 静默检测超时时间，单位ms，取值范围[1000-15000]
    businessObj["dwa"] = "wpgs";          // 开启动态修正功能
    businessObj["pd"] = "medical";        // 领域个性化参数：医疗
    businessObj["nunum"] = 1;             // Enable number detection
    businessObj["ptt"] = 0;               // Disable punctuation prediction

    QJsonObject dataObj;
    dataObj["format"] = "audio/L16;rate=16000";  // 音频格式
    dataObj["encoding"] = "raw";                 // 原始编码不压缩
    dataObj["status"] = 0;                       // 表示第一帧

    QJsonObject frameObj;
    frameObj["common"] = commonObj;
    frameObj["business"] = businessObj;
    frameObj["data"] = dataObj;

    QJsonDocument doc(frameObj);
    QString message = doc.toJson(QJsonDocument::Compact);

    // 发送开始帧
    m_webSocket.sendTextMessage(message);
    qDebug() << "Start frame sent:" << message;

    m_commonParams = QJsonObject{
        {"app_id", m_appId}
    };

    // 初始化业务参数
    m_businessParams = QJsonObject{
        {"language", "zh_cn"},
        {"domain", "iat"},
        {"accent", "mandarin"},
        {"vad_eos", 5000},
        {"dwa", "wpgs"},
        {"pd", "medical"}
    };
}

void SpeechRecognizer::sendAudioData(const QByteArray &data)
{
    // 每次最多发送一帧的数据
    int offset = 0;
    while (offset < data.size()) {
        int frameSize = qMin(m_frameSize, data.size() - offset);
        QByteArray frameData = data.mid(offset, frameSize);
        offset += frameSize;

        // 构造音频数据帧
        QJsonObject dataObj;
        dataObj["status"] = m_audioStatus; // Use the current audio status
        dataObj["format"] = "audio/L16;rate=16000";
        dataObj["encoding"] = "raw";
        dataObj["audio"] = QString(frameData.toBase64());

        if (m_audioStatus == 0) {
            m_audioStatus = 1; // After first frame, set to middle frame
        }

        // 构造音频数据帧时使用成员变量
        QJsonObject frameObj;
        frameObj["common"] = m_commonParams;    // 使用持久化的公共参数
        frameObj["business"] = m_businessParams; // 使用持久化的业务参数
        frameObj["data"] = dataObj;

        QJsonDocument doc(frameObj);
        QString message = doc.toJson(QJsonDocument::Compact);

        // 发送音频数据
        m_webSocket.sendTextMessage(message);
    }
}

void SpeechRecognizer::sendEndFrame()
{
    // 构造结束帧
    QJsonObject dataObj;
    dataObj["status"] = 2; // 表示最后一帧
    dataObj["format"] = "audio/L16;rate=16000";
    dataObj["encoding"] = "raw";
    dataObj["audio"] = "";

    QJsonObject frameObj;
    frameObj["common"] = m_commonParams;    // 必须
    frameObj["business"] = m_businessParams; // 必须
    frameObj["data"] = dataObj;

    QJsonDocument doc(frameObj);
    QString message = doc.toJson(QJsonDocument::Compact);

    // 发送结束帧
    m_webSocket.sendTextMessage(message);
    qDebug() << "End frame sent";
}

void SpeechRecognizer::processResponse(const QJsonObject &jsonObj)
{
    // 处理科大讯飞WebSocket响应
    if (jsonObj.contains("code") && jsonObj["code"].toInt() != 0) {
        // 处理错误
        QString errorMsg = "错误码: " + QString::number(jsonObj["code"].toInt());
        if (jsonObj.contains("message")) {
            errorMsg += ", 消息: " + jsonObj["message"].toString();
        }
        emit errorOccurred(errorMsg);
        return;
    }

    // 处理识别结果
    if (jsonObj.contains("data")) {
        QJsonObject dataObj = jsonObj["data"].toObject();

        // 处理识别结果
        if (dataObj.contains("result")) {
            QJsonObject resultObj = dataObj["result"].toObject();

            // 是否是最终结果
            bool isFinal = false;
            if (dataObj.contains("status") && dataObj["status"].toInt() == 2) {
                isFinal = true;
            }

            // 提取文本结果
            QString text;
            if (resultObj.contains("ws")) {
                QJsonArray wsArray = resultObj["ws"].toArray();
                for (int i = 0; i < wsArray.size(); i++) {
                    QJsonObject wsObj = wsArray[i].toObject();
                    if (wsObj.contains("cw")) {
                        QJsonArray cwArray = wsObj["cw"].toArray();
                        for (int j = 0; j < cwArray.size(); j++) {
                            QJsonObject cwObj = cwArray[j].toObject();
                            if (cwObj.contains("w")) {
                                text += cwObj["w"].toString();
                            }
                        }
                    }
                }
            }

            // 处理实时识别结果
            if (!text.isEmpty()) {
                // Check for "wpgs" mode (real-time word modification)
                if (resultObj.contains("pgs")) {
                    QString pgs = resultObj["pgs"].toString();
                    if (pgs == "rpl") {
                        // 动态修正，替换前面的结果
                        if (resultObj.contains("rg")) {
                            QJsonArray rgArray = resultObj["rg"].toArray();
                            if (rgArray.size() >= 2) {
                                int startIdx = rgArray[0].toInt();
                                int endIdx = rgArray[1].toInt();

                                // 替换部分文本
                                if (startIdx >= 0 && endIdx > startIdx && startIdx < m_currentText.length()) {
                                    // Keep text before startIdx, replace text between startIdx and endIdx with new text
                                    m_currentText = m_currentText.left(startIdx) + text;
                                } else {
                                    // If indices aren't valid, append the text
                                    m_currentText += text;
                                }

                                emit recognitionResult(m_currentText, false);
                            }
                        }
                    } else if (pgs == "apd") {
                        // Append mode - add to existing text
                        m_currentText += text;
                        emit recognitionResult(m_currentText, false);
                    }
                } else {
                    // 添加新文本
                    if (isFinal) {
                        m_currentText += text;
                        emit recognitionResult(m_currentText, true);
                        m_currentText.clear(); // Clear after final result
                    } else {
                        m_currentText += text;
                        emit recognitionResult(m_currentText, false);
                    }
                }
            }
        }
    }

    if (jsonObj.contains("code") && jsonObj["code"].toInt() != 0) {
        qDebug() << "讯飞错误码:" << jsonObj["code"].toInt() << "消息:" << jsonObj["message"].toString();
    }
}
