#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QSurfaceFormat>
// 长按唤起AI助手
#include "call_ai.h"
//#include "datamanager.h"
#include "bluetoothcontroller.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

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

    engine.loadFromModule("MIMO", "Main");
    return app.exec();
}
