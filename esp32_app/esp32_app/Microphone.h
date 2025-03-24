#include <driver/i2s.h>

// 引脚定义
#define I2S_BCLK 33
#define I2S_LRCLK 25
#define I2S_DIN 32

void init_Microphone() {
  // 配置I2S
  i2s_config_t i2s_Microphone_config = {
    .mode = (i2s_mode_t)(I2S_MODE_MASTER | I2S_MODE_RX),
    .sample_rate = 16000,
    .bits_per_sample = I2S_BITS_PER_SAMPLE_32BIT,
    .channel_format = I2S_CHANNEL_FMT_ONLY_LEFT,
    .communication_format = I2S_COMM_FORMAT_STAND_I2S,
    .intr_alloc_flags = 0,
    .dma_buf_count = 8,
    .dma_buf_len = 64,
    .use_apll = false
  };

  i2s_pin_config_t pin_Microphone_config = {
    .bck_io_num = I2S_BCLK,
    .ws_io_num = I2S_LRCLK,
    .data_out_num = -1, // 未使用
    .data_in_num = I2S_DIN
  };

  // 初始化I2S驱动
  i2s_driver_install(I2S_NUM_0, &i2s_Microphone_config, 0, NULL);
  i2s_set_pin(I2S_NUM_0, &pin_Microphone_config);
}

void outPut() {
  int32_t raw_samples[128];
  size_t bytes_read;
  
  // 读取I2S数据
  i2s_read(I2S_NUM_0, raw_samples, sizeof(raw_samples), &bytes_read, portMAX_DELAY);
  
  // 计算音量（RMS）
  float sum = 0;
  int samples = bytes_read / sizeof(int32_t);
  for (int i = 0; i < samples; i++) {
    int32_t sample = raw_samples[i] >> 8; // 提取24位有效数据
    sum += (sample * sample);
  }
  float rms = sqrt(sum / samples);
  
  // 输出音量值
  Serial.println(rms);
  delay(50);
}