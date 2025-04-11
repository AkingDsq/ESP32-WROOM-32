#include <driver/i2s.h>

#include "WiFi_Connect.h"
#include "BlueTooth_Connect.h"
/*
数据引脚(DIN/DOUT)可以分配到大多数GPIO
时钟(BCK)和字选择(WS)引脚通常可以分配到以下GPIO：
对于I2S0：GPIO0-15, 16-17(仅输入), 18-19, 21-23, 25-27, 32-39
对于I2S1：GPIO16-17, 18-19, 21-23, 25-27
*/
// 引脚定义
#define I2S_SCK 18
#define I2S_WS 19
#define I2S_SD 23
// 麦克风相关参数
#define I2S_PORT I2S_NUM_0
#define SAMPLE_RATE 16000
#define SAMPLE_BITS 16
#define BUFFER_SIZE 1024
// 语音活动检测阈值
#define VAD_THRESHOLD 500
bool isRecording = false;
unsigned long recordingStartTime = 0;
const unsigned long maxRecordingTime = 3000; // 最大录音时长

void init_Microphone() {
  // 配置I2S
  i2s_config_t i2s_Microphone_config = {
    .mode = (i2s_mode_t)(I2S_MODE_MASTER | I2S_MODE_RX),
    .sample_rate = SAMPLE_RATE,
    .bits_per_sample = (i2s_bits_per_sample_t)SAMPLE_BITS,
    .channel_format = I2S_CHANNEL_FMT_ONLY_LEFT,
    .communication_format = I2S_COMM_FORMAT_STAND_I2S,
    .intr_alloc_flags = ESP_INTR_FLAG_LEVEL1,
    .dma_buf_count = 8,
    .dma_buf_len = 64,
    .use_apll = false,
    .tx_desc_auto_clear = false,
    .fixed_mclk = 0
  };

  i2s_pin_config_t pin_Microphone_config = {
    .bck_io_num = I2S_SCK,
    .ws_io_num = I2S_WS,
    .data_out_num = -1, // 未使用
    .data_in_num = I2S_SD
  };

  // 初始化I2S驱动
  i2s_driver_install(I2S_PORT, &i2s_Microphone_config, 0, NULL);
  i2s_set_pin(I2S_PORT, &pin_Microphone_config);
}

// 处理音频数据并发送
void processAudio() {
  static int16_t audioBuffer[BUFFER_SIZE];
  size_t bytesRead;
  
  i2s_read(I2S_PORT, audioBuffer, BUFFER_SIZE * sizeof(int16_t), &bytesRead, portMAX_DELAY);
  
  // 计算音频能量
  int32_t energy = 0;
  for (int i = 0; i < bytesRead / sizeof(int16_t); i++) {
    energy += abs(audioBuffer[i]);
  }
  energy /= (bytesRead / sizeof(int16_t));
  //Serial.println(energy);
  
  // 语音活动检测
  //if (energy > VAD_THRESHOLD) {
  if (getTemp()) {
    
    if (!isRecording) {
      isRecording = true;
      recordingStartTime = millis();
      Serial.println("检测到语音，开始录音...");
    }
    
    // 发送音频数据到Android应用
    if (WiFi.status() == WL_CONNECTED) {
      sendAudioData((uint8_t*)audioBuffer, bytesRead);
    }
    
    // 检查是否超过最大录音时长
    if (millis() - recordingStartTime > maxRecordingTime) {
      isRecording = false;
      Serial.println("达到最大录音时间，停止录音。");
      changeTemp();
    }
  } else {
    if (isRecording && (millis() - recordingStartTime > 500)) {
      isRecording = false;
      Serial.println("语音结束，停止录音。");
      changeTemp();
    }
  }
}
