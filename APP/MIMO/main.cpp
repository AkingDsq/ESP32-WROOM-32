#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
// 长按唤起AI助手
#include "call_ai.h"
#include "imageprovider.h"
#include "cv_controller.h"

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

    // c++ -》 qml
    Call_AI aiController;
    engine.rootContext()->setContextProperty("aiController", &aiController);
    qDebug() << "C++对象aiController注册状态:" << engine.rootContext()->contextProperty("aiController").isValid();

    // BLE
    BlueToothController blueToothController;
    engine.rootContext()->setContextProperty("blueToothController", &blueToothController);
    qDebug() << "C++对象blueToothController注册状态:" << engine.rootContext()->contextProperty("blueToothController").isValid();
    // camera
    // ImageProvider imageProvider;
    // engine.addImageProvider("camera", &imageProvider); // URL前缀为"image://camera"
    // qDebug() << "C++对象注册状态:" << engine.rootContext()->contextProperty("camera").isValid();
    // cv_controller cam;
    // engine.rootContext()->setContextProperty("cam", &cam);
    // qDebug() << "C++对象注册状态:" << engine.rootContext()->contextProperty("cam").isValid();

    engine.loadFromModule("MIMO", "Main");
    return app.exec();
}
