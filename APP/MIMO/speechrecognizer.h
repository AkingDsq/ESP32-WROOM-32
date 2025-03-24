// #ifndef SPEECHRECOGNIZER_H
// #define SPEECHRECOGNIZER_H

// #include <QObject>
// #include <QAudioInput>
// #include <QBuffer>

// class SpeechRecognizer : public QObject
// {
//     Q_OBJECT
//     Q_PROPERTY(bool listening READ isListening NOTIFY listeningChanged)
//     Q_PROPERTY(double audioLevel READ audioLevel NOTIFY audioLevelChanged)

// public:
//     explicit SpeechRecognizer(QObject *parent = nullptr);
//     ~SpeechRecognizer();

//     bool isListening() const;
//     double audioLevel() const;

// public slots:
//     void startListening();
//     void stopListening();

// signals:
//     void listeningChanged(bool listening);
//     void audioLevelChanged(double level);
//     void recognitionResult(const QString &text);
//     void error(const QString &errorMessage);

// private:
//     void processAudio();
//     void checkForSilence();

//     QAudioInput *m_audioInput;
//     QBuffer m_audioBuffer;
//     bool m_listening;
//     double m_audioLevel;

// };

// #endif // SPEECHRECOGNIZER_H
