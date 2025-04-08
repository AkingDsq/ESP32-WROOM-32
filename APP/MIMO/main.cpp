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

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

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
