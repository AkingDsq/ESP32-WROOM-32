// // 蓝牙串口
// #include "BluetoothSerial.h"
// BluetoothSerial SerialBT;

// // A2DP
// #include "AudioTools.h"
// #include "BluetoothA2DPSink.h"
// I2SStream i2s_VoiceSink;
// BluetoothA2DPSink a2dp_sink(i2s_VoiceSink);
#include "const.h"
#include "LightController.h"

#define LED_PIN 33        // LED引脚
// BLE
#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>
#include <BLE2902.h>
#define SERVICE_UUID        "0000181A-0000-1000-8000-00805F9B34FB"
#define Temperature_UUID "2A6E" // 温度uuid
#define Humidity_UUID "2A6F"    // 湿度的uuid
#define Command_UUID "FFE1"     // 用于接收命令的特性UUID
#define Lightness_UUID "ABAB"   // 灯光的uuid

// 温湿度传感器
#include <DHT.h>
#define DHTPIN 13 // 温湿度传感器引脚
#define DHTTYPE DHT11 // 温湿度传感器类型
DHT dht(DHTPIN, DHTTYPE); // 创建DHT对象

// BLE服务初始化
BLEServer *pServer;
BLEService *pService;
BLECharacteristic *pTemperatureChar, *pHumidityChar, *pCommandChar, *pLightnessChar;

bool tmp = false;

// void init_A2DPSink();
// // 连接经典蓝牙
// void BlueTooth_Connect() {
//   Serial.begin(115200);
//   // 若未连接，启动蓝牙并等待连接
//   SerialBT.begin("ESP32"); // 蓝牙名称
//   Serial.println("等待蓝牙连接...");
// }
// // 接收数据
// void GetData_BlueToothConnect() {
//   // 处理数据接收
//   if (SerialBT.available()) {
//     char cmd = SerialBT.read();
//     if (cmd == 'Music') { // 假设 'R' 为开始录音指令

//     }
//     Serial.println(cmd);
//   }
//   delay(100);
// }
// // A2DP
// void init_A2DPSink() {
//   auto cfg = i2s_VoiceSink.defaultConfig();
//   cfg.pin_bck = 27;
//   cfg.pin_ws = 26;
//   cfg.pin_data = 14;
//   i2s_VoiceSink.begin(cfg);

//   a2dp_sink.start("ESP32");
// }
// 传感器
void init_TH(){
  dht.begin(); // 初始化温湿度传感器
}
// 处理接收到的命令的回调
class CommandCallbacks: public BLECharacteristicCallbacks {
    void onWrite(BLECharacteristic *pCharacteristic) {
      String value = pCharacteristic->getValue();
      if (value.length() > 0) {
        Serial.print("接收到命令: ");
        Serial.println(value.c_str());
        
        // 处理接收到的命令
        if (value == "LED_ON") {
          // 打开LED
          digitalWrite(LED_PIN, HIGH);
          Serial.println("LED已打开");
        } 
        else if (value == "LED_OFF") {
          // 关闭LED
          digitalWrite(LED_PIN, LOW);
          Serial.println("LED已关闭");
        }
        // 控制开关格式：led0:房间id
        else if(value.startsWith("led0:")){
          value = value.substring(5);
          int id = value.toInt();
          // 获取单例实例
          std::shared_ptr<LightController> ledCtrl = LightController::getInstance();
          ledCtrl->toggleLed(id);
        }
        // 调整亮度格式：led1:房间id,添加值
        else if(value.startsWith("led1:")){
          value = value.substring(5);
          int index = value.indexOf(",");
          int id = value.substring(0, index).toInt();

          int rawValue = value.substring(index + 1).toInt();  // 转换为整数
          uint8_t num = static_cast<uint8_t>(rawValue);

          // 获取单例实例
          std::shared_ptr<LightController> ledCtrl = LightController::getInstance();
          ledCtrl->setBrightness(id, num);
        }
        // 调整颜色：led2:房间id,HSV值参数一,HSV参数二,HSV参数三
        else if(value.startsWith("led2:")){
          value = value.substring(5);
          int index = value.indexOf(",");
          int id = value.substring(0, index).toInt();
          value = value.substring(index + 1);

          uint8_t num[3];
          for(int i = 0; i  < 2; i++){
            int index = value.indexOf(",");
            int rawValue = value.substring(0, index).toInt();
            num[i] = static_cast<uint8_t>(rawValue);
            value = value.substring(index + 1);
          }

          num[2] = static_cast<uint8_t>(value.toInt());

          // 获取单例实例
          std::shared_ptr<LightController> ledCtrl = LightController::getInstance();
          ledCtrl->setHSV(id, num[0], num[1], num[2]);
        }
        else if (value == "callTem") {
          float temperature = dht.readTemperature();
          pTemperatureChar->setValue(String(temperature));
          pTemperatureChar->notify();
        }
        else if (value == "callHem") {
          float humidity = dht.readHumidity();
          pTemperatureChar->setValue(String(humidity));
          pTemperatureChar->notify();
        } 
        else if(value == "startVoice"){
          tmp = true;
        }
        // 添加更多命令处理...
      }
    }
};

