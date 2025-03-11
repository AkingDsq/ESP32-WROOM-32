// 多线程
//#include "freertos/FreeRTOS.h"
//#include "freertos/task.h"
// musicPlayer
#include "MusicPlayer.h"
// BlueTooth
#include "BlueTooth_Connect.h"
// ssd1306显示屏
#include "oled.h"

void setup() {
  Serial.begin(115200);

  // 连接蓝牙
  init();

  // 显示屏
  oled_init();

  Serial.println("OK");
}

void loop() {
  // 保持空循环，避免看门狗触发
  delay(1000);
}