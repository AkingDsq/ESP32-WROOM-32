#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QSurfaceFormat>
// 长按唤起AI助手
#include "call_ai.h"
//#include "datamanager.h"
#include "bluetoothcontroller.h"
//
#include "speechrecognizer.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    // 验证 SSL 支持
    qDebug() << "SSL Support:" << QSslSocket::supportsSsl();
    qDebug() << "Library Version:" << QSslSocket::sslLibraryVersionString();

    QQmlApplicationEngine engine;

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    // // 创建数据库管理器实例
    // DataManager dbManager;
    // if (!dbManager.initDatabase()) {
    //     qDebug() << "Failed to initialize database!";
    //     return -1;
    // }
    // engine.rootContext()->setContextProperty("dbManager", &dbManager);

    // c++ -》 qml
    Call_AI aiController;
    engine.rootContext()->setContextProperty("aiController", &aiController);
    qDebug() << "C++对象aiController注册状态:" << engine.rootContext()->contextProperty("aiController").isValid();

    // BLE
    BlueToothController blueToothController;
    engine.rootContext()->setContextProperty("blueToothController", &blueToothController);
    qDebug() << "C++对象blueToothController注册状态:" << engine.rootContext()->contextProperty("blueToothController").isValid();

    // speechrecognizer
    SpeechRecognizer* speechRecognizer = new SpeechRecognizer(&app);
    // 讯飞API参数
    QString appId = "fcd85c47";
    QString apiKey = "5c0f3a3b3393ddd550b7df00633cd1b8";
    QString apiSecret = "YWMxZTNlOWZlMzQ0NGVlNWQyMzU1ZmE5";
    speechRecognizer->init(appId, apiKey, apiSecret);
    engine.rootContext()->setContextProperty("speechRecognizer", speechRecognizer);
    qDebug() << "C++对象speechRecognizer注册状态:" << engine.rootContext()->contextProperty("speechRecognizer").isValid();

    engine.loadFromModule("MIMO", "Main");
    return app.exec();
}
