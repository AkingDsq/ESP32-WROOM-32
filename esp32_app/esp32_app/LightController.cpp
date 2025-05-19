#include "LightController.h"

LightController::LightController(){
  FastLED.addLeds<WS2812, LED_PIN, GRB>(leds, NUM_LEDS);
    FastLED.setBrightness(BRIGHTNESS);
    
    // 初始化状态数组
    for(int i=0; i<NUM_LEDS; i++){
      ledStates[i].color = CHSV(0, 0, 0);  // 初始黑色
      ledStates[i].savedValue = 100;       // 默认最大亮度
      ledStates[i].isOn = false;           // 初始关闭状态
    }
    updateAllLeds();
}


// 更新单个LED显示
void LightController::updateLed(int index) {
  if(ledStates[index].isOn) {
    hsv2rgb_rainbow(ledStates[index].color, leds[index]);
  } else {
    leds[index] = CRGB::Black;
  }
}

// 批量更新显示
void LightController::updateAllLeds() {
  for(int i=0; i<NUM_LEDS; i++) {
    updateLed(i);
  }
  FastLED.show();
}

// 设置HSV颜色
void LightController::setHSV(int index, uint8_t h, uint8_t s, uint8_t v) {
  Serial.println("灯" + String(index) + "更改颜色为:" + String(h) + " " + String(s) + " " + String(v));
  if(index >= NUM_LEDS) return;
  
  ledStates[index].color.hue = h;
  ledStates[index].color.sat = s;
  ledStates[index].color.value = v;
  ledStates[index].isOn = (v > 0);
  
  if(v > 0) ledStates[index].savedValue = v; // 保存有效亮度
  updateLed(index);
  FastLED.show();
}

// 设置独立亮度
void LightController::setBrightness(int index, uint8_t value) {
  Serial.println("灯" + String(index) + "更改亮度为:" + String(value));
  if(index >= NUM_LEDS) return;
  
  ledStates[index].color.value = value;
  ledStates[index].isOn = (value > 0);
  
  if(value > 0) {
    ledStates[index].savedValue = value; // 更新记忆亮度
  }
  updateLed(index);
  FastLED.show();
}

// 开关切换（带亮度记忆）
void LightController::toggleLed(int index) {
  Serial.println("灯开关" + String(index));
  if(index >= NUM_LEDS) return;
  
  ledStates[index].isOn = !ledStates[index].isOn;
  
  if(ledStates[index].isOn) {
    // 恢复记忆亮度
    ledStates[index].color.value = ledStates[index].savedValue;
  } else {
    // 保存当前亮度后关闭
    ledStates[index].savedValue = ledStates[index].color.value;
    ledStates[index].color.value = 0;
  }
  updateLed(index);
  FastLED.show();
}

LightController::LedState* LightController::getState(){
  return ledStates;
}