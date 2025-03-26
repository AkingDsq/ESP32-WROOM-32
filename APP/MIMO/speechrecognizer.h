#ifndef SPEECHRECOGNIZER_H
#define SPEECHRECOGNIZER_H

// 使用andriod原生的语音识别模块
#include <QObject>
#include <QString>
#ifdef Q_OS_ANDROID
#include <QJniObject>
#include <QJniEnvironment>
#endif

class SpeechRecognizer : public QObject
{
    Q_OBJECT
public:
    explicit SpeechRecognizer(QObject *parent = nullptr);
    ~SpeechRecognizer();

    void startListening();
    void recognizeFromFile(const QString &filePath);

public slots:


signals:
    void recognitionResult(const QString &text);
    void recognitionError(const QString &errorMessage);

private:
#ifdef Q_OS_ANDROID
    QJniObject speechRecognizerHelper;
    static void onResultCallback(JNIEnv *env, jobject obj, jstring result);
    static SpeechRecognizer* instance;
#endif

};

#endif // SPEECHRECOGNIZER_H
