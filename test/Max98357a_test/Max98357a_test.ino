#include "AudioTools.h"
#include "wav_data.h" // 包含嵌入的音频数据
// 定义I2S引脚
#define BCLK_PIN 27
#define LRCLK_PIN 26
#define DIN_PIN 14

I2SStream i2s; // I2S音频输出对象

void setup() {
  Serial.begin(115200);

  // 配置I2S
  auto cfg = i2s.defaultConfig();
  cfg.sample_rate = 44100;    // 必须与WAV文件采样率一致
  cfg.bits_per_sample = 16;   // 必须与WAV文件位深一致
  cfg.channels = 1;           // 必须为单声道
  cfg.pin_bck = BCLK_PIN;
  cfg.pin_ws = LRCLK_PIN;
  cfg.pin_data = DIN_PIN;
  i2s.begin(cfg);

  // 直接播放嵌入的音频数据（跳过44字节WAV头）
  i2s.write(wav_data + 44, wav_data_len - 44);

  Serial.println("OK");
}

void loop() {

}