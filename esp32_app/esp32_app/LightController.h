#ifndef LIGHT_CONTROLLER_H 
#define LIGHT_CONTROLLER_H

#include <FastLED.h>
#include "Singleton.h"

#define LED_PIN     12
#define NUM_LEDS    8
#define BRIGHTNESS  255

class LightController : public Singleton<LightController>{
friend class Singleton<LightController>; // 允许基类访问私有构造
private:
  CRGB leds[NUM_LEDS];

  // 私有化构造函数
  LightController();
  // 删除拷贝构造和赋值
  LightController(const LightController&) = delete;
  LightController& operator = (const LightController&) = delete;

public: 
  // LED状态结构体
  struct LedState {
    CHSV color;          // 存储HSV颜色值
    uint8_t savedValue;  // 记忆的亮度值
    bool isOn;           // 当前开关状态
  };
  // 更新单个LED显示
  void updateLed(int index);
  // 批量更新显示
  void updateAllLeds();
  // 设置HSV颜色
  void setHSV(int index, uint8_t h, uint8_t s, uint8_t v);
  // 设置独立亮度
  void setBrightness(int index, uint8_t value);
  // 开关切换（带亮度记忆）
  void toggleLed(int index);
  // 获取灯的状态
  LedState* getState();
private:
  LedState ledStates[NUM_LEDS]; // 状态存储数组
};
#endif

