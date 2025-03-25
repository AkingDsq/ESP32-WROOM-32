// ./components/Home.qml
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

            Component.onCompleted: {
                for (var i = 0; i < particleCount; i++) {
                    particles.push({
                        x: Math.random() * width,
                        y: Math.random() * height,
                        size: Math.random() * 3 + 1,
                        opacity: Math.random() * 0.2 + 0.05,
                        speed: Math.random() * 0.3 + 0.1,
                        angle: Math.random() * Math.PI * 2
                    });
                }
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

                        if (bgParticles.touching) {
                            var dx = bgParticles.touchPoint.x - p.x;
                            var dy = bgParticles.touchPoint.y - p.y;
                            var dist = Math.sqrt(dx * dx + dy * dy);

                            if (dist < 80) {
                                p.x += dx * 0.01;
                                p.y += dy * 0.01;
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
                    ctx.fillStyle = Qt.rgba(0.6, 0.4, 1.0, p.opacity);
                    ctx.beginPath();
                    ctx.arc(p.x, p.y, p.size, 0, Math.PI * 2);
                    ctx.fill();
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

            // 房间选择的拖动显示动画
            MouseArea {
                width: parent.width
                height: parent.height - topArea.height
                anchors {
                    top: topArea.bottom
                    right: parent.right
                }
                drag.target: wheelArea
                drag.axis: Drag.XAxis
                drag.minimumX: -wheelArea.width
                drag.maximumX: 0

                onReleased: {
                    if (wheelArea.x > -wheelArea.width/2) wheelArea.x = 0
                    else wheelArea.x = -wheelArea.width
                }

                onClicked: {
                    if (wheelArea.x == 0) wheelArea.x = -wheelArea.width
                }
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

                    Component.onCompleted: {
                        Qt.callLater(() => {
                            currentIndex = Math.floor(listModel.count / 2);
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
                            }
                        }
                    }
                }
            }

            // 房间内容展示区
            Item {
                anchors {
                    top: topArea.bottom
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }

                // 当前选中的房间显示
                Text {
                    anchors.centerIn: parent
                    text: listModel.count > 0 ?
                          "当前选择: " + listModel.get(roomsChoose.currentIndex).name :
                          "请添加房间"
                    color: "#BB86FC"
                    font.pixelSize: 24
                    font.bold: true
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
                                height: 200
                                radius: 10
                                color: "#2A2A2A"
                                border.width: 1
                                border.color: "#BB86FC"

                                Text {
                                    id: responseText
                                    anchors.fill: parent
                                    anchors.margins: 10
                                    text: "您好，" + username + "。我可以为您提供哪些帮助？\n\n试试长按屏幕底部的YES按钮进行语音交互。"
                                    color: "white"
                                    wrapMode: Text.Wrap
                                    verticalAlignment: Text.AlignTop
                                }
                            }

                            // 麦克风按钮 - 与底部YES按钮功能类似
                            Rectangle {
                                width: 80
                                height: 80
                                radius: 40
                                anchors.horizontalCenter: parent.horizontalCenter
                                gradient: Gradient {
                                    GradientStop { position: 0.0; color: "#7B2BFF" }
                                    GradientStop { position: 1.0; color: "#BB86FC" }
                                }

                                Text {
                                    anchors.centerIn: parent
                                    text: "🎤"
                                    font.pixelSize: 36
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onPressed: parent.scale = 0.9
                                    onReleased: parent.scale = 1.0
                                    onClicked: {
                                        console.log("启动语音助手")
                                    }
                                }

                                Behavior on scale {
                                    NumberAnimation { duration: 100 }
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
            background: Rectangle { color: "transparent" }

            Rectangle {
                width: parent.width * 0.9
                height: parent.height * 0.9
                anchors.centerIn: parent
                color: "#1E1E1E"
                radius: 15

                Column {
                    anchors.centerIn: parent
                    spacing: 30
                    width: parent.width * 0.8

                    Text {
                        text: "安保中心"
                        color: "white"
                        font.pixelSize: 28
                        font.bold: true
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    // 传感器数据显示
                    Column {
                        width: parent.width
                        spacing: 15

                        Repeater {
                            model: [
                                { name: "温度", value: blueToothController.temperature + "°C", icon: "🌡️" },
                                { name: "湿度", value: blueToothController.humidity + "%", icon: "💧" },
                                { name: "门窗状态", value: "已锁定", icon: "🔒" },
                                { name: "移动检测", value: "正常", icon: "👁️" }
                            ]

                            Rectangle {
                                width: parent.width
                                height: 70
                                radius: 10
                                color: "#2A2A2A"

                                Row {
                                    anchors.fill: parent
                                    anchors.margins: 10
                                    spacing: 15

                                    Text {
                                        text: modelData.icon
                                        font.pixelSize: 30
                                        anchors.verticalCenter: parent.verticalCenter
                                    }

                                    Column {
                                        anchors.verticalCenter: parent.verticalCenter
                                        spacing: 4

                                        Text {
                                            text: modelData.name
                                            color: "#AAAAAA"
                                            font.pixelSize: 14
                                        }

                                        Text {
                                            text: modelData.value
                                            color: "white"
                                            font.pixelSize: 18
                                            font.bold: true
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // 设备扫描按钮
                    Rectangle {
                        width: parent.width * 0.7
                        height: 56
                        radius: 28
                        anchors.horizontalCenter: parent.horizontalCenter
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: "#7B2BFF" }
                            GradientStop { position: 1.0; color: "#BB86FC" }
                        }

                        Text {
                            anchors.centerIn: parent
                            text: "扫描设备"
                            color: "white"
                            font.pixelSize: 16
                            font.bold: true
                        }

                        MouseArea {
                            anchors.fill: parent
                            onPressed: parent.scale = 0.95
                            onReleased: parent.scale = 1.0
                            onClicked: {
                                console.log("扫描设备")
                                blueToothController.startScan()
                            }
                        }

                        Behavior on scale {
                            NumberAnimation { duration: 100 }
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

    // AI助手按钮
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
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#7B2BFF" }
            GradientStop { position: 1.0; color: "#BB86FC" }
        }
        z: 100

        Text {
            id: label
            text: "YES"
            anchors.centerIn: parent
            color: "white"
            font { bold: true; pixelSize: 16 }
        }

        property bool isListening: false
        property bool isLongPressed: false
        property int longPressThreshold: 1000
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

        MouseArea {
            anchors.fill: parent
            onPressed: {
                pressAiCall.start();
                parent.color = Qt.darker("#BB86FC", 1.2);
                longPressTimer.start();
            }

            onReleased: {
                if(!aiCall.isLongPressed) {
                    longPressTimer.stop()
                    // parent.gradient = Gradient {
                    //     GradientStop { position: 0.0; color: "#7B2BFF" }
                    //     GradientStop { position: 1.0; color: "#BB86FC" }
                    // }
                    back.start();
                }
            }

            Timer {
                id: longPressTimer
                interval: aiCall.longPressThreshold
                onTriggered: {
                    longPressTimer.stop()
                    aiCall.isLongPressed = true

                    // 跳转到AI助手页面
                    swipeView.currentIndex = 1
                    interactionChoose.currentIndex = 1 // AI助手
                    interactionSwipeView.currentIndex = 1

                    console.log("启动语音助手")
                    aiCall.isListening = true
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
                    spacing: 4

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
                    spacing: 4

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
                    spacing: 4

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
                    spacing: 4

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

    // 入场动画
    NumberAnimation {
        target: homePage
        property: "opacity"
        from: 0.0
        to: 1.0
        duration: 500
        running: true
    }
}
