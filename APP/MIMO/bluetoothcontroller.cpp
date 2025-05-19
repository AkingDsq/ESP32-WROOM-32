#include "bluetoothcontroller.h"

BlueToothController::BlueToothController(QObject *parent)
    : QObject{parent}
{
    localDevice = new QBluetoothLocalDevice();  //本地操作
    checkLocationPermission();
    checkBluetoothPermission();

    // 开始扫描
    startScan();
}
BlueToothController::~BlueToothController(){
    if (agent) {
        agent->stop();
        agent->deleteLater();
    }

    if (controller) {
        controller->disconnectFromDevice();
        controller->deleteLater();
    }

    if (localDevice) {
        delete localDevice;
    }
}
// 检测蓝牙权限
bool BlueToothController::checkBluetoothPermission(){
    // 查看蓝牙是否打开
    if( localDevice->hostMode() == QBluetoothLocalDevice::HostPoweredOff)//判断开机有没有打开蓝牙
    {
        qDebug() << "正在调用打开本地的蓝牙设备";
        localDevice->powerOn();//调用打开本地的蓝牙设备
    }

    // 检测蓝牙权限
    QBluetoothPermission permission{};
    permission.setCommunicationModes(QBluetoothPermission::Access);
    switch (qApp->checkPermission(permission)) {
    case Qt::PermissionStatus::Undetermined:     //权限状态未知。应通过QCoreApplication::requestPermission() 申请权限，以确定实际状态。
        qDebug() << "权限状态未知";
        qApp->requestPermission(permission, [this](const QPermission &perm){
            if (perm.status() == Qt::PermissionStatus::Granted) {
                qDebug() << "蓝牙权限已授予";
            } else {
                qDebug() << "用户拒绝蓝牙权限";
                return false;
            }
        });
        break;
    case Qt::PermissionStatus::Denied:  // 用户已明确拒绝应用程序请求的权限，或已知该权限不可访问或不适用于给定平台上的应用程序。
        qDebug() << "用户已明确拒绝应用程序请求的蓝牙权限";
        return false;
    case Qt::PermissionStatus::Granted:  // 用户已明确授予应用程序权限，或已知该权限在给定平台上不需要用户授权。
        qDebug() << "用户已明确授予应用程序蓝牙权限";
    }

    return true;
}
bool BlueToothController::checkLocationPermission(){
    // 检测本地位置权限
    QLocationPermission locationPermission{};
    locationPermission.setAccuracy(QLocationPermission::Precise);
    switch (qApp->checkPermission(locationPermission)) {
    case Qt::PermissionStatus::Undetermined:     //权限状态未知。应通过QCoreApplication::requestPermission() 申请权限，以确定实际状态。
        qDebug() << "权限状态未知";
        qApp->requestPermission(locationPermission, [this](const QPermission &perm){
            if (perm.status() == Qt::PermissionStatus::Granted) {
                qDebug() << "位置权限已授予";
            } else {
                qDebug() << "用户拒绝位置权限";
                return false;
            }
        });
        break;
    case Qt::PermissionStatus::Denied:  // 用户已明确拒绝应用程序请求的权限，或已知该权限不可访问或不适用于给定平台上的应用程序。
        qDebug() << "用户已明确拒绝应用程序请求的本地位置权限";
        return false;
    case Qt::PermissionStatus::Granted:  // 用户已明确授予应用程序权限，或已知该权限在给定平台上不需要用户授权。
        qDebug() << "用户已明确授予应用程序位置权限";
    }

    return true;
}
// 检测麦克风权限
bool BlueToothController::checkMicrophonePermission(){
    QMicrophonePermission microphonePermission{};
    switch (qApp->checkPermission(microphonePermission)) {
    case Qt::PermissionStatus::Undetermined:     //权限状态未知。应通过QCoreApplication::requestPermission() 申请权限，以确定实际状态。
        qDebug() << "权限状态未知";
        qApp->requestPermission(microphonePermission, [](const QPermission &perm){
            if (perm.status() == Qt::PermissionStatus::Granted) {
                qDebug() << "麦克风权限已授予";
            } else {
                qDebug() << "用户拒绝麦克风权限";
                return false;
            }
        });
        break;
    case Qt::PermissionStatus::Denied:  // 用户已明确拒绝应用程序请求的权限，或已知该权限不可访问或不适用于给定平台上的应用程序。
        qDebug() << "用户已明确拒绝应用程序请求的麦克风权限";
        return false;
    case Qt::PermissionStatus::Granted:  // 用户已明确授予应用程序权限，或已知该权限在给定平台上不需要用户授权。
        qDebug() << "用户已明确授予应用程序麦克风权限";
    }

    return true;
}
// 开始扫描
void BlueToothController::startScan(){
    //  检测权限
    //checkBluetoothPermission();

    if (!agent) {
        agent = new QBluetoothDeviceDiscoveryAgent(this);
        connect(agent, &QBluetoothDeviceDiscoveryAgent::deviceDiscovered, this, &BlueToothController::onDeviceDiscovered);
        connect(agent, &QBluetoothDeviceDiscoveryAgent::finished, this, &BlueToothController::onScanFinished);

    }
    qDebug() << "开始蓝牙设备扫描";
    agent->start(QBluetoothDeviceDiscoveryAgent::LowEnergyMethod);
}
// 发送命令到ESP32
void BlueToothController::sendCommand(QString command)
{
    if (!m_connected || !m_commandCharacteristic.isValid()) {
        qWarning() << "无法发送命令";
        emit commandSent(false);
        return;
    }

    qDebug() << "发送命令:" << command;
    QByteArray data = command.toUtf8();
    service->writeCharacteristic(m_commandCharacteristic, data);
    emit commandSent(true);
}
// // 语音指令
// void BlueToothController::onVoiceCommandReceived(QString command){
//     sendCommand(command);
// }

