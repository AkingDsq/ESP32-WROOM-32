// 多线程
#include "freertos/FreeRTOS.h"  // FreeRTOS核心头文件
#include "freertos/task.h"      // 任务管理相关函数（如xTaskCreate）
// MAX98357a
#include "I2S.h"
// BlueTooth
#include "BlueTooth_Connect.h"
void BlueTooth_Connect(void *pvParameters); //声明蓝牙连接
// WiFi
// include "WiFi_Connect.h"
// void WiFi_Connect(void *pvParameters); //声明WIFi

void setup() {
  Serial.begin(115200);

  // 初始化I2S，并播放音频
  init_I2S();

  // 连接蓝牙
  xTaskCreate(
    BlueTooth_Connect,    // 任务函数
    "BlueTooth_Connect",      // 任务名
    4096,          // 栈大小（字节）
    NULL,           // 参数
    3,              // 优先级（最高为configMAX_PRIORITIES-1）
    NULL           // 任务句柄
  );

  // // // 连接WiFi
  // WiFi_Connect();
  // // xTaskCreate(WiFi_Connect, "WiFi_Connect", 256, NULL, 3, NULL);

  Serial.println("OK");
}

void loop() {
  // time_Display();
}

//声明蓝牙连接
void BlueTooth_Connect(void *pvParameters){
  while(1){
    BlueTooth_Connect();
    vTaskDelay(100 / portTICK_PERIOD_MS); // 让出 CPU
  }
}

//声明WIFi
// void WiFi_Connect(void *pvParameters){
//   while(1){
//     Serial.println("WiFi_Connect");
//   }
//   delay(1000);
// }