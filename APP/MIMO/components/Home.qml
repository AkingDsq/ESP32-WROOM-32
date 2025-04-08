import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material

Item {
    id: homePage
    anchors.fill: parent

    // 接收参数
    property string username: "AkingDsq"
    property string currentDateTime: "2025-03-25 08:54:49"

    // 退出信号
    signal logout()

    property bool isRecording: false
    property string recognizedText: ""
    signal commandRecognized(string command)

    // 音频可视化属性
    property var audioLevels: [0.2, 0.5, 0.7, 0.9, 0.6, 0.3, 0.5, 0.8]
    property bool isVisualizing: false

    // 背景设置 - 与登录界面匹配的深色渐变背景
    Rectangle {
        id: background
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#121212" }
            GradientStop { position: 1.0; color: "#1E1E1E" }
        }

        // 背景粒子效果 - 与登录界面相似
        Canvas {
            id: bgParticles
            anchors.fill: parent

            property var particles: []
            property int particleCount: 40
            property point touchPoint: Qt.point(-100, -100)
            property bool touching: false

            // 语音触发时增强粒子效果
            property bool enhancedMode: isRecording
            onEnhancedModeChanged: {
                if(enhancedMode) {
                    particleCount = 80;
                    createParticles();
                } else {
                    particleCount = 40;
                    createParticles();
                }
            }

            function createParticles() {
                particles = [];
                for (var i = 0; i < particleCount; i++) {
                    particles.push({
                        x: Math.random() * width,
                        y: Math.random() * height,
                        size: Math.random() * 3 + (enhancedMode ? 2 : 1),
                        opacity: Math.random() * 0.2 + (enhancedMode ? 0.1 : 0.05),
                        speed: Math.random() * 0.3 + (enhancedMode ? 0.2 : 0.1),
                        angle: Math.random() * Math.PI * 2
                    });
                }
            }

            Component.onCompleted: {
                createParticles();
                animTimer.start();
            }

            Timer {
                id: animTimer
                interval: 50
                repeat: true
                running: true
                onTriggered: {
                    for (var i = 0; i < bgParticles.particles.length; i++) {
                        var p = bgParticles.particles[i];
                        p.x += Math.cos(p.angle) * p.speed;
                        p.y += Math.sin(p.angle) * p.speed;

                        if (bgParticles.touching || (bgParticles.enhancedMode && i % 4 == 0)) {
                            var targetX = bgParticles.touching ? bgParticles.touchPoint.x : width/2;
                            var targetY = bgParticles.touching ? bgParticles.touchPoint.y : height/2;

                            var dx = targetX - p.x;
                            var dy = targetY - p.y;
                            var dist = Math.sqrt(dx * dx + dy * dy);

                            if (dist < (bgParticles.enhancedMode ? 160 : 80)) {
                                p.x += dx * (bgParticles.enhancedMode ? 0.02 : 0.01);
                                p.y += dy * (bgParticles.enhancedMode ? 0.02 : 0.01);
                            }
                        }

                        if (p.x < 0) p.x = bgParticles.width;
                        if (p.x > bgParticles.width) p.x = 0;
                        if (p.y < 0) p.y = bgParticles.height;
                        if (p.y > bgParticles.height) p.y = 0;
                    }
                    bgParticles.requestPaint();
                }
            }

            onPaint: {
                var ctx = getContext("2d");
                ctx.clearRect(0, 0, width, height);

                for (var i = 0; i < particles.length; i++) {
                    var p = particles[i];
                    // 录音时粒子颜色偏向科技蓝色
                    var colorR = enhancedMode ? 0.4 : 0.6;
                    var colorG = enhancedMode ? 0.6 : 0.4;
                    var colorB = enhancedMode ? 1.0 : 1.0;
                    ctx.fillStyle = Qt.rgba(colorR, colorG, colorB, p.opacity);
                    ctx.beginPath();
                    ctx.arc(p.x, p.y, p.size, 0, Math.PI * 2);
                    ctx.fill();

                    // 录音模式下增加连线效果
                    if (enhancedMode && i > 0 && i % 8 === 0) {
                        var prev = particles[i-1];
                        ctx.strokeStyle = Qt.rgba(0.4, 0.6, 1.0, p.opacity * 0.5);
                        ctx.beginPath();
                        ctx.moveTo(p.x, p.y);
                        ctx.lineTo(prev.x, prev.y);
                        ctx.stroke();
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onPositionChanged: {
                    parent.touchPoint = Qt.point(mouseX, mouseY);
                    parent.touching = true;
                }
                onExited: {
                    parent.touching = false;
                }
            }
        }
    }

    // 主内容区域
    SwipeView {
        id: swipeView
        width: parent.width
        height: parent.height - bottomArea.height
        anchors.top: parent.top
        currentIndex: 0
        clip: true

        // 页面1 - 房间页面
        Page {
            id: roomsPage
            background: Rectangle { color: "transparent" }

            // 顶部区域
            Rectangle {
                id: topArea
                width: parent.width
                height: parent.height * 0.1
                anchors {
                    top: parent.top
                    left: parent.left
                }
                radius: 10
                color: Qt.rgba(31/255, 24/255, 24/255, 0.8)

                // 标题文本
                Text {
                    width: parent.width - addRoomBtn.width
                    height: parent.height
                    anchors.left: parent.left
                    text: "智能家居"
                    color: "white"
                    font.pixelSize: height * 0.25
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                // 添加房间按钮
                Rectangle {
                    id: addRoomBtn
                    width: parent.width * 0.15
                    height: parent.height * 0.7
                    anchors {
                        right: parent.right
                        rightMargin: 10
                        verticalCenter: parent.verticalCenter
                    }
                    radius: height / 2

                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#7B2BFF" }
                        GradientStop { position: 1.0; color: "#BB86FC" }
                    }

                    Text {
                        text: "添加房间"
                        anchors.centerIn: parent
                        color: "white"
                        font.pixelSize: Math.min(parent.width, parent.height) * 0.2
                        font.bold: true
                    }

                    MouseArea {
                        anchors.fill: parent
                        onPressed: parent.scale = 0.95
                        onReleased: parent.scale = 1.0
                        onClicked: {
                            listModel.append({name: "新房间" + (listModel.count + 1)})
                        }
                    }

                    Behavior on scale {
                        NumberAnimation { duration: 100 }
                    }
                }
            }

            // 各房间配置 - 主要修改此处
            SwipeView{
                id: rooms
                width: parent.width
                height: roomsPage.height - topArea.height
                anchors.top: topArea.bottom
                orientation: Qt.Vertical
                clip: true

                // 修改：仅在wheelArea隐藏时才允许操作rooms
                interactive: wheelArea.x === -wheelArea.width

                onCurrentIndexChanged: {
                    if (interactive) {
                        roomsChoose.currentIndex = currentIndex
                    }
                }

                Component.onCompleted: {
                    Qt.callLater(() => {
                        currentIndex = 0; // 默认选第一个房间
                    });
                }

                // 房间一：客厅
                Item {
                    id: livingRoom

                    Rectangle {
                        id: livingRoomContainer
                        anchors.fill: parent
                        color: "transparent"

                        Column {
                            id: livingRoomHeader
                            width: parent.width
                            height: parent.height * 0.15
                            spacing: 10

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: qsTr("客厅")
                                color: "#BB86FC"
                                font.pixelSize: 28
                                font.bold: true
                            }

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: qsTr("房间温度: 24°C  湿度: 60%")
                                color: "white"
                                font.pixelSize: 16
                            }
                        }

                        // 设备网格布局
                        GridLayout {
                            anchors {
                                top: livingRoomHeader.bottom
                                left: parent.left
                                right: parent.right
                                bottom: parent.bottom
                                margins: 20
                            }
                            columns: 2
                            rowSpacing: 20
                            columnSpacing: 20

                            // 主灯
                            DeviceControl {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                deviceName: "主灯"
                                deviceIcon: "💡"
                                deviceStatus: true
                                deviceType: "light"

                                onToggleDevice: {
                                    deviceStatus = !deviceStatus
                                    if(deviceStatus){
                                        blueToothController.sendCommand("LED_ON")
                                    }
                                    else{
                                        blueToothController.sendCommand("LED_OFF")
                                    }

                                    console.log("主灯状态: " + deviceStatus)
                                }
                            }

                            // 空调
                            DeviceControl {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                deviceName: "空调"
                                deviceIcon: "❄️"
                                deviceStatus: true
                                deviceType: "ac"

                                onToggleDevice: {
                                    deviceStatus = !deviceStatus
                                    console.log("空调状态: " + deviceStatus)
                                }
                            }

                            // 电视
                            DeviceControl {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                deviceName: "电视"
                                deviceIcon: "📺"
                                deviceStatus: false
                                deviceType: "tv"

                                onToggleDevice: {
                                    deviceStatus = !deviceStatus
                                    console.log("电视状态: " + deviceStatus)
                                }
                            }

                            // 窗帘
                            DeviceControl {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                deviceName: "窗帘"
                                deviceIcon: "🪟"
                                deviceStatus: true
                                deviceType: "curtain"

                                onToggleDevice: {
                                    deviceStatus = !deviceStatus
                                    console.log("窗帘状态: " + deviceStatus)
                                }
                            }
                        }
                    }
                }

                // 房间二：卧室
                Item {
                    id: bedroom

                    Rectangle {
                        anchors.fill: parent
                        color: "transparent"

                        Column {
                            id: bedroomHeader
                            width: parent.width
                            height: parent.height * 0.15
                            spacing: 10

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: qsTr("卧室")
                                color: "#BB86FC"
                                font.pixelSize: 28
                                font.bold: true
                            }

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: qsTr("房间温度: 22°C  湿度: 55%")
                                color: "white"
                                font.pixelSize: 16
                            }
                        }

                        // 设备网格布局
                        GridLayout {
                            anchors {
                                top: bedroomHeader.bottom
                                left: parent.left
                                right: parent.right
                                bottom: parent.bottom
                                margins: 20
                            }
                            columns: 2
                            rowSpacing: 20
                            columnSpacing: 20

                            // 主灯
                            DeviceControl {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                deviceName: "主灯"
                                deviceIcon: "💡"
                                deviceStatus: false
                                deviceType: "light"

                                onToggleDevice: {
                                    deviceStatus = !deviceStatus
                                    console.log("卧室主灯状态: " + deviceStatus)
                                }
                            }

                            // 床头灯
                            DeviceControl {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                deviceName: "床头灯"
                                deviceIcon: "💡"
                                deviceStatus: true
                                deviceType: "light"
                                brightness: 30

                                onToggleDevice: {
                                    deviceStatus = !deviceStatus
                                    console.log("床头灯状态: " + deviceStatus)
                                }
                            }

                            // 空调
                            DeviceControl {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                deviceName: "空调"
                                deviceIcon: "❄️"
                                deviceStatus: true
                                deviceType: "ac"

                                onToggleDevice: {
                                    deviceStatus = !deviceStatus
                                    console.log("卧室空调状态: " + deviceStatus)
                                }
                            }

                            // 窗帘
                            DeviceControl {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                deviceName: "窗帘"
                                deviceIcon: "🪟"
                                deviceStatus: false
                                deviceType: "curtain"

                                onToggleDevice: {
                                    deviceStatus = !deviceStatus
                                    console.log("卧室窗帘状态: " + deviceStatus)
                                }
                            }
                        }
                    }
                }

                // 房间三：厨房
                Item {
                    id: kitchen

                    Rectangle {
                        anchors.fill: parent
                        color: "transparent"

                        Column {
                            id: kitchenHeader
                            width: parent.width
                            height: parent.height * 0.15
                            spacing: 10

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: qsTr("厨房")
                                color: "#BB86FC"
                                font.pixelSize: 28
                                font.bold: true
                            }

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: qsTr("房间温度: 26°C  湿度: 70%")
                                color: "white"
                                font.pixelSize: 16
                            }
                        }

                        // 设备网格布局
                        GridLayout {
                            anchors {
                                top: kitchenHeader.bottom
                                left: parent.left
                                right: parent.right
                                bottom: parent.bottom
                                margins: 20
                            }
                            columns: 2
                            rowSpacing: 20
                            columnSpacing: 20

                            // 主灯
                            DeviceControl {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                deviceName: "照明灯"
                                deviceIcon: "💡"
                                deviceStatus: true
                                deviceType: "light"

                                onToggleDevice: {
                                    deviceStatus = !deviceStatus
                                    console.log("厨房灯状态: " + deviceStatus)
                                }
                            }

                            // 排风扇
                            DeviceControl {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                deviceName: "排风扇"
                                deviceIcon: "🌀"
                                deviceStatus: false
                                deviceType: "fan"

                                onToggleDevice: {
                                    deviceStatus = !deviceStatus
                                    console.log("排风扇状态: " + deviceStatus)
                                }
                            }

                            // 冰箱
                            DeviceControl {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                deviceName: "冰箱"
                                deviceIcon: "❄️"
                                deviceStatus: true
                                deviceType: "fridge"

                                onToggleDevice: {
                                    deviceStatus = !deviceStatus
                                    console.log("冰箱状态: " + deviceStatus)
                                }
                            }

                            // 烤箱
                            DeviceControl {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                deviceName: "烤箱"
                                deviceIcon: "🔥"
                                deviceStatus: false
                                deviceType: "oven"

                                onToggleDevice: {
                                    deviceStatus = !deviceStatus
                                    console.log("烤箱状态: " + deviceStatus)
                                }
                            }
                        }
                    }
                }

                // 房间四：卫生间
                Item {
                    id: bathroom

                    Rectangle {
                        anchors.fill: parent
                        color: "transparent"

                        Column {
                            id: bathroomHeader
                            width: parent.width
                            height: parent.height * 0.15
                            spacing: 10

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: qsTr("卫生间")
                                color: "#BB86FC"
                                font.pixelSize: 28
                                font.bold: true
                            }

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: qsTr("房间温度: 25°C  湿度: 85%")
                                color: "white"
                                font.pixelSize: 16
                            }
                        }

                        // 设备网格布局
                        GridLayout {
                            anchors {
                                top: bathroomHeader.bottom
                                left: parent.left
                                right: parent.right
                                bottom: parent.bottom
                                margins: 20
                            }
                            columns: 2
                            rowSpacing: 20
                            columnSpacing: 20

                            // 照明灯
                            DeviceControl {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                deviceName: "照明灯"
                                deviceIcon: "💡"
                                deviceStatus: false
                                deviceType: "light"

                                onToggleDevice: {
                                    deviceStatus = !deviceStatus
                                    console.log("卫生间灯状态: " + deviceStatus)
                                }
                            }

                            // 排风扇
                            DeviceControl {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                deviceName: "排风扇"
                                deviceIcon: "🌀"
                                deviceStatus: true
                                deviceType: "fan"

                                onToggleDevice: {
                                    deviceStatus = !deviceStatus
                                    console.log("卫生间排风扇状态: " + deviceStatus)
                                }
                            }

                            // 热水器
                            DeviceControl {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                deviceName: "热水器"
                                deviceIcon: "🔥"
                                deviceStatus: true
                                deviceType: "water_heater"

                                onToggleDevice: {
                                    deviceStatus = !deviceStatus
                                    console.log("热水器状态: " + deviceStatus)
                                }
                            }
                        }
                    }
                }

                // 房间五：办公室
                Item {
                    id: office

                    Rectangle {
                        anchors.fill: parent
                        color: "transparent"

                        Column {
                            id: officeHeader
                            width: parent.width
                            height: parent.height * 0.15
                            spacing: 10

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: qsTr("办公室")
                                color: "#BB86FC"
                                font.pixelSize: 28
                                font.bold: true
                            }

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: qsTr("房间温度: 23°C  湿度: 50%")
                                color: "white"
                                font.pixelSize: 16
                            }
                        }

                        // 设备网格布局
                        GridLayout {
                            anchors {
                                top: officeHeader.bottom
                                left: parent.left
                                right: parent.right
                                bottom: parent.bottom
                                margins: 20
                            }
                            columns: 2
                            rowSpacing: 20
                            columnSpacing: 20

                            // 主灯
                            DeviceControl {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                deviceName: "主灯"
                                deviceIcon: "💡"
                                deviceStatus: true
                                deviceType: "light"

                                onToggleDevice: {
                                    deviceStatus = !deviceStatus
                                    console.log("办公室主灯状态: " + deviceStatus)
                                }
                            }

                            // 台灯
                            DeviceControl {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                deviceName: "台灯"
                                deviceIcon: "💡"
                                deviceStatus: true
                                deviceType: "light"
                                brightness: 70

                                onToggleDevice: {
                                    deviceStatus = !deviceStatus
                                    console.log("台灯状态: " + deviceStatus)
                                }
                            }

                            // 空调
                            DeviceControl {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                deviceName: "空调"
                                deviceIcon: "❄️"
                                deviceStatus: true
                                deviceType: "ac"

                                onToggleDevice: {
                                    deviceStatus = !deviceStatus
                                    console.log("办公室空调状态: " + deviceStatus)
                                }
                            }

                            // 打印机
                            DeviceControl {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                deviceName: "打印机"
                                deviceIcon: "🖨️"
                                deviceStatus: false
                                deviceType: "printer"

                                onToggleDevice: {
                                    deviceStatus = !deviceStatus
                                    console.log("打印机状态: " + deviceStatus)
                                }
                            }
                        }
                    }
                }
            }

            // 修改：侧边栏手柄指示器
            Rectangle {
                id: sidebarHandle
                width: 5
                height: parent.height * 0.2
                anchors {
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                }
                color: "#BB86FC"
                opacity: wheelArea.x === -wheelArea.width ? 0.7 : 0
                radius: 2.5

                // 呼吸动画
                SequentialAnimation on opacity {
                    running: wheelArea.x === -wheelArea.width
                    loops: Animation.Infinite
                    NumberAnimation { to: 0.3; duration: 1000 }
                    NumberAnimation { to: 0.7; duration: 1000 }
                }

                Behavior on opacity {
                    NumberAnimation { duration: 300 }
                }
            }

            // 房间选择的拖动显示动画 - 修改MouseArea
            MouseArea {
                id: wheelDragArea
                width: parent.width * 0.2 // 减小宽度，只在左侧边缘检测
                height: parent.height - topArea.height
                anchors {
                    top: topArea.bottom
                    left: parent.left
                }

                // 捕获拖拽事件，不再传递给rooms
                onPressed: {
                    if (wheelArea.x === -wheelArea.width) {
                        wheelArea.x = 0;
                    }
                    mouse.accepted = true;
                }

                onClicked: {
                    if (wheelArea.x === -wheelArea.width) {
                        wheelArea.x = 0;
                    } else if (wheelArea.x === 0) {
                        wheelArea.x = -wheelArea.width;
                    }
                }
            }

            // 侧边栏关闭按钮区域
            MouseArea {
                anchors.fill: parent
                visible: wheelArea.x === 0
                onClicked: {
                    // 点击其它区域收起侧边栏
                    wheelArea.x = -wheelArea.width
                }
                // 避免捕获子元素的事件
                propagateComposedEvents: true
            }

            // 侧边房间选择
            ListModel {
                id: listModel
                Component.onCompleted: {
                    append({ name: "客厅" })
                    append({ name: "卧室" })
                    append({ name: "厨房" })
                    append({ name: "卫生间" })
                    append({ name: "办公室" })
                }
            }

            // 轮盘选择区域
            Rectangle {
                id: wheelArea
                width: parent.width * 0.25
                height: parent.height - topArea.height
                anchors.top: topArea.bottom
                color: "#2A2A2A"

                // 滑动动画
                x: -width // 初始隐藏到左侧屏幕外
                Behavior on x {
                    NumberAnimation {
                        duration: 300
                        easing.type: Easing.OutQuad
                    }
                }

                // 关闭按钮
                Rectangle {
                    width: 30
                    height: 30
                    anchors {
                        top: parent.top
                        right: parent.right
                        margins: 10
                    }
                    color: "#333333"
                    radius: 15

                    Text {
                        anchors.centerIn: parent
                        text: "✕"
                        color: "white"
                        font.pixelSize: 16
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: wheelArea.x = -wheelArea.width
                    }
                }

                // 中间指示区域
                Rectangle {
                    z: 1
                    anchors.centerIn: parent
                    width: parent.width
                    height: 60
                    color: "#80BB86FC"
                    opacity: 0.2
                }

                ListView {
                    id: roomsChoose
                    anchors.fill: parent
                    anchors.topMargin: 50 // 为关闭按钮留出空间

                    Component.onCompleted: {
                        Qt.callLater(() => {
                            currentIndex = 0;
                            positionViewAtIndex(currentIndex, ListView.Center);
                        });
                    }

                    orientation: ListView.Vertical
                    spacing: 10
                    snapMode: ListView.SnapToItem
                    model: listModel
                    clip: true
                    boundsBehavior: Flickable.StopAtBounds
                    flickDeceleration: 1500

                    // 中间高光
                    preferredHighlightBegin: height/2 - wheelArea.height * 0.05
                    preferredHighlightEnd: height/2 + wheelArea.height * 0.05
                    highlightRangeMode: ListView.StrictlyEnforceRange
                    highlightMoveDuration: 200

                    // 高光框
                    highlight: Rectangle {
                        color: "#30BB86FC"
                        border { width: 2; color: "#BB86FC" }
                        radius: 8
                    }

                    onMovementEnded: {
                        console.log("选择房间:", listModel.get(currentIndex).name)
                        // 修改：防止循环触发
                        if (rooms.currentIndex !== currentIndex) {
                            rooms.currentIndex = currentIndex
                        }
                    }

                    delegate: Item {
                        id: roomDelegate
                        required property int index
                        required property var model

                        width: wheelArea.width
                        height: wheelArea.height * 0.1

                        // 选中时放大
                        scale: ListView.isCurrentItem ? 1 : 0.9
                        opacity: ListView.isCurrentItem ? 1.0 : 0.7

                        // 动画
                        Behavior on scale { NumberAnimation { duration: 100 } }
                        Behavior on opacity { NumberAnimation { duration: 100 } }

                        Rectangle {
                            anchors.fill: parent
                            anchors.margins: 4
                            color: "#333333"
                            radius: 8

                            Text {
                                text: model.name
                                anchors.centerIn: parent
                                font.pixelSize: ListView.isCurrentItem ? 16 : 14
                                font.bold: ListView.isCurrentItem
                                color: "white"
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                roomsChoose.currentIndex = index
                                roomsChoose.positionViewAtIndex(index, ListView.Center)
                                // 修改：防止循环触发
                                if (rooms.currentIndex !== index) {
                                    rooms.currentIndex = index
                                }
                            }
                        }
                    }
                }
            }
        }

        // 页面2 - 互动页面
        Page {
            id: interactionPage
            background: Rectangle { color: "transparent" }

            // 互动物品选择
            ListModel {
                id: interactionListModel
                Component.onCompleted: {
                    append({ name: "音乐", icon: "🎵" })
                    append({ name: "AI助手", icon: "🤖" })
                    append({ name: "视频", icon: "🎬" })
                }
            }

            // 顶部轮盘选择区域
            Rectangle {
                id: interactionWheelArea
                width: parent.width
                height: parent.height * 0.1
                anchors {
                    top: parent.top
                    left: parent.left
                }
                color: "#2A2A2A"
                radius: 10

                // 中间指示器
                Rectangle {
                    z: 1
                    anchors.centerIn: parent
                    width: 60
                    height: parent.height * 0.8
                    color: "#80BB86FC"
                    opacity: 0.3
                    radius: 4
                }

                ListView {
                    id: interactionChoose
                    anchors.fill: parent
                    anchors.margins: 5

                    Component.onCompleted: {
                        Qt.callLater(() => {
                            currentIndex = 1; // AI助手默认选中
                            interactionSwipeView = currentIndex
                            positionViewAtIndex(currentIndex, ListView.Center);
                        });
                    }

                    orientation: ListView.Horizontal
                    spacing: 15
                    snapMode: ListView.SnapToItem
                    model: interactionListModel
                    clip: true
                    boundsBehavior: Flickable.StopAtBounds
                    flickDeceleration: 1500

                    // 中间高光
                    preferredHighlightBegin: width/2 - 30
                    preferredHighlightEnd: width/2 + 30
                    highlightRangeMode: ListView.StrictlyEnforceRange
                    highlightMoveDuration: 200

                    // 高光框
                    highlight: Rectangle {
                        color: "#30BB86FC"
                        border { width: 2; color: "#BB86FC" }
                        radius: 8
                    }

                    onMovementEnded: {
                        interactionSwipeView.currentIndex = interactionChoose.currentIndex
                    }

                    delegate: Item {
                        id: interactionDelegate
                        required property int index
                        required property var model

                        width: 80
                        height: interactionChoose.height - 10
                        anchors.verticalCenter: parent.verticalCenter

                        // 选中时放大
                        scale: ListView.isCurrentItem ? 1.1 : 0.9
                        opacity: ListView.isCurrentItem ? 1.0 : 0.7

                        // 动画
                        Behavior on scale { NumberAnimation { duration: 100 } }
                        Behavior on opacity { NumberAnimation { duration: 100 } }

                        Rectangle {
                            anchors.fill: parent
                            color: "#333333"
                            radius: 8

                            Column {
                                anchors.centerIn: parent
                                spacing: 4

                                Text {
                                    text: model.icon
                                    font.pixelSize: 24
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text: model.name
                                    font.pixelSize: 12
                                    color: "white"
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                interactionChoose.currentIndex = index
                                interactionChoose.positionViewAtIndex(index, ListView.Center)
                                interactionSwipeView.currentIndex = index
                            }
                        }
                    }
                }
            }

            // 互动内容展示区
            SwipeView {
                id: interactionSwipeView
                width: parent.width
                height: parent.height - interactionWheelArea.height
                anchors.top: interactionWheelArea.bottom
                clip: true

                property bool innerSwipeActive: false
                interactive: true

                property bool atLeftEdge: currentIndex === 0
                property bool atRightEdge: currentIndex === count - 1

                onCurrentIndexChanged: {
                    if (atLeftEdge || atRightEdge) innerSwipeActive = false;
                    interactionChoose.currentIndex = interactionSwipeView.currentIndex
                }

                Component.onCompleted: {
                    Qt.callLater(() => {
                        currentIndex = interactionChoose.currentIndex; // AI助手默认选中
                    });
                }

                currentIndex: 1

                // 音乐页面
                Item {
                    id: musicPage
                    clip: true

                    Rectangle {
                        anchors.fill: parent
                        color: "transparent"

                        Column {
                            anchors.centerIn: parent
                            spacing: 20

                            Text {
                                text: "🎵"
                                font.pixelSize: 60
                                color: "#BB86FC"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Text {
                                text: "音乐播放器"
                                color: "white"
                                font.pixelSize: 24
                                font.bold: true
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            // Logo区域
                            Item {
                                id: logoArea
                                // anchors.top: parent.top
                                // anchors.topMargin: parent.height * 0.5
                                anchors.horizontalCenter: parent.horizontalCenter
                                width: parent.width * 0.8
                                height: width

                                // 旋转的Logo外框
                                Rectangle {
                                    id: logoBackground
                                    anchors.centerIn: parent
                                    width: parent.width
                                    height: width
                                    radius: width / 2
                                    color: "transparent"
                                    border.width: 2
                                    border.color: "#BB86FC"
                                    opacity: 0.7

                                    RotationAnimation {
                                        target: logoBackground
                                        property: "rotation"
                                        from: 0
                                        to: 360
                                        duration: 15000
                                        loops: Animation.Infinite
                                        running: true
                                    }

                                    SequentialAnimation {
                                        running: true
                                        loops: Animation.Infinite

                                        ParallelAnimation {
                                            NumberAnimation {
                                                target: logoBackground
                                                property: "scale"
                                                from: 1.0
                                                to: 1.15
                                                duration: 1500
                                                easing.type: Easing.InOutQuad
                                            }
                                            NumberAnimation {
                                                target: logoBackground
                                                property: "opacity"
                                                from: 0.7
                                                to: 0.4
                                                duration: 1500
                                                easing.type: Easing.InOutQuad
                                            }
                                        }

                                        ParallelAnimation {
                                            NumberAnimation {
                                                target: logoBackground
                                                property: "scale"
                                                from: 1.15
                                                to: 1.0
                                                duration: 1500
                                                easing.type: Easing.InOutQuad
                                            }
                                            NumberAnimation {
                                                target: logoBackground
                                                property: "opacity"
                                                from: 0.4
                                                to: 0.7
                                                duration: 1500
                                                easing.type: Easing.InOutQuad
                                            }
                                        }
                                    }
                                }

                                // Logo中心
                                Rectangle {
                                    anchors.centerIn: parent
                                    width: parent.width * 0.85
                                    height: width
                                    radius: width / 2
                                    gradient: Gradient {
                                        GradientStop { position: 0.0; color: "#7B2BFF" }
                                        GradientStop { position: 1.0; color: "#BB86FC" }
                                    }

                                    // Logo文字 - 使用当前用户的首字母
                                    Text {
                                        anchors.centerIn: parent
                                        text: "A"  // 使用AkingDsq的首字母
                                        color: "white"
                                        font.pixelSize: parent.width * 0.5
                                        font.bold: true
                                    }
                                }
                            }

                            // 音乐控制器
                            Row {
                                spacing: 20
                                anchors.horizontalCenter: parent.horizontalCenter

                                Repeater {
                                    model: ["⏮️", "⏯️", "⏭️"]

                                    Rectangle {
                                        width: 60
                                        height: 60
                                        radius: 30
                                        gradient: Gradient {
                                            GradientStop { position: 0.0; color: "#7B2BFF" }
                                            GradientStop { position: 1.0; color: "#BB86FC" }
                                        }

                                        Text {
                                            anchors.centerIn: parent
                                            text: modelData
                                            font.pixelSize: 24
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            onPressed: parent.scale = 0.9
                                            onReleased: parent.scale = 1.0
                                        }

                                        Behavior on scale {
                                            NumberAnimation { duration: 100 }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                // AI助手页面
                Item {
                    id: aiAssistantPage
                    clip: true

                    Rectangle {
                        anchors.fill: parent
                        color: "transparent"

                        Column {
                            anchors.centerIn: parent
                            spacing: 20
                            width: parent.width * 0.8

                            Text {
                                text: "🤖"
                                font.pixelSize: 60
                                color: "#BB86FC"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Text {
                                text: "AI智能助手"
                                color: "white"
                                font.pixelSize: 24
                                font.bold: true
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Rectangle {
                                width: parent.width
                                height: 100
                                radius: 10
                                color: "#2A2A2A"
                                border.width: 1
                                border.color: isRecording ? "#5AF7FF" : "#BB86FC"

                                // 高亮边框动画
                                SequentialAnimation on border.color {
                                    running: isRecording
                                    loops: Animation.Infinite
                                    ColorAnimation { to: "#5AF7FF"; duration: 1000 }
                                    ColorAnimation { to: "#BB86FC"; duration: 1000 }
                                }

                                Text {
                                    id: responseText
                                    anchors.fill: parent
                                    anchors.margins: 10
                                    text: "您好，" + username + (isRecording ? "，我在聆听..." : "。我可以为您提供哪些帮助？\n\n试试长按屏幕底部的YES按钮进行语音交互。")
                                    color: "white"
                                    wrapMode: Text.Wrap
                                    verticalAlignment: Text.AlignTop
                                }
                            }

                            // 语音识别结果显示区域 - 炫酷设计
                            Rectangle {
                                id: show
                                width: parent.width
                                height: 250
                                radius: 15

                                // 渐变背景
                                gradient: Gradient {
                                    GradientStop { position: 0.0; color: "#2A3153" }
                                    GradientStop { position: 1.0; color: "#1C2237" }
                                }

                                border.color: isRecording ? "#5AF7FF" : "#777777"
                                border.width: isRecording ? 2 : 1

                                // 音频可视化效果
                                Row {
                                    visible: isRecording
                                    anchors.bottom: parent.bottom
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.bottomMargin: 10
                                    spacing: 4
                                    height: 30

                                    Repeater {
                                        model: 8

                                        Rectangle {
                                            property real level: isRecording ?
                                                (Math.random() * 0.7 + 0.3) :
                                                audioLevels[index]

                                            width: 6
                                            height: 30 * level
                                            radius: 3
                                            color: "#5AF7FF"
                                            anchors.bottom: parent.bottom

                                            // 波动动画
                                            SequentialAnimation on height {
                                                running: isRecording
                                                loops: Animation.Infinite
                                                NumberAnimation {
                                                    to: 30 * (Math.random() * 0.7 + 0.3)
                                                    duration: 300 + index * 50
                                                    easing.type: Easing.InOutQuad
                                                }
                                                NumberAnimation {
                                                    to: 30 * (Math.random() * 0.7 + 0.3)
                                                    duration: 300 + index * 50
                                                    easing.type: Easing.InOutQuad
                                                }
                                            }
                                        }
                                    }
                                }

                                // 识别状态指示器
                                Rectangle {
                                    id: statusIndicator
                                    width: 10
                                    height: 10
                                    radius: 5
                                    color: isRecording ? "#5AF7FF" : "#777777"
                                    anchors {
                                        top: parent.top
                                        right: parent.right
                                        margins: 10
                                    }

                                    // 录音时闪烁
                                    SequentialAnimation on opacity {
                                        running: isRecording
                                        loops: Animation.Infinite
                                        NumberAnimation { to: 0.3; duration: 800 }
                                        NumberAnimation { to: 1.0; duration: 800 }
                                    }
                                }

                                Label {
                                    id: resultText
                                    anchors.fill: parent
                                    anchors.margins: 15
                                    anchors.bottomMargin: isRecording ? 50 : 15
                                    wrapMode: Text.WordWrap
                                    text: recognizedText || (isRecording ? "正在聆听..." : "语音识别结果将显示在这里...")
                                    font.bold: true
                                    color: isRecording ? "#5AF7FF" : "white"

                                    // 打字机效果
                                    visible: text.length > 0
                                    opacity: 0

                                    Behavior on text {
                                        SequentialAnimation {
                                            NumberAnimation { target: resultText; property: "opacity"; to: 0; duration: 100 }
                                            PropertyAction { target: resultText; property: "visible"; value: true }
                                            NumberAnimation { target: resultText; property: "opacity"; to: 1.0; duration: 300 }
                                        }
                                    }
                                }
                            }

                            // 麦克风按钮 - 增强版
                            Rectangle {
                                width: 80
                                height: 80
                                radius: 40
                                anchors.horizontalCenter: parent.horizontalCenter

                                // 动态渐变
                                gradient: Gradient {
                                    GradientStop {
                                        position: 0.0
                                        color: isRecording ? "#00A9FF" : "#7B2BFF"
                                    }
                                    GradientStop {
                                        position: 1.0
                                        color: isRecording ? "#5AF7FF" : "#BB86FC"
                                    }
                                }

                                // 麦克风图标
                                Item {
                                    anchors.centerIn: parent
                                    width: 40
                                    height: 40

                                    // 麦克风主体
                                    Rectangle {
                                        width: 24
                                        height: 34
                                        radius: 12
                                        color: "white"
                                        anchors.centerIn: parent
                                    }

                                    // 麦克风底座
                                    Rectangle {
                                        width: 36
                                        height: 6
                                        radius: 3
                                        color: "white"
                                        anchors.bottom: parent.bottom
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }

                                    // 录音时的动态效果
                                    Rectangle {
                                        visible: isRecording
                                        width: 50
                                        height: 50
                                        radius: 25
                                        color: "transparent"
                                        border.width: 2
                                        border.color: "#ffffff"
                                        anchors.centerIn: parent
                                        opacity: 0.7

                                        NumberAnimation on scale {
                                            running: isRecording
                                            from: 0.6
                                            to: 1.3
                                            duration: 1000
                                            loops: Animation.Infinite
                                        }

                                        NumberAnimation on opacity {
                                            running: isRecording
                                            from: 0.7
                                            to: 0
                                            duration: 1000
                                            loops: Animation.Infinite
                                        }
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onPressed: parent.scale = 0.9
                                    onReleased: parent.scale = 1.0
                                    onClicked: {
                                        if (isRecording) {
                                            speechRecognizer.stopRecognize()
                                            isRecording = false
                                        } else {
                                            console.log("启动语音助手")
                                            if (speechRecognizer.startRecognize()) {
                                                isRecording = true
                                            } else {
                                                console.log("无法启动语音识别")
                                            }
                                        }
                                    }
                                }

                                Behavior on scale {
                                    NumberAnimation { duration: 100 }
                                }
                            }

                            Connections {
                                target: speechRecognizer

                                function onRecognitionResult(text, isFinal) {
                                    if (isFinal) {
                                        // 最终结果动画展示
                                        resultText.opacity = 0
                                        resultText.text = text
                                        recognizedText = text

                                        // 显示结果动画
                                        resultAnimation.start()

                                        // 处理命令
                                        if (text.includes("打开灯")) {
                                            commandRecognized("OPEN_LIGHT")
                                            showCommandFeedback("正在打开灯")
                                        } else if (text.includes("关闭灯")) {
                                            commandRecognized("CLOSE_LIGHT")
                                            showCommandFeedback("正在关闭灯")
                                        } else if (text.includes("读取温度")) {
                                            commandRecognized("READ_TEMPERATURE")
                                            showCommandFeedback("正在读取温度")
                                        } else if (text.includes("读取湿度")) {
                                            commandRecognized("READ_HUMIDITY")
                                            showCommandFeedback("正在读取湿度")
                                        }
                                    } else {
                                        // 更新临时结果
                                        recognizedText = text
                                        resultText.text = "识别中: " + text
                                    }
                                }

                                function onConnectionStatusChanged(connected, status) {
                                    if (connected) {
                                        resultText.text = "已连接，请说话..."
                                    } else {
                                        resultText.text = status
                                        if (status.includes("已断开")) {
                                            isRecording = false
                                        }
                                    }
                                }

                                function onErrorOccurred(errorMsg) {
                                    isRecording = false
                                    resultText.text = "错误: " + errorMsg

                                    // 错误闪烁动画
                                    statusIndicator.color = "#FF5252"
                                    errorAnimation.start()
                                }
                            }

                            // 命令反馈动画
                            SequentialAnimation {
                                id: resultAnimation

                                NumberAnimation {
                                    target: resultText
                                    property: "opacity"
                                    to: 0
                                    duration: 200
                                }

                                PropertyAction {
                                    target: resultText
                                    property: "color"
                                    value: "#5AF7FF"
                                }

                                NumberAnimation {
                                    target: resultText
                                    property: "opacity"
                                    to: 1.0
                                    duration: 400
                                    easing.type: Easing.OutCubic
                                }

                                PauseAnimation { duration: 300 }

                                PropertyAction {
                                    target: resultText
                                    property: "color"
                                    value: "white"
                                }
                            }

                            // 错误动画
                            SequentialAnimation {
                                id: errorAnimation

                                ColorAnimation {
                                    target: show
                                    property: "border.color"
                                    to: "#FF5252"
                                    duration: 200
                                }

                                PauseAnimation { duration: 1000 }

                                ColorAnimation {
                                    target: show
                                    property: "border.color"
                                    to: "#777777"
                                    duration: 500
                                }

                                PropertyAction {
                                    target: statusIndicator
                                    property: "color"
                                    value: "#777777"
                                }
                            }

                            // 命令反馈提示
                            function showCommandFeedback(message) {
                                commandFeedback.text = message
                                commandFeedbackAnim.start()
                            }

                            // 命令反馈显示
                            Rectangle {
                                id: commandFeedback
                                property string text: ""

                                anchors.horizontalCenter: parent.horizontalCenter
                                width: parent.width * 0.7
                                height: 40
                                radius: 20
                                opacity: 0
                                color: "#5AF7FF"

                                Text {
                                    anchors.centerIn: parent
                                    text: parent.text
                                    color: "#000000"
                                    font.bold: true
                                }

                                SequentialAnimation {
                                    id: commandFeedbackAnim

                                    NumberAnimation {
                                        target: commandFeedback
                                        property: "opacity"
                                        to: 1.0
                                        duration: 300
                                    }

                                    PauseAnimation { duration: 1500 }

                                    NumberAnimation {
                                        target: commandFeedback
                                        property: "opacity"
                                        to: 0.0
                                        duration: 500
                                    }
                                }
                            }
                        }
                    }
                }

                // 视频页面
                Item {
                    id: videoPage
                    clip: true

                    Rectangle {
                        anchors.fill: parent
                        color: "transparent"

                        Column {
                            anchors.centerIn: parent
                            spacing: 20

                            Text {
                                text: "🎬"
                                font.pixelSize: 60
                                color: "#BB86FC"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Text {
                                text: "视频中心"
                                color: "white"
                                font.pixelSize: 24
                                font.bold: true
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            // 视频预览区
                            Rectangle {
                                width: 280
                                height: 160
                                radius: 10
                                color: "#2A2A2A"
                                border.width: 1
                                border.color: "#BB86FC"

                                Text {
                                    anchors.centerIn: parent
                                    text: "视频预览区"
                                    color: "#9E9E9E"
                                }
                            }

                            // 视频控制器
                            Row {
                                spacing: 20
                                anchors.horizontalCenter: parent.horizontalCenter

                                Repeater {
                                    model: ["⏮️", "▶️", "⏭️"]

                                    Rectangle {
                                        width: 50
                                        height: 50
                                        radius: 25
                                        gradient: Gradient {
                                            GradientStop { position: 0.0; color: "#7B2BFF" }
                                            GradientStop { position: 1.0; color: "#BB86FC" }
                                        }

                                        Text {
                                            anchors.centerIn: parent
                                            text: modelData
                                            font.pixelSize: 20
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            onPressed: parent.scale = 0.9
                                            onReleased: parent.scale = 1.0
                                        }

                                        Behavior on scale {
                                            NumberAnimation { duration: 100 }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        // 页面3 - 安保页面
        Page {
            id: securityPage
            background: Rectangle { color: "#121212" }

            property int dataDisplayMode: dbManager.dataDisplayMode // 0=今日数据，1=周数据

            // 更新当前时间和用户
            property string currentDateTime: "2025-04-08 10:02:57"
            property string currentUser: "AkingDsq"

            Timer {
                interval: 1000
                running: true
                repeat: true
                onTriggered: {
                    var now = new Date();
                    securityPage.currentDateTime = Qt.formatDateTime(now, "yyyy-MM-dd hh:mm:ss");
                }
            }

            Rectangle {
                width: parent.width * 0.95
                height: parent.height * 0.95
                anchors.centerIn: parent
                color: "#1E1E1E"
                radius: 20

                // 添加内部边框
                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 1
                    radius: 19
                    color: "transparent"
                    border.width: 1
                    border.color: "#BB86FC30"
                }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Math.min(parent.width, parent.height) * 0.03 // 自适应边距
                    spacing: Math.min(parent.width, parent.height) * 0.02 // 自适应间距

                    // 标题栏和用户信息
                    RowLayout {
                        Layout.fillWidth: true
                        height: Math.min(parent.width, parent.height) * 0.06
                        spacing: 10

                        Rectangle {
                            width: 4
                            height: titleText.height
                            color: "#BB86FC"
                            radius: 2
                        }

                        Text {
                            id: titleText
                            text: "安保中心"
                            color: "white"
                            font.pixelSize: Math.min(parent.width, parent.height) * 0.5
                            font.bold: true
                        }

                        Item { Layout.fillWidth: true }

                        // 用户信息
                        Row {
                            spacing: 8

                            // 用户图标
                            Rectangle {
                                width: 32
                                height: 32
                                radius: 16
                                color: "#3A3A3A"

                                Text {
                                    anchors.centerIn: parent
                                    text: "👤"
                                    font.pixelSize: 18
                                }
                            }

                            Column {
                                anchors.verticalCenter: parent.verticalCenter

                                Text {
                                    text: currentUser
                                    color: "white"
                                    font.pixelSize: 14
                                    font.bold: true
                                }

                                Text {
                                    text: currentDateTime
                                    color: "#AAAAAA"
                                    font.pixelSize: 12
                                }
                            }
                        }
                    }

                    // 数据切换按钮 - 今日/本周
                    Rectangle {
                        Layout.alignment: Qt.AlignRight
                        height: parent.height * 0.04
                        width: parent.width * 0.4
                        radius: 19
                        color: "#2A2A2A"

                        Row {
                            anchors.fill: parent

                            // 今日按钮
                            Rectangle {
                                width: parent.width / 2
                                height: parent.height
                                radius: 19
                                color: securityPage.dataDisplayMode === 0 ? "#BB86FC" : "transparent"

                                Text {
                                    anchors.centerIn: parent
                                    text: "今日"
                                    color: securityPage.dataDisplayMode === 0 ? "white" : "#BBBBBB"
                                    font.pixelSize: 14
                                    font.bold: securityPage.dataDisplayMode === 0
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        if (securityPage.dataDisplayMode !== 0) {
                                            dbManager.setDataDisplayMode(0)
                                            dbManager.loadDataForPeriod(0);
                                        }
                                    }
                                }
                            }

                            // 本周按钮
                            Rectangle {
                                width: parent.width / 2
                                height: parent.height
                                radius: 19
                                color: securityPage.dataDisplayMode === 1 ? "#BB86FC" : "transparent"

                                Text {
                                    anchors.centerIn: parent
                                    text: "本周"
                                    color: securityPage.dataDisplayMode === 1 ? "white" : "#BBBBBB"
                                    font.pixelSize: 14
                                    font.bold: securityPage.dataDisplayMode === 1
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        if (securityPage.dataDisplayMode !== 1) {
                                            dbManager.setDataDisplayMode(1);
                                            dbManager.loadDataForPeriod(1);
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // 传感器数据卡片 - 响应式布局
                    GridLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: parent.height * 0.15
                        columns: {
                            // 根据屏幕宽度自动调整列数
                            if (parent.width < 400) return 2;
                            if (parent.width < 600) return 3;
                            return 4;
                        }
                        columnSpacing: 12
                        rowSpacing: 12

                        // 温度卡片
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            radius: 15
                            color: "#2A2A2A"

                            // 温度信息
                            Column {
                                anchors.centerIn: parent
                                spacing: 0.5

                                Text {
                                    text: "🌡️"
                                    font.pixelSize: 24
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text: "温度"
                                    color: "#AAAAAA"
                                    font.pixelSize: 14
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Row {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    spacing: 4

                                    Text {
                                        text: blueToothController.temperature + "°C"
                                        color: "#BB86FC"
                                        font.pixelSize: 20
                                        font.bold: true
                                    }
                                    // 变化趋势
                                    Row {
                                        spacing: 4

                                        Text {
                                            text: "↑"
                                            color: "#4CAF50"
                                            font.pixelSize: 12
                                            font.bold: true
                                        }

                                        Text {
                                            text: "+1.5°C"
                                            color: "#4CAF50"
                                            font.pixelSize: 12
                                            font.bold: true
                                        }
                                    }
                                }
                            }
                        }

                        // 湿度卡片
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            radius: 15
                            color: "#2A2A2A"

                            // 湿度信息
                            Column {
                                anchors.centerIn: parent
                                spacing: 0.5

                                Text {
                                    text: "💧"
                                    font.pixelSize: 24
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text: "湿度"
                                    color: "#AAAAAA"
                                    font.pixelSize: 14
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Row{
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    spacing: 4

                                    Text {
                                        text: blueToothController.humidity + "%"
                                        color: "#03DAC5"
                                        font.pixelSize: 20
                                        font.bold: true
                                    }
                                    // 变化趋势
                                    Row {
                                        spacing: 4

                                        Text {
                                            text: "↓"
                                            color: "#F44336"
                                            font.pixelSize: 12
                                            font.bold: true
                                        }

                                        Text {
                                            text: "-2.3%"
                                            color: "#F44336"
                                            font.pixelSize: 12
                                            font.bold: true
                                        }
                                    }
                                }
                            }
                        }

                        // 门窗状态卡片
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            radius: 15
                            color: "#2A2A2A"

                            // 门窗状态信息
                            Column {
                                anchors.centerIn: parent
                                spacing: 2

                                Text {
                                    text: "🔒"
                                    font.pixelSize: 24
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text: "门窗状态"
                                    color: "#AAAAAA"
                                    font.pixelSize: 14
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text: "已锁定"
                                    color: "#FFC107"
                                    font.pixelSize: 20
                                    font.bold: true
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                // 上次变更时间
                                Text {
                                    text: "3小时前"
                                    color: "#AAAAAA"
                                    font.pixelSize: 12
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }
                        }

                        // 移动检测卡片
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            radius: 15
                            color: "#2A2A2A"

                            // 移动检测信息
                            Column {
                                anchors.centerIn: parent
                                spacing: 2

                                Text {
                                    text: "👁️"
                                    font.pixelSize: 24
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text: "移动检测"
                                    color: "#AAAAAA"
                                    font.pixelSize: 14
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text: "正常"
                                    color: "#2196F3"
                                    font.pixelSize: 20
                                    font.bold: true
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                // 上次事件时间
                                Text {
                                    text: "5分钟前"
                                    color: "#AAAAAA"
                                    font.pixelSize: 12
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }
                        }
                    }

                    // 数据可视化区域 - 使用自定义Canvas绘制，避免QCharts崩溃
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: parent.height * 0.4
                        color: "#2A2A2A"
                        radius: 10

                        // 图表标题
                        Rectangle {
                            id: chartTitleBar
                            width: parent.width
                            height: 40
                            color: "#383838"
                            radius: 10

                            Text {
                                text: securityPage.dataDisplayMode === 0 ? "今日温湿度趋势" : "本周温湿度趋势"
                                color: "white"
                                font.pixelSize: 16
                                font.bold: true
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: 15
                            }

                            // 图例
                            Row {
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.rightMargin: 15
                                spacing: 15

                                // 温度图例
                                Row {
                                    spacing: 5

                                    Rectangle {
                                        width: 12
                                        height: 12
                                        radius: 6
                                        color: "#BB86FC"
                                        anchors.verticalCenter: parent.verticalCenter
                                    }

                                    Text {
                                        text: "温度"
                                        color: "white"
                                        font.pixelSize: 12
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                }

                                // 湿度图例
                                Row {
                                    spacing: 5

                                    Rectangle {
                                        width: 12
                                        height: 12
                                        radius: 6
                                        color: "#03DAC5"
                                        anchors.verticalCenter: parent.verticalCenter
                                    }

                                    Text {
                                        text: "湿度"
                                        color: "white"
                                        font.pixelSize: 12
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                }
                            }
                        }

                        // 图表区域 - 使用更新后的自定义图表组件
                        Item {
                            anchors.top: chartTitleBar.bottom
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            anchors.margins: 5

                            // 使用我们定义的Canvas图表组件，避免QCharts崩溃问题
                            TemperatureHumidityChart {
                                anchors.fill: parent
                                tempData: dbManager.tempData
                                humidityData: dbManager.humidityData
                                timeLabels: dbManager.timeLabels
                            }
                        }
                    }

                    // 底部操作按钮 - 自适应尺寸
                    Row {
                        Layout.fillWidth: true
                        height: Math.min(parent.width, parent.height) * 0.1
                        spacing: 15

                        // 扫描设备按钮
                        Rectangle {
                            width: parent.width * 0.5 - 7.5
                            height: parent.height
                            radius: height / 2

                            // 渐变背景
                            gradient: Gradient {
                                GradientStop { position: 0.0; color: "#7B2BFF" }
                                GradientStop { position: 1.0; color: "#BB86FC" }
                            }

                            Row {
                                anchors.centerIn: parent
                                spacing: 10

                                Text {
                                    text: "🔄"
                                    font.pixelSize: parent.parent.height * 0.5
                                    anchors.verticalCenter: parent.verticalCenter
                                    visible: !blueToothController.isScanning
                                }

                                // 扫描动画
                                Rectangle {
                                    width: parent.parent.height * 0.4
                                    height: width
                                    radius: width / 2
                                    color: "transparent"
                                    border.width: 2
                                    border.color: "white"
                                    visible: blueToothController.isScanning
                                    anchors.verticalCenter: parent.verticalCenter

                                    Rectangle {
                                        width: parent.width * 0.3
                                        height: width
                                        radius: width / 2
                                        color: "white"
                                        anchors.centerIn: parent

                                        RotationAnimation {
                                            target: parent
                                            from: 0
                                            to: 360
                                            duration: 1500
                                            loops: Animation.Infinite
                                            running: blueToothController.isScanning
                                        }
                                    }
                                }

                                Text {
                                    text: blueToothController.isScanning ? "停止扫描" : "扫描设备"
                                    color: "white"
                                    font.pixelSize: Math.min(parent.parent.height * 0.4, 16)
                                    font.bold: true
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                onPressed: parent.opacity = 0.8
                                onReleased: parent.opacity = 1.0
                                onClicked: {
                                    if (blueToothController.isScanning) {
                                        blueToothController.stopScan();
                                    } else {
                                        blueToothController.startScan();
                                    }
                                }
                            }
                        }

                        // 导出数据按钮
                        Rectangle {
                            width: parent.width * 0.5 - 7.5
                            height: parent.height
                            radius: height / 2
                            color: "#3A3A3A"

                            Row {
                                anchors.centerIn: parent
                                spacing: 10

                                Text {
                                    text: "📊"
                                    font.pixelSize: parent.parent.height * 0.5
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Text {
                                    text: "导出数据"
                                    color: "white"
                                    font.pixelSize: Math.min(parent.parent.height * 0.4, 16)
                                    font.bold: true
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                onPressed: parent.opacity = 0.8
                                onReleased: parent.opacity = 1.0
                                onClicked: {
                                    console.log("导出数据");
                                    // 导出数据功能实现
                                }
                            }
                        }
                    }
                }
            }
        }

        // 页面4 - 个人中心页面
        Page {
            id: profilePage
            background: Rectangle { color: "transparent" }

            Rectangle {
                width: parent.width * 0.9
                height: parent.height * 0.9
                anchors.centerIn: parent
                color: "#1E1E1E"
                radius: 15

                Column {
                    anchors.centerIn: parent
                    spacing: 25
                    width: parent.width * 0.8

                    // 用户头像
                    Rectangle {
                        width: 120
                        height: 120
                        radius: 60
                        anchors.horizontalCenter: parent.horizontalCenter
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: "#7B2BFF" }
                            GradientStop { position: 1.0; color: "#BB86FC" }
                        }

                        Text {
                            anchors.centerIn: parent
                            text: username.charAt(0).toUpperCase()
                            color: "white"
                            font.pixelSize: 60
                            font.bold: true
                        }
                    }

                    // 用户名
                    Text {
                        text: username
                        color: "white"
                        font.pixelSize: 24
                        font.bold: true
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    // 登录时间
                    Text {
                        text: "登录时间: " + currentDateTime
                        color: "#AAAAAA"
                        font.pixelSize: 14
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: "#333333"
                    }

                    // 设置项
                    Column {
                        width: parent.width
                        spacing: 15

                        Repeater {
                            model: [
                                { name: "个人信息", icon: "👤" },
                                { name: "通知设置", icon: "🔔" },
                                { name: "隐私设置", icon: "🔒" },
                                { name: "帮助中心", icon: "❓" }
                            ]

                            Rectangle {
                                width: parent.width
                                height: 60
                                radius: 8
                                color: "#2A2A2A"

                                Row {
                                    anchors.fill: parent
                                    anchors.margins: 10
                                    spacing: 15

                                    Text {
                                        text: modelData.icon
                                        font.pixelSize: 24
                                        anchors.verticalCenter: parent.verticalCenter
                                    }

                                    Text {
                                        text: modelData.name
                                        color: "white"
                                        font.pixelSize: 16
                                        anchors.verticalCenter: parent.verticalCenter
                                    }

                                    Item { width: parent.width - 100; height: 1 }

                                    Text {
                                        text: ">"
                                        color: "#AAAAAA"
                                        font.pixelSize: 18
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onPressed: parent.scale = 0.98
                                    onReleased: parent.scale = 1.0
                                }

                                Behavior on scale {
                                    NumberAnimation { duration: 100 }
                                }
                            }
                        }
                    }

                    // 退出登录按钮
                    Rectangle {
                        width: parent.width * 0.7
                        height: 56
                        radius: 28
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: "#E53935"

                        Text {
                            anchors.centerIn: parent
                            text: "退出登录"
                            color: "white"
                            font.pixelSize: 16
                            font.bold: true
                        }

                        MouseArea {
                            anchors.fill: parent
                            onPressed: parent.scale = 0.95
                            onReleased: parent.scale = 1.0
                            onClicked: homePage.logout()
                        }

                        Behavior on scale {
                            NumberAnimation { duration: 100 }
                        }
                    }
                }
            }
        }
    }

    // AI助手按钮 - 升级版
    Rectangle {
        id: aiCall
        width: (parent.width + parent.height) * 0.05
        height: width
        radius: width/2
        anchors {
            bottom: bottomArea.top
            horizontalCenter: parent.horizontalCenter
            bottomMargin: (parent.height - bottomArea.height) * 0.05
        }
        z: 100

        // 动态渐变
        gradient: Gradient {
            GradientStop {
                position: 0.0
                color: isRecording ? "#00A9FF" : "#7B2BFF"
            }
            GradientStop {
                position: 1.0
                color: isRecording ? "#5AF7FF" : "#BB86FC"
            }
        }

        // 脉冲效果
        Rectangle {
            visible: isRecording
            anchors.centerIn: parent
            width: parent.width * 1.6
            height: width
            radius: width/2
            color: "transparent"
            border.width: 2
            border.color: "#5AF7FF"
            opacity: 0.7

            // 脉冲动画
            SequentialAnimation on scale {
                running: isRecording
                loops: Animation.Infinite
                NumberAnimation { to: 0.7; duration: 800; easing.type: Easing.OutQuad }
                NumberAnimation { to: 1.0; duration: 800; easing.type: Easing.InOutQuad }
            }

            SequentialAnimation on opacity {
                running: isRecording
                loops: Animation.Infinite
                NumberAnimation { to: 0.0; duration: 800 }
                NumberAnimation { to: 0.7; duration: 800 }
            }
        }

        Text {
            id: label
            text: isRecording ? "听" : "YES"
            anchors.centerIn: parent
            color: "white"
            font { bold: true; pixelSize: 16 }
        }

        property bool isListening: false
        property bool isLongPressed: false
        property int longPressThreshold: 800  // 减少长按等待时间
        property int noAudioTimeout: 2000
        property string recognizedText: ""

        // 动画
        SequentialAnimation on scale {
            id: clickAiCall
            loops: 1
            NumberAnimation { to: 1; duration: 100 }
            NumberAnimation { to: 1.1; duration: 100 }
        }

        NumberAnimation on scale {
            id: back
            to: 1.0;
            duration: 100
        }

        ParallelAnimation on scale {
            id: pressAiCall
            loops: 1
            NumberAnimation { to: 1.5; duration: 100 }
        }

        // 长按时的脉冲效果
        SequentialAnimation on opacity {
            id: pulseAnimation
            running: false
            loops: 2
            NumberAnimation { to: 0.7; duration: 150 }
            NumberAnimation { to: 1.0; duration: 150 }
        }

        MouseArea {
            anchors.fill: parent
            onPressed: {
                // 检测麦克风权限
                blueToothController.checkMicrophonePermission()
                pressAiCall.start();
                longPressTimer.start();
                pulseAnimation.start();
            }

            onReleased: {
                if (!aiCall.isLongPressed) {
                    longPressTimer.stop()
                    back.start();
                } else {
                    // 长按后释放停止录音
                    if (isRecording) {
                        // 接入deepseek获取回复
                        aiController.requestAI(resultText.text);
                        // 停止录音和网络连接
                        speechRecognizer.stopRecognize()
                        // 状态恢复
                        isRecording = false
                        aiCall.isLongPressed = false
                        back.start();
                    }
                }
            }

            onClicked: {
                if (!aiCall.isLongPressed) {
                    // 单击切换到AI助手页面
                    swipeView.currentIndex = 1
                    interactionChoose.currentIndex = 1
                    interactionSwipeView.currentIndex = 1
                }
            }

            Timer {
                id: longPressTimer
                interval: aiCall.longPressThreshold
                onTriggered: {
                    //aiController.call();

                    longPressTimer.stop()
                    aiCall.isLongPressed = true

                    // 跳转到AI助手页面
                    swipeView.currentIndex = 1
                    interactionChoose.currentIndex = 1 // AI助手
                    interactionSwipeView.currentIndex = 1

                    console.log("启动语音助手")

                    // 先停止任何已存在的录音
                    if (isRecording) {
                        speechRecognizer.stopRecognize()
                    }

                    // 启动新的录音
                    if (speechRecognizer.startRecognize()) {
                        isRecording = true
                        aiCall.isListening = true
                    }
                }
            }
        }
    }

    // 底部导航栏
    Rectangle {
        id: bottomArea
        width: parent.width
        height: parent.height * 0.07
        anchors {
            bottom: parent.bottom
            left: parent.left
        }
        color: "#1A1A1A"
        z: 99

        Row {
            anchors.fill: parent

            // 房间按钮
            TabButton {
                width: parent.width / 4
                height: parent.height

                contentItem: Column {
                    anchors.centerIn: parent
                    spacing: 0.5

                    Text {
                        text: "🏠"
                        font.pixelSize: 24
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: swipeView.currentIndex === 0 ? "#BB86FC" : "white"
                    }

                    Text {
                        text: "房间"
                        font.pixelSize: 12
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: swipeView.currentIndex === 0 ? "#BB86FC" : "#AAAAAA"
                    }
                }

                background: Rectangle {
                    color: "transparent"
                    Rectangle {
                        visible: swipeView.currentIndex === 0
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.width * 0.6
                        height: 2
                        color: "#BB86FC"
                    }
                }

                onClicked: swipeView.currentIndex = 0
            }

            // 互动按钮
            TabButton {
                width: parent.width / 4
                height: parent.height

                contentItem: Column {
                    anchors.centerIn: parent
                    spacing: 0.5

                    Text {
                        text: "🎮"
                        font.pixelSize: 24
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: swipeView.currentIndex === 1 ? "#BB86FC" : "white"
                    }

                    Text {
                        text: "互动"
                        font.pixelSize: 12
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: swipeView.currentIndex === 1 ? "#BB86FC" : "#AAAAAA"
                    }
                }

                background: Rectangle {
                    color: "transparent"
                    Rectangle {
                        visible: swipeView.currentIndex === 1
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.width * 0.6
                        height: 2
                        color: "#BB86FC"
                    }
                }

                onClicked: swipeView.currentIndex = 1
            }

            // 安保按钮
            TabButton {
                width: parent.width / 4
                height: parent.height

                contentItem: Column {
                    anchors.centerIn: parent
                    spacing: 0.5

                    Text {
                        text: "🔒"
                        font.pixelSize: 24
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: swipeView.currentIndex === 2 ? "#BB86FC" : "white"
                    }

                    Text {
                        text: "安保"
                        font.pixelSize: 12
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: swipeView.currentIndex === 2 ? "#BB86FC" : "#AAAAAA"
                    }
                }

                background: Rectangle {
                    color: "transparent"
                    Rectangle {
                        visible: swipeView.currentIndex === 2
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.width * 0.6
                        height: 2
                        color: "#BB86FC"
                    }
                }

                onClicked: swipeView.currentIndex = 2
            }

            // 个人按钮
            TabButton {
                width: parent.width / 4
                height: parent.height

                contentItem: Column {
                    anchors.centerIn: parent
                    spacing: 0.5

                    Text {
                        text: "👤"
                        font.pixelSize: 24
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: swipeView.currentIndex === 3 ? "#BB86FC" : "white"
                    }

                    Text {
                        text: "个人"
                        font.pixelSize: 12
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: swipeView.currentIndex === 3 ? "#BB86FC" : "#AAAAAA"
                    }
                }

                background: Rectangle {
                    color: "transparent"
                    Rectangle {
                        visible: swipeView.currentIndex === 3
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.width * 0.6
                        height: 2
                        color: "#BB86FC"
                    }
                }

                onClicked: swipeView.currentIndex = 3
            }
        }
    }

    // 全局浮动提示
    Popup {
        id: globalNotification
        width: parent.width * 0.7
        height: 60
        x: (parent.width - width) / 2
        y: parent.height * 0.1

        background: Rectangle {
            color: "#5AF7FF"
            radius: 10
            opacity: 0.9
        }

        contentItem: Text {
            text: "指令已识别"
            font.bold: true
            color: "#000000"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        enter: Transition {
            NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 300 }
            NumberAnimation { property: "y"; from: parent.height * 0.05; to: parent.height * 0.1; duration: 300 }
        }

        exit: Transition {
            NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 300 }
        }

        closePolicy: Popup.NoAutoClose

        // 命令识别提示
        function showNotification(message, duration) {
            contentItem.text = message
            open()
            closeTimer.interval = duration
            closeTimer.start()
        }

        Timer {
            id: closeTimer
            interval: 2000
            onTriggered: globalNotification.close()
        }
    }

    // 命令识别监听
    Connections {
        target: homePage

        function onCommandRecognized(command) {
            globalNotification.showNotification("识别指令: " + command, 2000)
        }
    }

    // 入场动画
    ParallelAnimation {
        running: true

        NumberAnimation {
            target: homePage
            property: "opacity"
            from: 0.0
            to: 1.0
            duration: 500
            easing.type: Easing.OutCubic
        }

        NumberAnimation {
            target: swipeView
            property: "scale"
            from: 0.9
            to: 1.0
            duration: 500
            easing.type: Easing.OutBack
        }
    }

    // 温湿度更改时加入数据库
    property real lastTemp: -1
    property real lastHumi: -1
    Connections {
        target: blueToothController

        // 统一信号处理器
        function onTemperatureChanged(temp) {
            lastTemp = parseFloat(temp)
            checkDataReady()
        }

        function onHumidityChanged(humi) { // 修正拼写错误
            lastHumi = parseFloat(humi)
            checkDataReady()
        }

        function checkDataReady() {
            if(lastTemp > -1 && lastHumi > -1) {
                dbManager.addSensorData(lastTemp, lastHumi)
                lastTemp = -1  // 重置状态
                lastHumi = -1
            }
        }
    }
}
