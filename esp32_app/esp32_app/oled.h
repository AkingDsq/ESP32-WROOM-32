#include <Wire.h>
#include "SSD1306.h"

SSD1306 display(0x3c, 2, 15);

void oled_init() {
  display.init();

  display.setFont(ArialMT_Plain_16);
  display.drawString(0, 16, "Hello World");
  display.display();
}