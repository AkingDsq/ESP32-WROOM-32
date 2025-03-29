#ifndef CALL_AI_H
#define CALL_AI_H

#include <QObject>
#include <QTextToSpeech>

#include <QNetworkAccessManager>
#include <QNetworkReply>

class Call_AI : public QObject{

    Q_OBJECT

public:
    Call_AI();
    ~Call_AI();

public slots:
    void call(QString param);
    void requestAI(QString question); // 请求deepseek
    QString handleReplyFinished();

signals:
    // 可选：从 C++ 向 QML 发送反馈
    void aiResponseReceived(QString response);

private:
    QTextToSpeech *speech; // 成员变量
    bool isTtsReady;       // 标记引擎是否就绪

private slots:


private:
    QNetworkAccessManager* networkManager;
    QString configPath;
};

#endif // CALL_AI_H
