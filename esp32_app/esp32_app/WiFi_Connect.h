// WiFi
#include <WiFi.h>
#include <WiFiUdp.h>

// 定义 Wi-Fi 名与密码
const char * ssid = "laodong";   //需要输入自己的WIFI名字
const char * password = "dsq245349";   //需要输入自己的WIFI密码
// 手机IP地址
const char* udpAddress = "10.189.146.79"; // Android设备IP
const int udpPort = 12345;
WiFiUDP udp;
// // 
// const char* ntpServer = "pool.ntp.org";  // NTP服务器地址
// const long utcOffsetInSeconds = 28800;  // 北京时间：UTC+8，单位为秒

// void WiFi_init() {
// //-----------------连接WIFI--------------//
//   // wifi模式
//   Serial.begin(115200);

//   // 断开之前的连接
//   WiFi.disconnect(true);
//   // 连接 Wi-Fi
//   WiFi.begin(ssid, password);

//   // 热点模式
//   // Serial.begin(115200);
//   // WiFi.softAP(ssid, password);  // 将 ESP32 设置为热点

//   Serial.print("正在连接 Wi-Fi");
  
//   // 检测是否链接成功
//   while (WiFi.status() != WL_CONNECTED) {
//     delay(1000);
//     Serial.print(".");
//   }
//   Serial.println("连接成功");
//   Serial.print("IP address: ");
//   Serial.println(WiFi.localIP());

//   udp.begin(udpPort);
//   //Serial.println(WiFi.softAPIP());  // 打印热点的IP地址
// //-----------------连接WIFI--------------//
// }

const uint32_t timeout = 8000; // 单次连接超时8秒
uint8_t maxRetries = 3;        // 最大重试次数

void connectWiFi() {
  if (WiFi.status() == WL_CONNECTED) {
    return;
  }

  uint8_t attempts = 0;
  
  while (attempts < maxRetries) {
      WiFi.begin(ssid, password);
      uint32_t start = millis();
      
      while (WiFi.status() != WL_CONNECTED && millis()-start < timeout) {
          delay(200);
          Serial.print(".");
      }
      
      if (WiFi.status() == WL_CONNECTED) {
          Serial.println("\nConnected! IP: " + WiFi.localIP().toString());
          udp.begin(udpPort);
          break;
      }
      
      Serial.println("\nConnection failed, retrying...");
      attempts++;
  }
  if(attempts >= maxRetries){
    Serial.println("Max retries reached, rebooting...");
    ESP.restart();
  }
}

// 发送音频数据
void sendAudioData(uint8_t* data, size_t bytesRead) {
  // UDP
  udp.beginPacket(udpAddress, udpPort);
  udp.write(data, bytesRead);
  udp.endPacket();
  
  Serial.print("发送音频数据: ");
  Serial.println(bytesRead);
}