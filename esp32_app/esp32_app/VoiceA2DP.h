#include <FastLED.h>

#define DIN_PIN 33  // 定义din引脚
#define LED_NUM 8   // 定义灯的数量

CRGB leds[LED_NUM]; // 定义LED数组

class LedController{
  public: 
    LedController();
    ~LedController();
    // 初始化
    void init_fastled(){
      FastLED.addLeds<WS2812, DIN_PIN, GRB>(leds, LED_NUM);
    }
    // 设置单独灯的亮度
    void setLedBrightness(int num, int value){
      if(num < 1) return;
      leds[num - 1] = leds[num - 1].nscale8(value);

      FastLED.show();
    }
  private:

};


