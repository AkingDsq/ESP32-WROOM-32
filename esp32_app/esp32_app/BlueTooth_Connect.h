#include "BluetoothSerial.h"

#include "BluetoothA2DPSink.h"

BluetoothSerial SerialBT;
BluetoothA2DPSink a2dp_sink;

// 连接经典蓝牙
void BlueTooth_Connect() {
  // 若未连接，启动蓝牙并等待连接
  if (!SerialBT.connected()) {
    SerialBT.end(); // 确保蓝牙未激活
    SerialBT.begin("ESP32_SPP"); // 蓝牙名称
    Serial.println("等待蓝牙连接...");
  }
}

// 检测蓝牙的连接情况
bool isConnect_BlueTooth(){
  if (SerialBT.connected()) { // 检查连接状态
    return true;
  } else {
    return false;
  }
}
// 蓝牙传输音频数据
void Connect_BlueTooth_MusicPlayer() {
  // 初始化I2S配置
  static const i2s_config_t i2s_config = {
    .mode = (i2s_mode_t)(I2S_MODE_MASTER | I2S_MODE_TX),
    .sample_rate = 44100,  // 标准音频采样率
    .bits_per_sample = I2S_BITS_PER_SAMPLE_16BIT,
    .channel_format = I2S_CHANNEL_FMT_RIGHT_LEFT,
    .communication_format = I2S_COMM_FORMAT_STAND_I2S,
    .intr_alloc_flags = 0,
    .dma_buf_count = 8,
    .dma_buf_len = 64,
    .use_apll = false
  };

  // 配置I2S引脚（根据硬件连接调整）
  static const i2s_pin_config_t pin_config = {
    .bck_io_num = 27,    // BCKL 引脚
    .ws_io_num = 26,     // LRC 引脚
    .data_out_num = 14,  // DOUT 引脚
    .data_in_num = I2S_PIN_NO_CHANGE
  };

  // 初始化A2DP接收器
  a2dp_sink.set_i2s_config(i2s_config);
  a2dp_sink.set_pin_config(pin_config);
  a2dp_sink.start("ESP32_SPP"); // 蓝牙设备名称
}