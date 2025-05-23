#ifndef CALL_AI_H
#define CALL_AI_H

#include <QObject>
#include <QTextToSpeech>

#include <QNetworkAccessManager>
#include <QNetworkReply>

#include "bluetoothcontroller.h"

/******************************************************************************
 *
 * @file       call_ai.h
 * @brief      接入deepseek
 *
 * @author     dsq
 * @date       2025/05/08
 * @history
 *****************************************************************************/

class Call_AI : public QObject{

    Q_OBJECT

public:
    Call_AI();
    ~Call_AI();

public slots:
    void call();
    void requestAI(QString question); // 请求deepseek
    void handleReplyFinished();
    void saying(QString param); // 播报生成的内容

    //void processCommands(QString commandString);

signals:
    // 从 C++ 向 QML 发送反馈
    void aiResponseReceived(QString response);

    // INMP441录音结束
    void endINMP441();

private:
    QTextToSpeech *speech; // 成员变量
    bool isTtsReady;       // 标记引擎是否就绪

    void data(QString answer); // 解析数据

private:
    QNetworkAccessManager* networkManager;
    QString configPath;  // ini文件位置
    QString _apiKey = ""; // Deepseek API
    void GetApiKey(); // 获取Deepseek API

    BlueToothController *m_bluetoothController = new BlueToothController(this);
};

#endif // CALL_AI_H
