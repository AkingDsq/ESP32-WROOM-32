# ESP32-WROOM-32
 学习ESP32-WROOM-32 
### 注意：
使用的是Arduino IDE测试并拷贝程序所以需要其开发环境, 相关教程可在此网站上找到

`https://doc.itprojects.cn/A0022.esp32.arduino/01.doc.bc474157992b15c366439040fd61543c/index.html#/01.esp32.arduino.build.dev` 
## 组件列表

如果不想焊接建议购买焊了排针的组件 

| 组件名称| 型号| 数量| 功能| 照片|
|---- |------- |----|-------|------|
| esp32| ESP32-WROOM-32 | 1 | 单片机 | ![ESP32-WROOM-32](https://github.com/AkingDsq/ESP32-WROOM-32/blob/main/images/ESP32-WROOM-32.jpg)|
| 麦克风| INMP441 | 1 | 输入输出音频数据 |![INMP441](https://github.com/AkingDsq/ESP32-WROOM-32/blob/main/images/INMP441_2.jpg)|
| 温湿度传感器| DHT11 | 1 | 检测温湿度 |![DHT11](https://github.com/AkingDsq/ESP32-WROOM-32/blob/main/images/DHT11.jpg)|
| 光传感器| GY-302 BH1750 | 1 | 检测光强度光照度 |![GY-302 BH1750](https://github.com/AkingDsq/ESP32-WROOM-32/blob/main/images/GY-302_BH1750.jpg)|
| 0.96寸显示屏| IIC-OLED-1306 | 1 | 显示屏显示相关内容如温湿度 |![IIC-OLED-1306连线图](https://github.com/AkingDsq/ESP32-WROOM-32/blob/main/images/IIC-OLED-1306.jpg)|
|音频放大器（推荐配套3W喇叭使用） | MAX98357 | 1 | 音频 |![MAX98357](https://github.com/AkingDsq/ESP32-WROOM-32/blob/main/images/MAX98357.jpg)|
|3W喇叭 | 3w | 1 | 输出音频 |![3W喇叭](https://github.com/AkingDsq/ESP32-WROOM-32/blob/main/images/3W喇叭.jpg)|
| 全彩发光二极管| 8位WS2812 | 1 | 模拟开关灯 |![8位WS2812](https://github.com/AkingDsq/ESP32-WROOM-32/blob/main/images/8位WS2812.jpg)|
| 电源| 5v | 1 | 给8位WS2812供电 |![5v电源](https://github.com/AkingDsq/ESP32-WROOM-32/blob/main/images/5v电源.jpg)|
| 面包板| 5*5.5（任意） | 2（根据需求） | 作为电路板 |![面包板](https://github.com/AkingDsq/ESP32-WROOM-32/blob/main/images/面包板.jpg)|
| 面包条线| 任意 | 1（根据需求） | 连接电路 |![面包条线](https://github.com/AkingDsq/ESP32-WROOM-32/blob/main/images/面包条线.jpg)|
| PH2.0mm公头线| 2.0mm | 2（根据需求） | 作为电路板 |![PH2.0mm公头线](https://github.com/AkingDsq/ESP32-WROOM-32/blob/main/images/PH2.0mm公头线.jpg)|

## 连线

![电路图](https://github.com/AkingDsq/ESP32-WROOM-32/blob/main/images/电路图.jpg)

### （一）IIC-OLED-1306显示屏
#### 和ESP32-WROOM-32连线 
连线按照此图连接即可：
| IIC-OLED-1306|esp32|
|---|---|
|VCC |3V3|
|GND |GND|
|SCL |D22|
|SDA |D21|

![IIC-OLED-1306连线图](https://github.com/AkingDsq/ESP32-WROOM-32/blob/main/images/IIC-OLED-1306连线图.png)
#### 测试程序
程序需要使用resources文件夹中的`ESP8266_and_ESP32_OLED_driver_for_SSD1306_displays.zip`库 

需要下载下来并且导入Arduino IDE库，如下图：
![导入库](https://github.com/AkingDsq/ESP32-WROOM-32/blob/main/images/导入库.png)

导入后测试程序在`test/esp32_oled_test/esp32_oled`文件夹中, 将程序拷贝至`ESP32-WROOM-32`后就会显示hellow world
### (二) INMP441
#### 和ESP32-WROOM-32连线 
| INMP441|esp32|
|---|---|
|VDD |3V3|
|GND |GND|
|SD |D23|
|L/R |GND|
|WS |D19|
|SCK |D18|

#### 测试程序
测试程序在`test/INMP441_test`文件夹中, 将程序拷贝至`ESP32-WROOM-32`后就在arduinoIDE中观察是否有输出
### （三）MAX98357
#### 和ESP32-WROOM-32连线 
| MAX98357|esp32|
|---|---|
|VIN |VIN|
|GND |GND|
|LRC |D26|
|BCLK |D27|
|DIN |D14|

#### 测试程序
测试程序在`test/Max98357a_test`文件夹中, 将程序拷贝至`ESP32-WROOM-32`后是否有音频输出
## 蓝牙双向通信协议

指令类型	     发送方	      指令内容	  预期响应	      数据格式
模式切换	  Qt Android	     "AI"	     无	        UTF-8字符串
模式确认	  ESP32(Source)	  "music"	 发送音频数据流	PCM 16bit/44kHz
状态反馈	    ESP32	        "OK"	 通知模式状态	   BLE NOTIFY

## 

|--------------------------------------------------------------------------------| 

## Linux下交叉编译

### 下载VMware 

#### 共享文件夹

##### 安装open-vm-tools(与主机共享文件夹并且提供复制与粘贴的功能)

`sudo apt update && sudo apt install open-vm-tools open-vm-tools-desktop` 

##### 验证vmhgfs-fuse工具是否存在, 运行命令：

`command -v vmhgfs-fuse` 

若未找到，需重新安装open-vm-tools 

##### 创建挂载点（若不存在）​

`sudo mkdir -p /mnt/hgfs` 

​执行手动挂载命令

`sudo vmhgfs-fuse .host:/ /mnt/hgfs -o allow_other` 

通过`ls /mnt/hgfs`验证是否显示共享内容 

#### 使用filezilla传输文件

`https://filezilla-project.org/download.php?type=client` 

1.在使用之前要打开Ubuntu的FTP服务
打开 Ubuntu 的终端窗口，然后执行如下命令来安装 FTP 服务：

`sudo apt-get install vsftpd`

等待软件自动安装，安装完成以后使用如下 VI 命令打开/etc/vsftpd.conf，命令如下：

`sudo vi /etc/vsftpd.conf` （也可以使用图形化操作修改/etc/vsftpd.conf） 

打开以后 vsftpd.conf 文件以后找到如下两行，确保两行前面没有“#”，有的话就删除掉

local_enable=YES 

write_enable=YES

保存退出，并且使用如下命令重启 FTP 服务：

`sudo /etc/init.d/vsftpd restart` 

在虚拟机中输入`ifconfig`得到虚拟机ip地址,断端口一般默认是22或者21 

#### 使用MobaXterm远程连接Ubuntu 
Linux：

`sudo apt-get update ` 

下载SSH
 
`sudo apt install openssh-server`

检测服务是否启动

`service sshd status` 

查询IP地址

`ifconfig`

MobaXterm：

左上角Session-SSH，输入虚拟机的Ip地址和用户名，端口一般是22

### 下载ubuntu-24.04.2-desktop-amd64.iso（ubuntu镜像） 

`https://mirrors.aliyun.com/ubuntu-releases/?spm=a2c6h.25603864.0.0.6781d6deYyXSkU` 

### 下载qt-everywhere-src-6.8.2.tar.xz（交叉编译Qt库） 

`https://download.qt.io/archive/qt/6.8/6.8.2/single/` 

### 下载qt-unified-linux-x64-online.run（Qt-linux联网下载程序） 

`https://download.qt.io/official_releases/online_installers/` 

### 下载tslib-1.23.tar.xz（触摸屏模拟） 

`https://github.com/libts/tslib/releases` 

### 下载交叉编译工具gcc-arm-linux-gnueabihf
#### Ubuntu/Debian 安装 ARM 交叉编译器（ARMv7/AArch64） 

`sudo apt update` 

`sudo apt install gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf` 32位 

`sudo apt-get install gcc-aarch64-linux-gnu` 64位 

#### 验证编译器, 输出应包含 "Target: arm-linux-gnueabihf" 
 
`arm-linux-gnueabihf-g++ --version` 

`aarch64-linux-gnu-gcc --version` 

#### 安装基础依赖 

`sudo apt install build-essential libgl1-mesa-dev libfontconfig1-dev libxkbcommon-dev`

### 交叉编译tslib 

复制进文件夹解压后，进入解压目录，看到compile为止，鼠标右击空白地方，进入终端 

`./configure --host=arm-linux-gnueabihf --prefix=<输出目录> --enable-inputapi=no` 

`make & make install` 

#### 注意：（这里可能会报错没有make命令, 执行`sudo apt-get install make`即可下载make命令包）

执行完make命令后就会生成文件到输出目录 

### 交叉编译qt-everywhere-src-6.8.2.tar.xz 
参考文档： 

`https://doc.qt.io/qt-6/zh/configure-linux-device.html` 

`https://cmake.org/cmake/help/latest/manual/cmake-toolchains.7.html#cross-compiling-for-linux` 

`https://www.qt.io/blog/standalone-boot2qt-/-yocto-sdk-cmake-toolchain`

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

`./configure \ -xplatform linux-arm-gnueabihf-g++ \          # 指定目标平台 -prefix /home/akingdsq/work/qt-everywhere-src-6.8.2/arm-release \                   # 安装路径 -I /home/akingdsq/work/tslib_release/include \                       # tslib 头文件路径 -L /home/akingdsq/work/tslib_release/lib \                           # tslib 库路径 -opensource -confirm-license \                # 接受开源协议 -release \                                    # 编译为发布版本 -nomake examples -nomake tests \              # 跳过示例和测试 -opengl es2 \                                 # 启用 OpenGL ES 支持 -qt-libjpeg -qt-libpng \                      # 启用图像格式支持 -- \ -DCMAKE_C_COMPILER=arm-linux-gnueabihf-gcc \  # 显式指定编译器 -DCMAKE_CXX_COMPILER=arm-linux-gnueabihf-g++` 

#### 注意：具体的路径需要根据自身修改即可，每种参数的意义都在每个参数的后面用#注释了 

-xplatform linux-arm-gnueabihf-g++ \ # 指定目标平台 

-prefix /home/akingdsq/work/qt-everywhere-src-6.8.2/arm-release \  # 目标机安装路径 

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

### 交叉编译Qt库
安装必要依赖 

`sudo apt update` 

`sudo apt install build-essential ninja-build python3 perl git flex bison gperf \libxcb* libgl1-mesa-dev libglu1-mesa-dev libssl-dev libicu-dev libsqlite3-dev \libclang-dev zlib1g-dev` 

获取交叉编译工具链 

假设目标平台为ARM架构（如Raspberry Pi），从供应商获取工具链（示例路径：/opt/toolchain-arm），需包含：

编译器：arm-linux-gnueabihf-gcc 和 arm-linux-gnueabihf-g++ 

`sudo apt install gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf`

Sysroot：目标系统的根文件系统（如 /opt/sysroot-arm） 

#### qtHost 

##### 1. 创建源码目录并解压
mkdir qt6Host
tar -xvf qt-everywhere-src-6.2.4.tar.xz -C qt6Host --strip-components 1

##### 2. 创建独立的构建目录
mkdir qt6HostBuild && cd qt6HostBuild

#### 3. 配置构建选项（示例）
../qt-cross/configure -prefix /home/dsq2/work/qt6Host

##### 4. 编译并安装
cmake --build . --parallel 4
cmake --install . 

##### 创建cmake toolcain文件

使用cmake交叉编译Qt，需要一个toolcain.cmake文件，在文件中指定编译器路径，sysroot路径，编译链接参数等。 示例创建一个配置文件lubancat_toolchain.cmake：

##### 创建lubancat设备文件 

##### 编译配置 

#

# 编译
cmake --build . --parallel 4
# 安装
cmake --install .

# 进入sysroot目录
cd /home/dsq2/work/sysroot

# 使用apt-get下载armhf版本的库（需配置多架构）
sudo apt update  # 更新软件源
# 将主机中的依赖库复制到目标文件系统的对应目录（如 /lib）
sudo cp -L /lib/x86_64-linux-gnu/libc.so.6 /home/dsq2/work/sysroot/lib/ 

# 下载ARMHF版本的库
wget http://ports.ubuntu.com/ubuntu-ports/pool/main/z/zstd/libzstd-dev_1.5.5+dfsg2-3ubuntu1_armhf.deb
wget http://ports.ubuntu.com/ubuntu-ports/pool/main/d/dbus/libdbus-1-dev_1.12.20-2ubuntu4_armhf.deb
wget http://ports.ubuntu.com/ubuntu-ports/pool/main/g/glib2.0/libglib2.0-dev_2.76.3-0ubuntu1_armhf.deb

# 解压到sysroot
sudo dpkg -x libzstd-dev_*.deb /home/dsq2/work/sysroot/
sudo dpkg -x libdbus-1-dev_*.deb /home/dsq2/work/sysroot/
sudo dpkg -x libglib2.0-dev_*.deb /home/dsq2/work/sysroot/
# OpenGL/EGL
wget http://ports.ubuntu.com/ubuntu-ports/pool/main/m/mesa/libgles2-mesa-dev_23.2.1-1ubuntu3.1_armhf.deb
sudo dpkg -x libgles2-mesa-dev_*.deb /home/dsq2/work/sysroot/

`./configure \-prefix /opt/qt6-armhf \-extprefix /home/dsq2/work/qt-cross/arm \-xplatform linux-arm-gnueabihf-g++ \-device-option CROSS_COMPILE=arm-linux-gnueabihf- \-opensource -confirm-license \-no-pkg-config \-nomake examples \-no-feature-dbus \-no-feature-zstd \-skip qtdoc \-qt-libpng  \-no-opengl \-skip qtwebengine \-skip qtwayland \-no-xcb -- -DCMAKE_MESSAGE_LOG_LEVEL=VERBOSE \-DCMAKE_TOOLCHAIN_FILE=/home/dsq2/work/toolchain.cmake \-DCMAKE_SYSROOT=/home/dsq2/work/sysroot` 
 
`make -j$(nproc)` 

`sudo make install`

## QEMU模拟

## qemu安装 

`sudo apt install qemu-system-arm qemu-utils` 

安装完成后，检查 QEMU 支持的 ARM 机器类型：

`qemu-system-arm -machine help` 

输出应包含树莓派相关设备（如 raspi2b 或 versatilepb）：

versatilepb       ARM Versatile/PB (ARM926EJ-S) 

raspi2b          Raspberry Pi 2B

## arm开发板镜像下载安装 

`https://mirrors.tuna.tsinghua.edu.cn/raspberry-pi-os-images/` 

共享到ubuntu后解压出镜像文件 

`xz -d 2024-11-19-raspios-bookworm-armhf-full.img.xz`

## 模拟 

### 查看镜像的信息 

`sudo fdisk -l 2024-11-19-raspios-bookworm-armhf-full.img` 

`sudo fdisk -l 2024-11-19-raspios-bookworm-armhf-lite.img`

输出示例如下：

Disk raspios-bookworm-armhf-full.img: 4 GiB, 4294967296 bytes, 8388608 sectors 

Units: sectors of 1 * 512 = 512 bytes 

Sector size (logical/physical): 512 bytes / 512 bytes 

I/O size (minimum/optimal): 512 bytes / 512 bytes 

Disklabel type: dos 

Disk identifier: 0x12345678 

Device                                Boot  Start   End  Sectors  Size Id Type 

2024-11-19-raspios-bookworm-armhf-full.img1        8192  98045    89854   44M  c W95 FAT32 (LBA) 

2024-11-19-raspios-bookworm-armhf-full.img2       98304 8388607 8290304  3.9G 83 Linux 

确定目标分区的 Start 扇区 

#### ​启动分区（FAT32）​：通常是第一个分区（.img1），包含内核和设备树文件。 

示例中的 Start 值为 8192。 

#### ​根文件系统（ext4）​：通常是第二个分区（.img2）。 

示例中的 Start 值为 98304 

offset = 8192 × 512 = 4,194,304 

### 镜像文件挂载命令

参数自行修改

`sudo mount -o loop,offset=<上面算出的offset值> <你的镜像文件名.img> <镜像文件挂载处（一般是/mnt/img）>` 

`sudo mount -o loop,offset=4194304 2024-11-19-raspios-bookworm-armhf-full.img /mnt/img` 

`sudo mount -o loop,offset=4194304 2024-11-19-raspios-bookworm-armhf-lite.img /mnt/img` 

#### 如果需要卸载`sudo umount /mnt/img`

### 启动
确保主机系统已安装必要的图形驱动（如 SDL、GTK 或 VNC 支持库）。在 Ubuntu 中可安装依赖：

`sudo apt-get install libsdl2-2.0 libgtk-3-0` 

`sudo apt install libgtk-3-dev`​ 安装 GTK 依赖(-display gtk 可能因环境依赖缺失导致黑屏)

可以使用官方镜像的默认内核，从镜像的 /boot 分区提取内核和设备树文件（需挂载镜像）在上面的步骤已完成 

使用 QEMU 启动树莓派镜像时，需指定：

qemu-system-arm \ 

-M versatilepb \                     # 机器类型（树莓派B型） 
  
-cpu arm1176 \                       # CPU架构 
  
-m 256M \                            # 内存 
  
-kernel /mnt/img/boot/kernel7.img \  # 内核路径 
  
-dtb /mnt/img/boot/bcm2708-rpi-b.dtb \  # 设备树路径 
  
-drive file=your_image.img,format=raw \  # 镜像文件 
  
-append "root=/dev/sda2 console=ttyAMA0" \  # 内核参数 
  
-netdev user,id=net0：定义用户模式网络后端，标识为 net0。 

-device virtio-net-device,netdev=net0：将设备绑定到网络后端。 

-nographic：不使用图形化界面，仅仅使用串口

-display sdl # 使用 SDL 图形库 或 -display gtk # 使用 GTK 图形界面 或 -vnc :0 # 启用 VNC 服务（需 VNC 客户端连接） 或-nographic # 禁用图形，仅用串口输出

-enable-kvm \    # 启用 KVM 加速（需主机支持） 

`qemu-system-arm \-M raspi2b \-cpu arm1176 \-m 1G \-kernel /mnt/img/kernel7.img \-dtb /mnt/img/bcm2708-rpi-b.dtb \-drive file=2024-11-19-raspios-bookworm-armhf-full.img,format=raw \-append "root=/dev/sda2 console=ttyAMA0,115200" \-net user,hostfwd=tcp::5022-:22 \-display gtk \-serial stdio` 图形化镜像2024-11-19-raspios-bookworm-armhf-full.img 


`qemu-system-arm \-M versatilepb \-cpu arm1176 \-m 256M \-kernel /mnt/img/kernel7.img \-dtb /mnt/img/bcm2708-rpi-b.dtb \-drive file=2024-11-19-raspios-bookworm-armhf-lite.img,format=raw \-append "root=/dev/sda2 console=ttyAMA0,115200" \-net user,hostfwd=tcp::5022-:22 \-display curses \-serial stdio` 无图形2024-11-19-raspios-bookworm-armhf-lite.img 

#### 报错：qemu-system-arm: Invalid SD card size: 11.5 GiB,SD card size has to be a power of 2, e.g. 16 GiB.You can resize disk images with 'qemu-img resize <imagefile> <new-size>'(note that this will lose data if you make the image smaller than it currently is).

##### (1) 使用 qemu-img resize 调整镜像大小 

运行以下命令将镜像调整为 16 GiB（最小合规值）：

`qemu-img resize -f raw 2024-11-19-raspios-bookworm-armhf-full.img 16G` 

##### (2) 扩展镜像内的文件系统 

调整镜像大小后，需在虚拟机内扩展分区和文件系统, 挂载镜像并检查分区：

如果之前挂载了​启动分区（FAT32）需要先卸载之前挂载的​启动分区（FAT32），然后再挂载根文件系统（ext4）

`sudo umount /mnt/img`

###### 计算根分区偏移量（假设分区起始扇区为 98304）

`offset=$((1056768 * 512))` 

`sudo mount -o loop,offset=$offset 2024-11-19-raspios-bookworm-armhf-full.img /mnt/img` 

###### ​扩展分区：

`sudo apt update && sudo apt install multipath-tools -y`

`sudo losetup -fP 2024-11-19-raspios-bookworm-armhf-full.img` 

查看生成的分区设备 

`ls /dev/loop*`

sudo losetup -a

`sudo fdisk -l 2024-11-19-raspios-bookworm-armhf-full.img` 

qemu-img info 2024-11-19-raspios-bookworm-armhf-full.img

sudo losetup -fP 2024-11-19-raspios-bookworm-armhf-full.img 

sudo partprobe /dev/loop10

sudo growpart /dev/loop10 2

sudo e2fsck -f /dev/mapper/loop10p2

sudo resize2fs /dev/mapper/loop10p2

sudo losetup -d /dev/loop10
#### 

$ sudo dpkg --add-architecture armfh
$ sudo vim /etc/apt/sources.list.d/ubuntu-armfh.sources
Types: deb
URIs: http://ports.ubuntu.com/ubuntu-ports/
Suites: noble noble-updates noble-security
Components: main restricted universe multiverse
Architectures: armfh
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

$ sudo apt update
$ sudo apt install -y libudev-dev:arm64 libmtdev-dev:arm64

toolchain.cmake 

set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR arm)

# Path to your cross-compiler
set(CMAKE_C_COMPILER /usr/bin/arm-linux-gnueabihf-gcc)
set(CMAKE_CXX_COMPILER /usr/bin/arm-linux-gnueabihf-g++)

set(CMAKE_LINKER "/usr/bin/arm-linux-gnueabihf-ld")
set(CMAKE_AR "/usr/bin/arm-linux-gnueabihf-ar")
set(CMAKE_FIND_ROOT_PATH /usr/arm-linux-gnueabihf)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY) 

./configure \-prefix /home/dsq2/work/armfh \-qt-host-path /home/dsq2/Qt/6.8.2/gcc_64 \-platform arm-linux-gnueabihf-g++ \-device linux-arm-gnueabihf-g++ \-device-option CROSS_COMPILE=arm-linux-gnueabihf- \-no-opengl \-skip qtopcua -skip qtwebengine -skip qtwebview -skip qtserialport -skip qtlocation \-no-feature-brotli -no-feature-hunspell \-- -DCMAKE_TOOLCHAIN_FILE=/home/dsq2/work/toolchain.cmake 
