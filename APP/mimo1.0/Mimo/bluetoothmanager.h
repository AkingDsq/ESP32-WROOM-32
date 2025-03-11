#ifndef BLUETOOTHMANAGER_H
#define BLUETOOTHMANAGER_H

// BluetoothManager.h
#include <QBluetoothDeviceDiscoveryAgent>
#include <QBluetoothSocket>
#include <QBluetoothServiceInfo>

class BluetoothManager : public QObject {
    Q_OBJECT
public:
    explicit BluetoothManager(QObject *parent = nullptr);
    ~BluetoothManager();

    QString connectToDevice();  // 连接蓝牙设备
    void disconnectDevice(); // 断开蓝牙设备
signals:
    void connectionStatusChanged(const QString &status);  //
    void errorOccurred(const QString &error);             //

private slots:
    QString onDeviceDiscovered(const QBluetoothDeviceInfo &device); // 扫描蓝牙设备
    QString onScanFinished();  // 停止扫描
    QString onSocketError(QBluetoothSocket::SocketError error);

private:
    QBluetoothDeviceDiscoveryAgent *discoveryAgent;
    QBluetoothSocket *socket;
    bool isTargetDeviceFound;
    QString targetDeviceAddress;
};

#endif // BLUETOOTHMANAGER_H
