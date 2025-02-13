
#include <Wire.h>
#include "SSD1306.h"

SSD1306 display(0x3c, 21, 22);

void setup() {
  display.init();

  display.setFont(ArialMT_Plain_16);
  display.drawString(10, 10, "Hello World");
  display.display();
}

void loop() {
 
}
