// 多线程
//#include "freertos/FreeRTOS.h"
//#include "freertos/task.h"
// BlueTooth
#include "BlueTooth_Connect.h"
// ssd1306显示屏
#include "oled.h"
// Microphone
//#include "Microphone.h"

void setup() {
  Serial.begin(115200);
  // 显示屏
  oled_init();
  // 连接蓝牙
  //BlueTooth_Connect();
  init_TH();
  init_BLE();
  //init_A2DPSink();
  
  //init_Microphone();

  Serial.println("OK");
}

void loop() {
  // 保持空循环，避免看门狗触发
  delay(1000);
  //GetData_BlueToothConnect();
  TH_display(readSensors());
}