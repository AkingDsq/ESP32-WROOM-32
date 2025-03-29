#include "call_ai.h"
#include <QDebug>

#include <QSettings>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QStandardPaths>
#include <QFile>

Call_AI::Call_AI() {
    // 文字转语音模块
    speech = new QTextToSpeech(this);
    QObject::connect(speech, &QTextToSpeech::stateChanged, [this](QTextToSpeech::State state) {
        if (state == QTextToSpeech::Ready) {
            isTtsReady = true;
            qDebug() << "TTS 引擎已就绪";
        }
    });
    speech->setLocale(QLocale::Chinese);
    //speech->setVoice(QVoice::);

    // network
    networkManager = new QNetworkAccessManager(this);

    // 初始化配置文件路径
    configPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/config.ini";
    // 首次运行时从assets复制配置文件
    if(!QFile::exists(configPath)) {
        QFile::copy("assets:/config.ini", configPath);
        QFile::setPermissions(configPath, QFile::WriteOwner | QFile::ReadOwner);
    }
}
Call_AI::~Call_AI() {
}

void Call_AI::call(QString param){
    qDebug() << "触发信号：" << param;

    if (isTtsReady) {
        speech->say("你好，需要什么帮助？");
        emit aiResponseReceived("end");
    } else {
        qDebug() << "TTS 引擎未就绪，请稍后重试";
        // 可以在此处重试或提示用户
    }
}
void Call_AI::requestAI(QString question) {
    qDebug() << "What is the capital of France?";
    if (question.isEmpty()) return;

    // 从安全位置读取API Key（示例从配置文件读取）
    QSettings settings(configPath + "/config.ini", QSettings::IniFormat);

    QString apiKey = settings.value("API/Key").toString();

    // 构造请求
    QNetworkRequest request(QUrl("https://api.deepseek.com/v1/chat/completions"));
    //QNetworkRequest request(QUrl("http://127.0.0.1:1234/v1/chat/completions"));
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    request.setRawHeader("Authorization", QString("Bearer %1").arg(apiKey).toUtf8());

    // 构造请求体
    QJsonObject jsonBody;
    //jsonBody["model"] = "deepseek-chat";
    jsonBody["model"] = "repository";
    jsonBody["temperature"] = 0.7;
    QJsonArray messages;
    messages.append(QJsonObject{ {"role", "user"}, {"content", question} });
    jsonBody["messages"] = messages;

    // 发送请求
    QNetworkReply* reply = networkManager->post(request, QJsonDocument(jsonBody).toJson());
    connect(reply, &QNetworkReply::finished, this, &Call_AI::handleReplyFinished);
}

QString Call_AI::handleReplyFinished() {
    QNetworkReply* reply = qobject_cast<QNetworkReply*>(sender());

    if (reply->error() == QNetworkReply::NoError) {
        QJsonDocument doc = QJsonDocument::fromJson(reply->readAll());
        QJsonObject root = doc.object();
        QString answer = root["choices"].toArray()[0].toObject()["message"].toObject()["content"].toString();
        return "助手：" + answer;
    }
    else {
        return "错误: " + reply->errorString();
    }
    reply->deleteLater();
}
