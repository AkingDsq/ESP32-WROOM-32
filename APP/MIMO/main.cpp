#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QSurfaceFormat>
// 长按唤起AI助手
#include "call_ai.h"
// SQLite数据库管理
#include "datamanager.h"
// BLE蓝牙
#include "bluetoothcontroller.h"
// 语音识别
#include "speechrecognizer.h"
// UDP
#include "UDP.h"
#include <QSettings>


int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    qDebug() << "SSL支持：" << QSslSocket::supportsSsl();                   // 预期输出true
    qDebug() << "SSL构建版本：" << QSslSocket::sslLibraryBuildVersionString();  // 如"OpenSSL 3.0.8"
    qDebug() << "SSL运行时版本：" << QSslSocket::sslLibraryVersionString();     // 应与构建版本一致

    // ini文件
    QString configPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/config.ini";
    // 确保目标目录存在
    QDir().mkpath(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation));
    // 从资源文件拷贝
    QFile src(":/config.ini"); // 或使用别名 ":/config.ini"
    if (src.exists()) {
        // 删除已存在的目标文件（强制覆盖）
        if (QFile::exists(configPath)) {
            if (!QFile::remove(configPath)) {
                qDebug() << "删除旧文件失败:" << src.errorString();
            }
        }

        if (src.copy(configPath)) {
            QFile::setPermissions(configPath, QFile::ReadOwner | QFile::WriteOwner);
            qDebug() << "ini拷贝成功";
        } else {
            qDebug() << "ini拷贝失败原因:" << src.errorString();
        }
    }
    else {
        qDebug() << "ini资源文件不存在，检查.qrc配置";
    }

    QQmlApplicationEngine engine;

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    // 创建数据库管理器实例
    DataManager dbManager;
    engine.rootContext()->setContextProperty("dbManager", &dbManager);
    qDebug() << "C++对象dbManager注册状态:" << engine.rootContext()->contextProperty("dbManager").isValid();

    // c++ -》 qml
    Call_AI aiController;
    engine.rootContext()->setContextProperty("aiController", &aiController);
    qDebug() << "C++对象aiController注册状态:" << engine.rootContext()->contextProperty("aiController").isValid();

    // BLE
    BlueToothController blueToothController;
    engine.rootContext()->setContextProperty("blueToothController", &blueToothController);
    qDebug() << "C++对象blueToothController注册状态:" << engine.rootContext()->contextProperty("blueToothController").isValid();

    // 语音控制
    //connect(aiController, &Call_AI::commandReady,  blueToothController, &BlueToothController::onVoiceCommandReceived);

    // speechrecognizer
    SpeechRecognizer* speechRecognizer = new SpeechRecognizer(&app);
    // 指定文件路径和格式
    QSettings settings(configPath, QSettings::IniFormat);
    // 读取配置项（支持默认值）
    // 讯飞API参数
    QString appId = settings.value("API/appId").toString();
    QString apiKey = settings.value("API/apiKey").toString();
    QString apiSecret = settings.value("API/apiSecret").toString();
    speechRecognizer->init(appId, apiKey, apiSecret);
    engine.rootContext()->setContextProperty("speechRecognizer", speechRecognizer);
    qDebug() << "C++对象speechRecognizer注册状态:" << engine.rootContext()->contextProperty("speechRecognizer").isValid();

    // UDP
    UDP *udpReceiver = new UDP(&app);
    // 连接 UDP 音频数据和语音识别
    QObject::connect(udpReceiver, &UDP::audioDataReceived,  speechRecognizer, &SpeechRecognizer::processExternalAudioData);

    engine.loadFromModule("MIMO", "Main");
    return app.exec();
}
