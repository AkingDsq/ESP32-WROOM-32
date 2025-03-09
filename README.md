# ESP32-WROOM-32
 学习ESP32-WROOM-32 
### 注意：
使用的是Arduino IDE测试并拷贝程序所以需要其开发环境, 相关教程可在此网站上找到

`https://doc.itprojects.cn/A0022.esp32.arduino/01.doc.bc474157992b15c366439040fd61543c/index.html#/01.esp32.arduino.build.dev`
## （一）IIC-OLED-1306显示屏
### 和ESP32-WROOM-32连线 
连线按照此图连接即可：
![IIC-OLED-1306连线图](https://github.com/AkingDsq/ESP32-WROOM-32/blob/main/images/IIC-OLED-1306连线图.png)
### 测试程序
程序需要使用resources文件夹中的`ESP8266_and_ESP32_OLED_driver_for_SSD1306_displays。zip`库 

需要下载下来并且导入Arduino IDE库，如下图：
![导入库](https://github.com/AkingDsq/ESP32-WROOM-32/blob/main/images/导入库.png)

导入后测试程序在`esp32_oled`文件夹中,将程序拷贝至`ESP32-WROOM-32`后就会显示hellow world
## （二）

## （三）

## Linux下交叉编译

### 下载VMware 

### 下载ubuntu-24.04.2-desktop-amd64.iso 

`https://mirrors.aliyun.com/ubuntu-releases/?spm=a2c6h.25603864.0.0.6781d6deYyXSkU` 

### 下载qt-everywhere-src-6.8.2.tar.xz 

`https://download.qt.io/archive/qt/6.8/6.8.2/single/` 

### 下载qt-unified-linux-x64-online.run  

`https://download.qt.io/official_releases/online_installers/` 

### 下载tslib-1.23.tar.xz 

`https://github.com/libts/tslib/releases` 

### 下载交叉编译工具gcc-arm-linux-gnueabihf

`# Ubuntu/Debian 安装 ARM 交叉编译器（ARMv7/AArch64）

sudo apt update 

sudo apt install gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf

arm-linux-gnueabihf-g++ --version  # 验证编译器, 输出应包含 "Target: arm-linux-gnueabihf"` 

### 共享给虚拟机 

### 交叉编译tslib 

复制进文件夹解压后，进入解压目录，看到compile为止，鼠标右击空白地方，进入终端 

`./configure --host=arm-linux-gnueabihf --prefix=<输出目录> --enable-inputapi=no` 

`make & make install` 

#### 注意：（这里可能会报错没有make命令, 执行`sudo apt-get install make`即可下载make命令包）

执行完make命令后就会生成文件到输出目录 

### 交叉编译qt-everywhere-src-6.8.2.tar.xz 
#### 安装基础依赖 

`sudo apt install build-essential libgl1-mesa-dev libfontconfig1-dev libxkbcommon-dev` 

#### 交叉编译

复制进文件夹解压后，进入解压目录 

首先进入 ./<解压目录>/qtbase/mkspecs，复制并修改平台配置：

linux-arm-gnueabi-gcc文件夹重命名为linux-arm-gnueabihf-gcc 

进入qmake.comfig修改

QMAKE_CC                = arm-linux-gnueabihf-gcc 

QMAKE_CXX               = arm-linux-gnueabihf-g++ 

QMAKE_LINK              = arm-linux-gnueabihf-g++ 

QMAKE_LINK_SHLIB        = arm-linux-gnueabihf-g++ 

QMAKE_AR                = arm-linux-gnueabihf-ar cqs 

QMAKE_OBJCOPY           = arm-linux-gnueabihf-objcopy 

QMAKE_NM                = arm-linux-gnueabihf-nm -P 

QMAKE_STRIP             = arm-linux-gnueabihf-strip 


然后进入./<解压目录>，也就是qtbase所在目录，看到compile为止，鼠标右击空白地方，进入终端 

`./configure \
  -xplatform linux-arm-gnueabihf-g++ \          # 指定目标平台
  -prefix /home/akingdsq/work/qt-everywhere-src-6.8.2/arm-release \                   # 安装路径
  -I /home/akingdsq/work/tslib_release/include \                       # tslib 头文件路径
  -L /home/akingdsq/work/tslib_release/lib \                           # tslib 库路径
  -opensource -confirm-license \                # 接受开源协议
  -release \                                    # 编译为发布版本
  -nomake examples -nomake tests \              # 跳过示例和测试
  -opengl es2 \                                 # 启用 OpenGL ES 支持
  -qt-libjpeg -qt-libpng \                      # 启用图像格式支持
  -- \
  -DCMAKE_C_COMPILER=arm-linux-gnueabihf-gcc \  # 显式指定编译器
  -DCMAKE_CXX_COMPILER=arm-linux-gnueabihf-g++` 

#### 注意：具体的路径需要根据自身修改即可，每种参数的意义都在每个参数的后面用#注释了 

-xplatform linux-arm-gnueabihf-g++ \ # 指定目标平台 

-prefix /home/akingdsq/work/qt-everywhere-src-6.8.2/arm-release \  # 安装路径 

-I /home/akingdsq/work/tslib_release/include \  # tslib 头文件include路径 

-L /home/akingdsq/work/tslib_release/lib \   # tslib 库lib路径 

-opensource -confirm-license \  # 接受开源协议 

-release \  # 编译为发布版本 

-nomake examples -nomake tests \  # 跳过示例和测试 

-opengl es2 \  # 启用 OpenGL ES 支持 

-qt-libjpeg -qt-libpng \   # 启用图像格式支持 

-- \ -DCMAKE_C_COMPILER=arm-linux-gnueabihf-gcc \  # 显式指定编译器 

-DCMAKE_CXX_COMPILER=arm-linux-gnueabihf-g++

#### （可能报错cmake没有找到，执行`sudo apt install cmake`安装cmake，`cmake --version`验证）

tslib需先编译并安装，Qt通过 -I 和 -L 参数引用其路径。 

-platform: 用于指定主机平台。

-xplatform: 用于指定目标平台。

-device: 用于指定目标设备。

-device-option: 用于指定交叉编译工具链前缀。

-prefix: 用于指定安装目录。

-I: 之前所编译好的QT触摸库tslab的include路径 

-L: 之前所编译好的QT触摸库tslab的lib路径 

然后执行make命令 

`sudo chown -R $USER:$USER /home/akingdsq/work/qt-everywhere-src-6.8.2/arm-release && make -j$(nproc) && sudo make install`

执行完make命令后就会生成文件到输出目录 


