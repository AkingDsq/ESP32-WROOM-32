import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// 页面2 - 互动页面
Page {
    id: interactionPage
    background: Rectangle { color: "transparent" }

    property alias interactionChoose: interactionChoose
    property alias interactionSwipeView: interactionSwipeView
    property alias resultText: resultText
    property string recognizedText: ""

    // 录音状态
    property bool isRecording: false

    // 向HomePage发送控制信号
    signal startRecording()
    signal stopRecording()

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
                                    // 接入deepseek获取回复
                                    aiController.requestAI(resultText.text);
                                    // 停止
                                    speechRecognizer.stopRecognize()
                                    stopRecording()
                                } else {
                                    console.log("启动语音助手")
                                    blueToothController.sendCommand("startVoice")
                                    startRecording()
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
                                    stopRecording()
                                }
                            }
                        }

                        function onErrorOccurred(errorMsg) {
                            stopRecording()
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
