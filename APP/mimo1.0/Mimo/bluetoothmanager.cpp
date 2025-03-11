#include "BluetoothManager.h"

BluetoothManager::BluetoothManager(QObject *parent) : QObject(parent) {
    discoveryAgent = new QBluetoothDeviceDiscoveryAgent(this);
    socket = new QBluetoothSocket(QBluetoothServiceInfo::RfcommProtocol, this);
    isTargetDeviceFound = false;

    connect(discoveryAgent, &QBluetoothDeviceDiscoveryAgent::deviceDiscovered, this, &BluetoothManager::onDeviceDiscovered);
    connect(discoveryAgent, &QBluetoothDeviceDiscoveryAgent::finished, this, &BluetoothManager::onScanFinished);
    //connect(socket, QOverload<QBluetoothSocket::SocketError>::of(&QBluetoothSocket::error), this, &BluetoothManager::onSocketError);
}
BluetoothManager::~BluetoothManager() {

}

QString BluetoothManager::connectToDevice() {
    if (socket->state() == QBluetoothSocket::SocketState::ConnectedState) {
        if (socket->peerName() != "ESP32_SPP") {
            return "错误：已连接到非目标设备";
        }
        else return "已连接";
    }

    // 未连接，开始扫描
    isTargetDeviceFound = false;
    discoveryAgent->start();
    return "开始扫描";
}

QString BluetoothManager::onDeviceDiscovered(const QBluetoothDeviceInfo &device) {
    if (device.name() == "ESP32_SPP") {
        isTargetDeviceFound = true;
        targetDeviceAddress = device.address().toString();
        discoveryAgent->stop(); // 发现目标设备后停止扫描
        // 自动连接
        socket->connectToService(
            QBluetoothAddress(targetDeviceAddress),
            QBluetoothUuid(QString("00001101-0000-1000-8000-00805F9B34FB"))
            );
        return "发现目标设备，正在连接...";
    }
    return "正在扫描设备...";
}

QString BluetoothManager::onScanFinished() {
    if (!isTargetDeviceFound) {
        return "未找到目标设备，请手动选择";
        // 触发手动选择逻辑（例如弹出设备列表）
    }
}

QString BluetoothManager::onSocketError(QBluetoothSocket::SocketError error) {
    return "连接错误: ";
}

void BluetoothManager::disconnectDevice() {
    if (socket->state() == QBluetoothSocket::SocketState::ConnectedState) {
        socket->disconnectFromService();
    }
}