// 初始化BLE连接
void init_BLE() {
  //pinmode(LED_PIN, output)

  Serial.begin(115200);
  Serial.println("Starting BLE work!");
  // BLE服务初始化

  BLEDevice::init("ESP32-BLE");
  pServer = BLEDevice::createServer();
  pService = pServer->createService(SERVICE_UUID);

  // 温度特征（支持通知）
  pTemperatureChar = pService->createCharacteristic(
    BLEUUID(Temperature_UUID),
    BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_NOTIFY
  );
  pTemperatureChar->addDescriptor(new BLE2902());  // 关键！添加标准CCCD描述符

  // 湿度特征（支持通知）
  pHumidityChar = pService->createCharacteristic(
    BLEUUID(Humidity_UUID),
    BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_NOTIFY
  );
  pHumidityChar->addDescriptor(new BLE2902());  // 关键！添加标准CCCD描述符

  // 灯光特征（支持通知）
  pLightnessChar = pService->createCharacteristic(
    BLEUUID(Lightness_UUID),
    BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_NOTIFY
  );
  pLightnessChar->addDescriptor(new BLE2902());  // 关键！添加标准CCCD描述符

  // 添加命令特性（可写）
  pCommandChar = pService->createCharacteristic(
    BLEUUID(Command_UUID),
    BLECharacteristic::PROPERTY_WRITE
  );
  pCommandChar->setCallbacks(new CommandCallbacks());

  pService->start();
  // BLEAdvertising *pAdvertising = pServer->getAdvertising();  // this still is working for backward compatibility
  BLEAdvertising *pAdvertising = pServer->getAdvertising();
  pAdvertising->addServiceUUID(pService->getUUID());
  pAdvertising->setScanResponse(true);  // 允许扫描响应
  pAdvertising->setMinPreferred(0x06); // 提高广播优先级
  BLEDevice::startAdvertising();
  Serial.println("Characteristic defined! Now you can read it in your phone!");
}
// 数据读取并更新
String readSensors() {
  float humidity = dht.readHumidity();
  float temperature = dht.readTemperature();
  float f = dht.readTemperature(true);
  if (isnan(humidity) || isnan(temperature) || isnan(f)) {  // 检查是否为NaN
    Serial.println("读取失败!");
    return "";
  }
  float hif = dht.computeHeatIndex(f, humidity);
  // Compute heat index in Celsius (isFahreheit = false)
  float hic = dht.computeHeatIndex(temperature, humidity, false);

  // 更新特征值并通知
  pTemperatureChar->setValue(String(temperature));
  pTemperatureChar->notify();
  pHumidityChar->setValue(String(humidity));
  pHumidityChar->notify();
  Serial.println("T:" + String(temperature) +  "°C H:" + String(humidity) + "%");
  return "T:" + String(temperature) +  "°C\nH:" + String(humidity) + "%";
}
float readTem(){
  return dht.readTemperature();
}
float readHum(){
  return dht.readHumidity();
}
bool getTemp(){return tmp;}
void changeTemp(){tmp = !tmp;}
// 同步灯光
void init_light(){
  std::shared_ptr<LightController> ledCtrl = LightController::getInstance();
  LightController::LedState* leds = ledCtrl->getState();

  // 原始字节传输
  uint8_t bleData[16] = {0};
  for (int i = 0; i < 8; i++) {
      bleData[i] = leds[i].isOn;
      bleData[i+8] = leds[i].savedValue;
  }
  pLightnessChar->setValue(bleData, sizeof(bleData));
  pLightnessChar->notify();
}