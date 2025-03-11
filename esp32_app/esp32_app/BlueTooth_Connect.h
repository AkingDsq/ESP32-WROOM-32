#include "BluetoothSerial.h"

BluetoothSerial SerialBT;

// 连接经典蓝牙
void BlueTooth_Connect() {
  // 若未连接，启动蓝牙并等待连接
    SerialBT.begin("ESP32_SPP"); // 蓝牙名称
    Serial.println("等待蓝牙连接...");
}
// 接收数据
void GetData_BlueToothConnect() {
  if (SerialBT.connected()) {
    // 处理数据接收
    if (SerialBT.available()) {
      char cmd = SerialBT.read();
      if (cmd == 'R') { // 假设 'R' 为开始录音指令
        //startRecording();
      }
    }
  }
  delay(100);
}

// 检测蓝牙的连接情况
bool isConnect_BlueTooth(){
  if (SerialBT.connected()) { // 检查连接状态
    return true;
  } else {
    return false;
  }
}