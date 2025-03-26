// 多线程
#include "freertos/task.h"
// BlueTooth
#include "BlueTooth_Connect.h"
// ssd1306显示屏
#include "oled.h"
// Microphone
#include "Microphone.h"
// WiFi
#include "WiFi_Connect.h"

// 传感器传输数据线程
void sensorTask(void *pvParam) {
  while(1) {
    TH_display(readSensors());
    vTaskDelay(2000 / portTICK_PERIOD_MS);
  }
}
// 麦克风处理任务
void audioTask(void *pvParameter) {
  while(1) {
    processAudio();
    vTaskDelay(10 / portTICK_PERIOD_MS);  // 保持较高频率采样
  }
}

void setup() {
  Serial.begin(115200);

  // 显示屏
  oled_init();
  // 连接蓝牙
  init_TH();
  init_BLE();
  //init_A2DPSink();
  init_Microphone();
  // WiFi
  WiFi_init();

  xTaskCreate(sensorTask, "SensorTask", 4096, NULL, 1, NULL);
  xTaskCreate(audioTask, "AudioTask", 4096, NULL, 1, NULL);

  Serial.println("OK");
}

void loop() {
  // 保持空循环，避免看门狗触发
  delay(10); // 适当释放CPU
}