#include "call_ai.h"
#include <QDebug>

Call_AI::Call_AI() {
    speech = new QTextToSpeech(this);
    QObject::connect(speech, &QTextToSpeech::stateChanged, [this](QTextToSpeech::State state) {
        if (state == QTextToSpeech::Ready) {
            isTtsReady = true;
            qDebug() << "TTS 引擎已就绪";
        }
    });
    speech->setLocale(QLocale::Chinese);
    //speech->setVoice(QVoice::);
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
