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

    // 录音状态管理 - 统一为一个属性
    property bool isRecording: false
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
            property bool enhancedMode: homePage.isRecording
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
        RoomsPage {
            id: roomsPage
        }

        // 页面2 - 互动页面
        InteractionPage{
            id: interactionPage
            isRecording: homePage.isRecording
            onStartRecording: {
                homePage.isRecording = true
                console.log("互动页面请求开始录音")
            }
            onStopRecording: {
                homePage.isRecording = false
                console.log("互动页面请求停止录音")
            }
        }

        // 页面3 - 安保页面
        SecurityPage {
            id: securityPage
        }

        // 页面4 - 个人中心页面
        ProfilePage {
            id: profilePage
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

        property bool isLongPressed: false
        property int longPressThreshold: 800  // 减少长按等待时间
        property int noAudioTimeout: 2000

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
                    if (homePage.isRecording) {
                        // 接入deepseek获取回复
                        aiController.requestAI(interactionPage.resultText.text);
                        // 停止录音和网络连接
                        speechRecognizer.stopRecognize()
                        // 状态恢复
                        homePage.isRecording = false
                        aiCall.isLongPressed = false
                        back.start();
                    }
                }
            }

            onClicked: {
                if (!aiCall.isLongPressed) {
                    // 单击切换到AI助手页面
                    swipeView.currentIndex = 1
                    interactionPage.interactionChoose.currentIndex = 1
                    interactionPage.interactionSwipeView.currentIndex = 1
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
                    interactionPage.interactionChoose.currentIndex = 1 // AI助手
                    interactionPage.interactionSwipeView.currentIndex = 1

                    console.log("启动语音助手")

                    // 先停止任何已存在的录音
                    if (homePage.isRecording) {
                        speechRecognizer.stopRecognize()
                    }

                    // 启动新的录音
                    if (speechRecognizer.startRecognize()) {
                        homePage.isRecording = true
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
                    spacing: 0

                    Text {
                        text: "🏠"
                        font.pixelSize: 20
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
                    spacing: 0

                    Text {
                        text: "🎮"
                        font.pixelSize: 20
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
                    spacing: 0

                    Text {
                        text: "🔒"
                        font.pixelSize: 20
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
                    spacing: 0

                    Text {
                        text: "👤"
                        font.pixelSize: 20
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
}
