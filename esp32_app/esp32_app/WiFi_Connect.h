#include <Wire.h>
#include "SSD1306.h"
#include <WiFi.h>  // 引入ESP32 WiFi库
#include <HTTPClient.h>
#include <time.h>

// 定义 Wi-Fi 名与密码
const char * ssid = "laodong";   //需要输入自己的WIFI名字
const char * password = "dsq245349";   //需要输入自己的WIFI密码
// 
const char* ntpServer = "pool.ntp.org";  // NTP服务器地址
const long utcOffsetInSeconds = 28800;  // 北京时间：UTC+8，单位为秒
// 
SSD1306 display(0x3c, 21, 22);

void BlueTooth_Connect() {
//-----------------连接WIFI--------------//
  // wifi模式
  Serial.begin(115200);

  // 断开之前的连接
  WiFi.disconnect(true);
  // 连接 Wi-Fi
  WiFi.begin(ssid, password);

  // 热点模式
  // Serial.begin(115200);
  // WiFi.softAP(ssid, password);  // 将 ESP32 设置为热点

  Serial.print("正在连接 Wi-Fi");
  
  // 检测是否链接成功
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.print(".");
  }
  Serial.println("连接成功");
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());
  //Serial.println(WiFi.softAPIP());  // 打印热点的IP地址
//-----------------连接WIFI--------------//

//-----------------显示时间--------------//
  // 获取时间
  configTime(utcOffsetInSeconds, 0, ntpServer);
  while (!time(nullptr)) {
    delay(1000);
    Serial.println(".");
  }
  Serial.println("Time synced successfully");
  
//-----------------显示时间--------------//
}

void time_Display() {
 //-----------------显示时间--------------//
  // 获取当前时间戳
  time_t now = time(nullptr);
  struct tm* timeinfo = localtime(&now);

  // 格式化输出时间
  char timeStr[64];
  strftime(timeStr, sizeof(timeStr), "%Y-%m-%d %H:%M:%S", timeinfo);
  Serial.printf("Current Time: %s\n", timeStr);
  
  // 显示屏显示
  display.init();

  display.setFont(ArialMT_Plain_10);  // 设置字号
  display.drawString(0, 16, timeStr); // 设置显示位置和内容
  display.display(); // 显示

  delay(1000);
 //-----------------显示时间--------------//
}