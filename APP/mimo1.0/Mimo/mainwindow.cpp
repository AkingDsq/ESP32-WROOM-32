#include "mainwindow.h"
#include "./ui_mainwindow.h"
#include "MusicPlayer.h"
#include "error.h"

#include <QPermissions>  // 检测权限
#include <QtBluetooth>

#include <QThread>

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    musicPlayer = new MusicPlayer(ui);

    // 切换页面
    pages = ui->stackedWidget;
    musicPlayer_page_1 = ui->musicPlayer_page_1;
    musicPlayer_page_2 = ui->musicPlayer_page_2;

    connect(musicPlayer_page_1, &QPushButton::clicked, this, [this]() { on_stackedWidget_currentChanged(1); });
    connect(musicPlayer_page_2, &QPushButton::clicked, this, [this]() { on_stackedWidget_currentChanged(2); });


    init();
}

MainWindow::~MainWindow()
{
    delete ui;
}
void MainWindow::init()
{
    // 请求位置权限（Android 6.0+必需）
    QLocationPermission locationPermission;
    locationPermission.setAccuracy(QLocationPermission::Precise);
    qApp->requestPermission(locationPermission, [&](const QPermission &permission) {
        if (permission.status() == Qt::PermissionStatus::Granted) {
            qDebug() << "Location权限已授予";
        }
    });
    // 请求蓝牙权限
    QBluetoothPermission btPermission;
    btPermission.setCommunicationModes(QBluetoothPermission::Access);
    qApp->requestPermission(btPermission, [&](const QPermission &permission) {
        if (permission.status() == Qt::PermissionStatus::Granted) {
            qDebug() << "Bluetooth权限已授予";
        }
    });

    // 发现esp32设备
    QBluetoothDeviceDiscoveryAgent *discoveryAgent = new QBluetoothDeviceDiscoveryAgent(this);
    connect(discoveryAgent, &QBluetoothDeviceDiscoveryAgent::deviceDiscovered, [](const QBluetoothDeviceInfo &device) {
        if (device.name().contains("ESP32test")) {
            qDebug() << "发现 ESP32 设备";
        }
    });
    discoveryAgent->start();

    error *e = new error;
    QLabel* message = e->getMessageLabel();
    QString m = "正在连接蓝牙";
    // 检查连接状态（需先建立连接）
    QBluetoothSocket *socket = new QBluetoothSocket(QBluetoothServiceInfo::RfcommProtocol);
    connect(socket, &QBluetoothSocket::connected, [&m]() {
        m = "已连接到 ESP32";
    });
    connect(socket, &QBluetoothSocket::disconnected, [&m]() {
        m = "连接已断开";
    });
    message->setText(m);
    e->show();

    // 请求摄像头权限
    QCameraPermission cameraPermission;
    switch (qApp->checkPermission(cameraPermission))
    {
    case Qt::PermissionStatus::Undetermined:
        qApp->requestPermission(cameraPermission, this, &MainWindow::init);
        qDebug() << "requestPermission...";
        return;
    case Qt::PermissionStatus::Denied:
        qWarning("Camera permission is not granted!");
        return;
    case Qt::PermissionStatus::Granted:
        break;
    }

    // 请求麦克风权限
    QMicrophonePermission microphonePermission;
    qApp->requestPermission(microphonePermission, [&](const QPermission &permission) {
        if (permission.status() == Qt::PermissionStatus::Granted) {
            qDebug() << "麦克风权限已授予";
        }
    });
}

// 切换页面
void MainWindow::on_stackedWidget_currentChanged(int index) {
    if (pages != nullptr) {
        if (index < pages->count()) pages->setCurrentIndex(index);    //切换页面
        else qDebug() << "页面" << index + 1 << "不存在";
    }
    else qDebug() << "页面为空";
}
