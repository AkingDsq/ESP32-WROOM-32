// WiFi
#include <WiFi.h>
#include <WiFiUdp.h>

// 定义 Wi-Fi 名与密码
const char * ssid = "laodong";   //需要输入自己的WIFI名字
const char * password = "dsq245349";   //需要输入自己的WIFI密码
// 手机IP地址
const char* udpAddress = "10.113.213.18"; // Android设备IP
const int udpPort = 12345;
WiFiUDP udp;
// // 
// const char* ntpServer = "pool.ntp.org";  // NTP服务器地址
// const long utcOffsetInSeconds = 28800;  // 北京时间：UTC+8，单位为秒

void WiFi_init() {
// WiFi初始化
    WiFi.disconnect(true);
    WiFi.setAutoReconnect(true);          // 启用自动重连
    WiFi.begin(ssid, password);
    Serial.println("启动Wi-Fi连接...");

    // 连接状态变量
    bool udpInitialized = false;
    wl_status_t lastStatus = WL_IDLE_STATUS;

    while(1) {
        wl_status_t currentStatus = WiFi.status();

        if(currentStatus != lastStatus) { // 状态变化时打印
            Serial.printf("Wi-Fi状态改变: %d -> %d\n", lastStatus, currentStatus);
            lastStatus = currentStatus;
        }

        if(currentStatus == WL_CONNECTED) {
            if(!udpInitialized) {         // 初始化UDP（仅一次）
                udp.begin(udpPort);
                Serial.print("UDP初始化完成，本地端口:");
                Serial.println(udpPort);
                Serial.print("设备IP地址:");
                Serial.println(WiFi.localIP());
                udpInitialized = true;
            }
            vTaskDelay(10000 / portTICK_PERIOD_MS); // 10秒检测一次
        } 
        else {
            // 未连接时的处理（如LED闪烁）

            vTaskDelay(500 / portTICK_PERIOD_MS);  // 更频繁地检测（0.5秒）
            
            // 尝试手动重连（可选）
            if(currentStatus == WL_CONNECT_FAILED || currentStatus == WL_NO_SSID_AVAIL) {
                WiFi.reconnect();
                Serial.println("尝试主动重连...");
            }
        }
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