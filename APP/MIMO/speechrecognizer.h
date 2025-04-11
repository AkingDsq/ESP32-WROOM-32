#ifndef SPEECHRECOGNIZER_H
#define SPEECHRECOGNIZER_H

#include <QObject>
#include <QWebSocket>
#include <QTimer>
#include <QUrl>
#include <QByteArray>
#include <QJsonObject>
#include <QDateTime>
#include <QAudioSource>
#include <QMediaDevices>
#include <QAudioDevice>

/*
通过接口密钥基于hmac-sha256计算签名，向服务器端发送Websocket协议握手请求。详见下方 接口鉴权 。
握手成功后，客户端通过Websocket连接同时上传和接收数据。数据上传完毕，客户端需要上传一次数据结束标识。详见下方 接口数据传输与接收 。
接收到服务器端的结果全部返回标识后断开Websocket连接。
*/

class SpeechRecognizer : public QObject
{
    Q_OBJECT
public:
    explicit SpeechRecognizer(QObject *parent = nullptr);
    ~SpeechRecognizer();

    // 初始化参数
    void init(const QString &appId, const QString &apiKey, const QString &apiSecret);

    // 是否正在录音
    bool isRecording() const { return m_isRecording; }
    QString currentText() const { return m_currentText; }
    // 发送INMP441音频数据
    void processExternalAudioData(const QByteArray &audioData);

public slots:
    // 开始录音和识别
    bool startRecognize();
    // 停止录音和识别
    void stopRecognize();

signals:
    // 识别结果信号
    void recognitionResult(const QString &text, bool isFinal);

    // 连接状态信号
    void connectionStatusChanged(bool connected, const QString &status = QString());

    // 错误信号
    void errorOccurred(const QString &errorMsg);

private slots:
    // WebSocket连接成功
    void onConnected();

    // WebSocket断开连接
    void onDisconnected();

    // WebSocket错误
    void onError(QAbstractSocket::SocketError error);

    // WebSocket接收到消息
    void onTextMessageReceived(const QString &message);

    // 音频数据准备好
    void onAudioDataReady();

    // 发送心跳
    void sendHeartbeat();

private:
    // 生成授权URL
    QUrl generateAuthorizedUrl();

    // 发送音频数据
    void sendAudioData(const QByteArray &data);

    // 处理识别结果
    void processResponse(const QJsonObject &jsonObj);

    // 发送开始帧
    void sendStartFrame();

    // 发送结束帧
    void sendEndFrame();

    // 添加一个INMP441音频数据缓冲区
    QByteArray m_pendingAudioBuffer;

private:
    QJsonObject m_commonParams;  // 持久化公共参数
    QJsonObject m_businessParams; // 持久化业务参数
    // 讯飞API参数
    QString m_appId;
    QString m_apiKey;
    QString m_apiSecret;

    // WebSocket客户端
    QWebSocket m_webSocket;

    // 心跳定时器
    QTimer m_heartbeatTimer;

    // Qt6 音频输入 (QAudioSource 替代 QAudioInput)
    QAudioSource *m_audioSource;
    QIODevice *m_audioDevice;

    // 录音状态
    bool m_isRecording;

    // 语音识别参数
    int m_frameSize;
    int m_audioStatus; // 0: 第一帧, 1: 中间帧, 2: 最后一帧

    // 临时存放识别结果
    QString m_currentText;

    // 录音模式0:qt的app，1：INMP441
    bool model = false;
};

#endif // SPEECHRECOGNIZER_H
