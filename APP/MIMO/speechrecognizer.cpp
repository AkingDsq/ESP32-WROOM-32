#include "speechrecognizer.h"
#include <QDebug>
#include <QCoreApplication>

#ifdef Q_OS_ANDROID
SpeechRecognizer* SpeechRecognizer::instance = nullptr;
#endif

SpeechRecognizer::SpeechRecognizer(QObject *parent) : QObject(parent)
{
#ifdef Q_OS_ANDROID
    instance = this;

    // Register native method
    JNINativeMethod methods[] {
        {"nativeOnResult", "(Ljava/lang/String;)V", reinterpret_cast<void *>(onResultCallback)}
    };

    QJniEnvironment env;
    jclass clazz = env->FindClass("org/qtproject/example/SpeechRecognizerHelper");
    if (clazz) {
        env->RegisterNatives(clazz, methods, sizeof(methods) / sizeof(methods[0]));
        env->DeleteLocalRef(clazz);
    } else {
        qWarning() << "Failed to find SpeechRecognizerHelper class";
    }

    // Create Java speech recognizer helper
    speechRecognizerHelper = QJniObject("org/qtproject/example/SpeechRecognizerHelper");
#else
    qWarning() << "Speech recognition is only supported on Android";
#endif
}

SpeechRecognizer::~SpeechRecognizer()
{
#ifdef Q_OS_ANDROID
    instance = nullptr;
    if (speechRecognizerHelper.isValid()) {
        speechRecognizerHelper.callMethod<void>("destroy");
    }
#endif
}

void SpeechRecognizer::startListening()
{
#ifdef Q_OS_ANDROID
    if (speechRecognizerHelper.isValid()) {
        speechRecognizerHelper.callMethod<void>("startListening");
    } else {
        emit recognitionError("Speech recognizer Java object is not valid");
    }
#else
    emit recognitionError("Speech recognition is only supported on Android");
#endif
}

void SpeechRecognizer::recognizeFromFile(const QString &filePath)
{
#ifdef Q_OS_ANDROID
    if (speechRecognizerHelper.isValid()) {
        QJniObject jFilePath = QJniObject::fromString(filePath);
        speechRecognizerHelper.callMethod<void>("recognizeFromFile",
                                                "(Ljava/lang/String;)V", jFilePath.object<jstring>());
    } else {
        emit recognitionError("Speech recognizer Java object is not valid");
    }
#else
    Q_UNUSED(filePath);
    emit recognitionError("Speech recognition is only supported on Android");
#endif
}

#ifdef Q_OS_ANDROID
void SpeechRecognizer::onResultCallback(JNIEnv *env, jobject obj, jstring result)
{
    Q_UNUSED(obj);
    if (instance) {
        const char *resultStr = env->GetStringUTFChars(result, nullptr);
        QString qResult = QString::fromUtf8(resultStr);
        env->ReleaseStringUTFChars(result, resultStr);

        // We need to use QMetaObject::invokeMethod for thread safety
        QMetaObject::invokeMethod(instance, [=](){
            emit instance->recognitionResult(qResult);
        }, Qt::QueuedConnection);
    }
}
#endif
