#ifndef BLUETOOTHCONTROLLER_H
#define BLUETOOTHCONTROLLER_H

#include <QObject>
#include <QCoreApplication>
#include <QPermissions>                   //
#include <QBluetoothDeviceDiscoveryAgent> //
#include <QBluetoothSocket>               //
#include <QBluetoothUuid>                 //
#include <QBluetoothLocalDevice>          //
#include <QLowEnergyCharacteristic>       // QLowEnergyCharacteristic 类存储有关蓝牙低功耗服务特性的信息
#include <QLowEnergyService>              // QLowEnergyService 类代表蓝牙低功耗设备上的一项单独服务。
#include <QLowEnergyController>           // QLowEnergyController 类提供对蓝牙低能耗设备的访问。
// 蓝牙标准UUID的结构通常是基于SIG定义的基本UUID，即0000xxxx-0000-1000-8000-00805F9B34FB。其中，16位的标准UUID会替换其中的xxxx部分
#define SERVICE_UUID "0000181A-0000-1000-8000-00805F9B34FB"
#define Temperature_UUID "00002A6E-0000-1000-8000-00805F9B34FB" // 温度uuid
#define Humidity_UUID "00002A6F-0000-1000-8000-00805F9B34FB"    // 湿度的uuid
#define Command_UUID "0000FFE1-0000-1000-8000-00805F9B34FB"     // 用于接收命令的特性UUID
#define Light_UUID "0000ABAB-0000-1000-8000-00805F9B34FB"       // 用于调整灯

#define NUM_LEDS 8

/******************************************************************************
 *
 * @file       bluetoothcontroller.h
 * @brief      蓝牙相关
 *
 * @author     dsq
 * @date       2025/05/08
 * @history
 *****************************************************************************/

class BlueToothController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString temperature READ temperature NOTIFY temperatureChanged)
    Q_PROPERTY(QString humidity READ humidity NOTIFY humidityChanged)

public:
    explicit BlueToothController(QObject *parent = nullptr);
    ~BlueToothController();

    QString temperature() const { return m_temperature; }
    QString humidity() const { return m_humidity; }


private:
    QLowEnergyService *service = nullptr;          // BLE——Service
    QBluetoothLocalDevice *localDevice = nullptr;  // 访问本地蓝牙
    QBluetoothDeviceDiscoveryAgent *agent = nullptr; // 扫描
    QLowEnergyController *controller = nullptr;
    QLowEnergyCharacteristic m_commandCharacteristic; // 发送命令特征

    QString m_temperature;
    QString m_humidity;
    bool m_connected = false;

    // LED状态结构体
    bool ledsState[NUM_LEDS] = {0}; // 状态存储数组

signals:
    void temperatureChanged(QString temperature);
    void humidityChanged(QString humidity);
    void connectionStatusChanged(bool connected);
    void commandSent(bool success);
    void commandVoiceSent(bool success);
    void ledsStateChanged(bool *ledStates, uint8_t *brightnessValues);

public slots:
    // 检测各权限
    bool checkBluetoothPermission();
    bool checkLocationPermission();
    bool checkMicrophonePermission();

    void startScan(); // 扫描蓝牙设备
    void connectDevice(QString address, QBluetoothDeviceInfo info);// 连接服务
    void sendCommand(QString command); // 发送特征

    void onAdjustBrightness(int id, int value); // 调整灯光亮度

private slots:
    void onDeviceDiscovered(QBluetoothDeviceInfo info); // 扫描到的服务
    void onScanFinished(); // 扫描结束
    void serviceDiscovered(QBluetoothUuid uuid);
    void serviceStateChanged(QLowEnergyService::ServiceState state);
    void characteristicChanged(QLowEnergyCharacteristic characteristic, QByteArray newValue);
    void controllerStateChanged(QLowEnergyController::ControllerState state);
    void errorOccurred(QLowEnergyController::Error error);



};

#endif // BLUETOOTHCONTROLLER_H
