#include <Wire.h>
#include "SSD1306.h"

SSD1306 display(0x3c, 21, 22);

void oled_init() {
  display.init();

  display.setFont(ArialMT_Plain_16);
  
}
void TH_display(String TH){
  display.clear();
  display.drawString(0, 0, TH);
  display.display();
}