// 连接设备,连接串口
void BlueToothController::onDeviceDiscovered(QBluetoothDeviceInfo info)
{
    QBluetoothLocalDevice::Pairing pairingStatus = localDevice->pairingStatus(info.address());
    /* 蓝牙状态pairingStatus，Pairing枚举类型
         * 0:Unpaired没配对
         * 1:Paired配对但没授权
         * 2:AuthorizedPaired配对且授权 */
    if (pairingStatus == QBluetoothLocalDevice::Paired || pairingStatus == QBluetoothLocalDevice::AuthorizedPaired )
        qDebug() << "已配对";
    else
        qDebug() << "未配对";

    qDebug() << "Found new device:" << info.name() << '(' << info.address().toString() << ')';
    if (info.name() == "ESP32-BLE" || info.address().toString() == "5C:01:3B:6B:A2:62") {
        qDebug() << "找到了ESP32-BLE";
        agent->stop();
        connectDevice(info.address().toString(), info);
    }
}
// 连接设备
void BlueToothController::connectDevice(QString address, QBluetoothDeviceInfo info){
    qDebug() << "正在连接设备:" << address;

    if (controller) {
        controller->disconnectFromDevice();
        delete controller;
    }
    // 在中心角色中创建控制器对象
    controller = QLowEnergyController::createCentral(info, this);
    // 每次发现新服务时都会发出该信号。
    connect(controller, &QLowEnergyController::serviceDiscovered, this, &BlueToothController::serviceDiscovered);
    // 运行中的服务发现结束时会发出该信号。如果发现过程结束时出现错误，则不会发出该信号。
    connect(controller, &QLowEnergyController::discoveryFinished, [this]() { qDebug() << "运行中的服务发现结束"; });
    // 控制器成功连接到远程低能耗设备
    connect(controller, &QLowEnergyController::connected,
            [this]() {
                qDebug() << "控制器成功连接到远程低能耗设备";
                controller->discoverServices();
            });
    // 当控制器与远程低能耗设备断开连接或反向断开连接时
    connect(controller, &QLowEnergyController::disconnected,
            [this]() {
                qDebug() << "当控制器与远程低能耗设备断开连接或反向断开连接";
                m_connected = false;
                emit connectionStatusChanged(false);
            });
    // 控制器状态发生变化时会发出该信号
    connect(controller, &QLowEnergyController::stateChanged, this, &BlueToothController::controllerStateChanged);

    controller->connectToDevice();
}
void BlueToothController::serviceDiscovered(QBluetoothUuid uuid){
    qDebug() << "发现服务:" << uuid.toString();

    // 检测设备
    if (uuid == QBluetoothUuid(SERVICE_UUID)) {
        qDebug() << "找到目标设备";
    }
}
// 没有连接到设备
void BlueToothController::onScanFinished()
{
    qDebug() << "扫描结束";

}
//
void BlueToothController::controllerStateChanged(QLowEnergyController::ControllerState state)
{
    qDebug() << "控制器状态改变" << state;

    if (state == QLowEnergyController::DiscoveredState) {
        // 控制器已发现远程设备提供的所有服务
        QBluetoothUuid serviceUuid(SERVICE_UUID);
        // 创建serviceUuid 所代表服务的实例
        service = controller->createServiceObject(serviceUuid, this);

        if (service) {
            // 服务状态改变
            connect(service, &QLowEnergyService::stateChanged, this, &BlueToothController::serviceStateChanged);
            // 当外设/设备侧的事件改变characteristic 的值
            connect(service, &QLowEnergyService::characteristicChanged, this, &BlueToothController::characteristicChanged);
            // 当characteristic 的读取请求成功返回其value 时
            connect(service, &QLowEnergyService::characteristicRead,
                    [this](QLowEnergyCharacteristic c, QByteArray value) {
                        qDebug() << "特征值:" << c.uuid().toString() << "value:" << value;
                        if(c == service->characteristic(QBluetoothUuid(Temperature_UUID))){
                            qDebug() << "初始化温度" << c.uuid().toString() << "value:" << value;
                            m_temperature = value;
                            emit temperatureChanged(m_temperature); // 需要手动触发信号
                        }
                        else if(c == service->characteristic(QBluetoothUuid(Humidity_UUID))){
                            qDebug() << "初始化湿度" << c.uuid().toString() << "value:" << value;
                            m_humidity = value;
                            emit humidityChanged(m_humidity); // 需要手动触发信号
                        }
                    });
            // 启动对服务所含服务、特征及其相关描述符的发现
            service->discoverDetails();
        } else {
            qWarning() << "创建服务失败" << serviceUuid.toString();
        }
    }
}
// 服务状态改变
void BlueToothController::serviceStateChanged(QLowEnergyService::ServiceState state)
{
    qDebug() << "服务状态改变:" << state;

    if (state == QLowEnergyService::ServiceDiscovered) {
        // Now we can interact with the characteristics

        // 温度特征
        qDebug() << "温度特征:" + QBluetoothUuid(Temperature_UUID).toString();
        QLowEnergyCharacteristic tempChar = service->characteristic(QBluetoothUuid(Temperature_UUID));
        if (tempChar.isValid()) {
            qDebug() << "找到温度特征";
            service->readCharacteristic(tempChar); // 读取温度

            // // 描述符值可通过管理该描述符所属服务的QLowEnergyService 实例写入。QLowEnergyService::writeDescriptor() 函数将写入新值。成功后将发出QLowEnergyService::descriptorWritten() 信号。该对象的缓存value() 也会相应更新。
            if (tempChar.properties() & QLowEnergyCharacteristic::Notify) {
                QLowEnergyDescriptor notification = tempChar.descriptor(QBluetoothUuid::DescriptorType::ClientCharacteristicConfiguration);
                if (notification.isValid()) {
                    service->writeDescriptor(notification, QByteArray::fromHex("0100"));
                    // 检查写入结果
                    if (service->error() != QLowEnergyService::NoError) {
                        qWarning() << "启用温度通知失败:" << service->error();
                    } else {
                        qDebug() << "温度通知已启用";
                    }
                }
            }
        }
        else{

            qDebug() << "温度特征无效，UUID可能不匹配";
            return;
        }

        // 湿度特征
        qDebug() << "湿度特征:" + QBluetoothUuid(Humidity_UUID).toString();
        QLowEnergyCharacteristic humidChar = service->characteristic(QBluetoothUuid(Humidity_UUID));
        if (humidChar.isValid()) {
            qDebug() << "找到湿度特征";
            service->readCharacteristic(humidChar);

            // 描述符值可通过管理该描述符所属服务的QLowEnergyService 实例写入。QLowEnergyService::writeDescriptor() 函数将写入新值。成功后将发出QLowEnergyService::descriptorWritten() 信号。该对象的缓存value() 也会相应更新。
            if (humidChar.properties() & QLowEnergyCharacteristic::Notify) {
                QLowEnergyDescriptor notification = humidChar.descriptor(QBluetoothUuid::DescriptorType::ClientCharacteristicConfiguration);
                if (notification.isValid()) {
                    service->writeDescriptor(notification, QByteArray::fromHex("0100"));
                    // 检查写入结果
                    if (service->error() != QLowEnergyService::NoError) {
                        qWarning() << "启用湿度通知失败:" << service->error();
                    } else {
                        qDebug() << "湿度通知已启用";
                    }
                }
            }
        }
        else{
            qDebug() << "湿度特征无效，UUID可能不匹配";
            return;
        }

        // 灯特征
        qDebug() << "灯特征:" + QBluetoothUuid(Light_UUID).toString();
        QLowEnergyCharacteristic lightChar = service->characteristic(QBluetoothUuid(Light_UUID));
        if (lightChar.isValid()) {
            qDebug() << "找到灯特征";
            service->readCharacteristic(lightChar);

            // 描述符值可通过管理该描述符所属服务的QLowEnergyService 实例写入。QLowEnergyService::writeDescriptor() 函数将写入新值。成功后将发出QLowEnergyService::descriptorWritten() 信号。该对象的缓存value() 也会相应更新。
            if (lightChar.properties() & QLowEnergyCharacteristic::Notify) {
                QLowEnergyDescriptor notification = lightChar.descriptor(QBluetoothUuid::DescriptorType::ClientCharacteristicConfiguration);
                if (notification.isValid()) {
                    service->writeDescriptor(notification, QByteArray::fromHex("0100"));
                    // 检查写入结果
                    if (service->error() != QLowEnergyService::NoError) {
                        qWarning() << "启用灯通知失败:" << service->error();
                    } else {
                        qDebug() << "灯通知已启用";
                    }
                }
            }
        }
        else{
            qDebug() << "灯特征无效，UUID可能不匹配";
            return;
        }

        // 获取命令特性
        QBluetoothUuid commandUuid(Command_UUID);
        m_commandCharacteristic = service->characteristic(QBluetoothUuid(commandUuid));
        if (m_commandCharacteristic.isValid()) {
            qDebug() << "发现命令特性";
        } else {
            qWarning() << "未发现命令特性";
        }

        m_connected = true;
        emit connectionStatusChanged(true);
    }
}
// 特征改变
void BlueToothController::characteristicChanged(QLowEnergyCharacteristic characteristic, QByteArray newValue)
{
    qDebug() << "接收到通知: " << characteristic.uuid().toString() << "Raw value:" << newValue;

    if (characteristic.uuid() == QBluetoothUuid(Temperature_UUID)) {
        // 直接将接收到的字节数组转换为QString，因为ESP32发送的是字符串
        QString temp = QString::fromUtf8(newValue);

        if (m_temperature != temp) {
            m_temperature = temp;
            qDebug() << "[信号]温度更新:" << m_temperature;
            emit temperatureChanged(m_temperature);
        }
    }
    else if (characteristic.uuid() == QBluetoothUuid(Humidity_UUID)) {
        // 直接将接收到的字节数组转换为QString，因为ESP32发送的是字符串
        QString humi = QString::fromUtf8(newValue);

        if (m_humidity != humi) {
            m_humidity = humi;
            qDebug() << "[信号]湿度更新:" << m_humidity;
            emit humidityChanged(m_humidity);
        }
    }
    else if (characteristic.uuid() == QBluetoothUuid(Light_UUID)) {

        if (newValue.size() < 16) {
            qWarning() << "数据长度不足16字节";
            return;
        }

        const uint8_t *raw = reinterpret_cast<const uint8_t*>(newValue.constData());

        bool ledStates[8];
        for (int i=0; i<8; ++i) {
            ledStates[i] = (raw[i] != 0); // 非零视为开启
        }
        uint8_t brightnessValues[8];
        memcpy(brightnessValues, raw + 8, 8); // 直接复制内存块

        emit ledsStateChanged(ledStates, brightnessValues);
        qDebug() << "[信号]灯状态同步:";
    }
}

void BlueToothController::errorOccurred(QLowEnergyController::Error error)
{
    qWarning() << "Controller error:" << error;
}

void BlueToothController::onAdjustBrightness(int id, int value){

    qDebug() << "灯光：" << id << " 调整亮度：" << value;
    QString commend = "led1:" + QString::number(id) + "," + QString::number(value);
    sendCommand(commend);
}
