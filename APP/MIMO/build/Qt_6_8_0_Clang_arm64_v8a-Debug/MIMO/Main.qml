pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls

import "./components"

ApplicationWindow {
    id: mainWindow
    width: 618
    height: 1338
    visible: true
    color: Qt.rgba(47/255,36/255,36/255,1)

    title: qsTr("Hello World")
    // 监听屏幕旋转事件并调整布局：
    Screen.onPrimaryOrientationChanged: {
        if (Screen.primaryOrientation === Qt.LandscapeOrientation) {
            console.log("切换到横屏模式")
        } else {
            console.log("切换到竖屏模式")
        }
    }

    // 主窗口结构
    SwipeView {
        id: swipeView
        width: parent.width
        height: parent.height - bottomArea.height
        anchors.top: parent.top
        z : 2

        currentIndex: 0


        // 页面1
        Page {
            z : 3
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
                color: Qt.rgba(31/255, 24/255, 24/255, 1)

                // 可以在这里添加与当前按钮索引关联的内容
                Text {
                    width: parent.width
                    height:parent.height
                    anchors.centerIn: parent
                    text: "智能家居"
                    color: "white"
                    font.pixelSize: height * 0.25
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                Rectangle{
                    z: 4
                    color: "red"
                    width: parent.width * 0.15
                    height: parent.height
                    anchors{
                        top: parent.top
                        right: parent.right
                    }

                    Text{
                        text: "添加房间"
                        anchors.centerIn: parent
                        font.pixelSize: (parent.width + parent.height) * 0.1
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            console.log("添加")
                            listModel.append({})  // 动态增加一项
                        }
                    }
                }
            }
            // 房间选择的拖动显示动画
            MouseArea {
                width: parent.width
                height: parent.height - topArea.height
                anchors{
                    top: topArea.bottom
                    right: parent.right
                }
                drag.target: wheelArea
                drag.axis: Drag.XAxis
                // 限制拖动范围
                drag.minimumX: -wheelArea.width
                drag.maximumX: 0
                // 拖动超过一半全部显示，反之隐藏
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
                // Add some example rooms
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
                height: parent.parent.height - topArea.height
                anchors.top: topArea.bottom
                color: "#e0e0e0"

                // 滑动动画
                x: -width // 初始隐藏到左侧屏幕外
                Behavior on x {
                    NumberAnimation {
                        duration: 300
                        easing.type: Easing.OutQuad
                    }
                }
                // Center indicator
                Rectangle {
                    z: 1
                    anchors.centerIn: parent
                    width: parent.width
                    height: 60
                    color: "#8000a0ff"
                    opacity: 0.3
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
                    highlightRangeMode: ListView.StrictlyEnforceRange     // 选中项居中
                    highlightMoveDuration: 200

                    // 高光框
                    highlight: Rectangle {
                        color: "transparent"
                        border { width: 2; color: "#0066cc" }
                        radius: 8
                    }
                    // 停止时执行
                    onMovementEnded: {
                        // Execute the selected button's logic
                        console.log("Selected room:", listModel.get(currentIndex).name)
                        // Add your logic to control the selected room here
                    }

                    delegate: Button {
                        id: room
                        required property int index
                        required property var model

                        width: wheelArea.width
                        height: wheelArea.height * 0.1
                        anchors.horizontalCenter: parent.horizontalCenter

                        // 选中时放大
                        scale: ListView.isCurrentItem ? 1 : 0.9
                        opacity: ListView.isCurrentItem ? 1.0 : 0.7

                        // 动画
                        Behavior on scale { NumberAnimation { duration: 100 } }
                        Behavior on opacity { NumberAnimation { duration: 100 } }

                        text: model.name
                        font.pixelSize: ListView.isCurrentItem ? 16 : 14

                        background: Rectangle {
                            color: "#333333"
                            opacity: 0.8
                            radius: 8
                        }

                        contentItem: Text {
                            text: parent.text
                            font: parent.font
                            color: "white"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            width: parent.width  // 约束文本宽度
                            wrapMode: Text.Wrap  // 启用自动换行
                            elide: Text.ElideRight // 仅在换行失败时截断
                        }

                        onClicked: {
                            roomsChoose.currentIndex = index
                            roomsChoose.positionViewAtIndex(index, ListView.Center)
                        }
                    }
                }
            }
            // 数据模型
            ListModel { id: pageModel }

            // 房间选择区域
            SwipeView {
                Repeater {
                    model: ListModel { id: pageModel }
                    delegate: Rectangle {
                        color: model.bgColor
                        Text { text: model.text; anchors.centerIn: parent }
                    }
                }

                Component.onCompleted: {
                    // 读取 JSON 文件并填充模型
                    var xhr = new XMLHttpRequest();
                    xhr.open("GET", "pages.json");
                    xhr.onreadystatechange = function() {
                        if (xhr.readyState === XMLHttpRequest.DONE) {
                            var pages = JSON.parse(xhr.responseText);
                            pages.forEach(page => pageModel.append(page));
                        }
                    };
                    xhr.send();
                }
            }
        }
        interactive: !interactionSwipeView.innerSwipeActive // 当内层激活时禁用外层

        // 页面2(音视频)
        Page {
            z : 2
            // 互动物品选择
            ListModel {
                id: interactionListModel
                // Add some example rooms
                Component.onCompleted: {
                    append({ name: "music" })
                    append({ name: "AI" })
                    append({ name: "sss" })
                }
            }
            // 轮盘选择区域
            Rectangle {
                id: interactionWheelArea
                width: parent.width
                height: parent.height * 0.1
                anchors {
                    top: parent.top
                    left: parent.left
                }
                color: "#e0e0e0"

                // Center indicator
                Rectangle {
                    z: 1
                    anchors.centerIn: parent
                    width: 60
                    height: parent.height
                    color: "#8000a0ff"
                    opacity: 0.3
                }

                ListView {
                    id: interactionChoose
                    anchors.fill: parent

                    Component.onCompleted: {
                        Qt.callLater(() => {
                            currentIndex = Math.floor(interactionListModel.count / 2);
                            positionViewAtIndex(currentIndex, ListView.Center);
                        });
                    }

                    orientation: ListView.Horizontal
                    spacing: 10
                    snapMode: ListView.SnapToItem
                    model: interactionListModel
                    clip: true
                    boundsBehavior: Flickable.StopAtBounds
                    flickDeceleration: 1500

                    // 中间高光
                    preferredHighlightBegin: width/2 - 30
                    preferredHighlightEnd: width/2 + 30
                    highlightRangeMode: ListView.StrictlyEnforceRange     // 选中项居中
                    highlightMoveDuration: 200

                    // 高光框
                    highlight: Rectangle {
                        color: "transparent"
                        border { width: 2; color: "#0066cc" }
                        radius: 8
                    }
                    // 停止时执行
                    onMovementEnded: {
                        // 切换到相应页面
                        interactionSwipeView.currentIndex = interactionChoose.currentIndex
                    }

                    delegate: Button {
                        id: interaction
                        required property int index
                        required property var model

                        width: 60
                        height: parent.height
                        anchors.verticalCenter: parent.verticalCenter

                        // 选中时放大
                        scale: ListView.isCurrentItem ? 1.1 : 0.9
                        opacity: ListView.isCurrentItem ? 1.0 : 0.7

                        // 动画
                        Behavior on scale { NumberAnimation { duration: 100 } }
                        Behavior on opacity { NumberAnimation { duration: 100 } }

                        text: model.name

                        background: Rectangle {
                            color: "#333333"
                            opacity: 0.8
                            radius: 8
                        }

                        contentItem: Text {
                            text: parent.text
                            font: Math.min(parent.height, parent.width) * 0.5
                            color: "white"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            width: parent.width  // 约束文本宽度
                            wrapMode: Text.Wrap  // 启用自动换行
                            elide: Text.ElideRight // 仅在换行失败时截断
                        }
                        onClicked: {
                            interactionChoose.currentIndex = index
                            interactionChoose.positionViewAtIndex(index, ListView.Center)
                            interactionSwipeView.currentIndex = index
                        }
                    }
                }
            }
            // 背景
            // 主窗口结构
            SwipeView {
                id: interactionSwipeView
                width: parent.width
                height: parent.height - interactionWheelArea.height - bottomArea.height
                anchors.top: interactionWheelArea.bottom

                z : 1

                Component.onCompleted: {
                    Qt.callLater(() => {
                        currentIndex = Math.floor(interactionListModel.count / 2);
                    });
                }

                property bool innerSwipeActive: false // 声明控制变量
                interactive: true

                property bool atLeftEdge: currentIndex === 0
                property bool atRightEdge: currentIndex === count - 1

                onCurrentIndexChanged: {
                    // 到达边界时允许外层滑动
                    if (atLeftEdge || atRightEdge) innerSwipeActive = false;
                    // 保持选择框同步
                    interactionChoose.currentIndex = interactionSwipeView.currentIndex
                }

                // 页面1
                Page {
                    z:1
                    clip: true  // 关键！防止子组件溢出到其他页面
                    Rectangle{
                        x: parent.width/2 - width/2
                        y: parent.height/2 - height/2
                        width: 60
                        height:60
                        color: "blue"
                    }
                }
                // 页面2
                Page {
                    z:1
                    clip: true  // 关键！防止子组件溢出到其他页面
                    Rectangle{
                        width: 60
                        height:60
                        x: parent.width/2 - width/2
                        y: parent.height/2 - height/2
                        color: "red"
                    }
                }
                // 页面3
                Page {
                    z:1
                    clip: true  // 关键！防止子组件溢出到其他页面
                    Rectangle{
                        width: 60
                        height:60
                        x: parent.width/2 - width/2
                        y: parent.height/2 - height/2
                        color: "green"
                    }
                }
            }

            // 滑块

            // 控制


        }

        // 页面3
        Page {
            z:2
            Rectangle {
                width: parent.width
                height: parent.height/2
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }
                Button {
                    width: 60
                    height: 60
                    anchors {
                        top: parent.top
                    }
                    text: "Scan for ESP32"
                    onClicked: blueToothController.startScan()
                }
                Label {
                    width: parent.width/2
                    height: parent.height/2
                    y: parent.height/2
                    text: "Temperature: " + blueToothController.temperature + "°C"
                    font.pixelSize: 24
                }

                Label {
                    width: parent.width/2
                    height: parent.height/2
                    y: parent.height/4
                    text: "Humidity: " + blueToothController.humidity + "%"
                    font.pixelSize: 24
                }
            }
        }

        // 页面4
        Page {
            z:2
        }
    }

    // 语音识别完成信号
    signal recognitionCompleted(string text)
    // AI助手按钮
    Rectangle {
        id: aiCall
        width: (parent.width + parent.height) * 0.07
        height: width
        radius: width/2
        anchors {
            bottom: bottomArea.top          // 底部锚定到父容器底部
            horizontalCenter: parent.horizontalCenter  // 水平居中
            bottomMargin: (parent.height - bottomArea.height) * 0.05  // 距离底部20%高度
        }
        color: Qt.rgba(65/255,167/255,166/255,1)
        z: 100

        Text {
            id: label
            text: "YES"
            anchors.centerIn: parent
            color: "white"
            font { bold: true; pixelSize: 16 }
        }

        property bool isListening: false    // 麦克风监听
        property bool isLongPressed: false  // 长按监听
        property int longPressThreshold: 1000 // 长按时间阈值（毫秒）
        property int noAudioTimeout: 2000 // 无音频输入超时（毫秒）
        property string recognizedText: ""

        // 点击的动画
        SequentialAnimation on scale {
            id: clickAiCall
            loops: 1
            NumberAnimation { to: 1; duration: 100 }
            NumberAnimation { to: 1.1; duration: 100 }
        }
        // 复位的动画
        NumberAnimation on scale {
            id: back
            to: 1.0;
            duration: 100
        }
        // 长按的动画
        ParallelAnimation on scale{
            id: pressAiCall
            loops: 1
            NumberAnimation { to: 1.5; duration: 100 }
        }
        // 取消长按
        function create_cancel_callai() {
            var component = Qt.createComponent("./components/Cancel_CallAI.qml");
            if (component.status === Component.Ready) {
                var instance = component.createObject(mainWindow, {
                    "width": mainWindow.width,
                    "height": mainWindow.height,
                    "anchors.fill": mainWindow
                });
                // 绑定信号到销毁逻辑
                instance.buttonClicked.connect(() => {
                    aiCall.isLongPressed = false
                    aiCall.color = Qt.rgba(65/255, 167/255, 166/255, 1)
                    back.start();
                    instance.destroy(200);
                    console.log("组件已销毁");
                });
            }
        }

        MouseArea {
            anchors.fill: parent
            // 按压事件
            onPressed: {
                pressAiCall.start();
                parent.color = Qt.darker("#2196F3", 1.2);
                longPressTimer.start();
            }
            // 松开事件
            onReleased:{
                // 如果不在长按状态，恢复，否则保持
                if(!aiCall.isLongPressed){
                    longPressTimer.stop()
                    parent.color = Qt.rgba(65/255, 167/255, 166/255, 1)
                    back.start();
                }
            }
            // 长按判定
            Timer {
                id: longPressTimer
                interval: aiCall.longPressThreshold  // 长按（longPressThreshold）秒触发
                onTriggered: {
                    longPressTimer.stop()
                    // 进入长按状态
                    aiCall.isLongPressed = true
                    // 创建取消长按组件
                    aiCall.create_cancel_callai()
                    // 跳转音视频界面的AI界面
                    swipeView.currentIndex = 1
                    interactionChoose.currentIndex = Math.floor(interactionListModel.count / 2)
                    interactionSwipeView.currentIndex = Math.floor(interactionListModel.count / 2)
                    // 调用语音录制和识别模块
                    console.log("send1");
                    aiController.call("start"); // 直接调用C++方法
                    console.log("send2");
                    // 开始监听音频输入
                    aiCall.isListening = true
                    //aiController.startAudioDetection()
                }
            }
        }
    }
    // 接收 C++ 发送的信号
    Connections {
        target: aiController // 这是在 main.cpp 中注册的 C++ 对象
        function onAiResponseReceived(response) {
            console.log(response);
        }
    }

    // 底部区域
    Row {
        id: bottomArea
        width: parent.width
        height: parent.height * 0.07
        anchors {
            bottom: parent.bottom
            left: parent.left
        }
        z: 99

        BottonButtonChoose{
            id: rooms
            btnText: "房间"
            onButtonClicked:{
                swipeView.currentIndex = 0  // 点击跳转下一页
                console.log("当前页面" + swipeView.currentIndex + 1)
            }
        }

        BottonButtonChoose{
            id: no
            btnText: "互动"
            onButtonClicked:{
                swipeView.currentIndex = 1  // 点击跳转下一页
                console.log("当前页面" + swipeView.currentIndex + 1)
            }
        }
        BottonButtonChoose{
            id: safety
            btnText: "安保"
            onButtonClicked:{
                swipeView.currentIndex = 2  // 点击跳转下一页
                console.log("当前页面" + swipeView.currentIndex + 1)
            }
        }
        BottonButtonChoose{
            id: personalCenter
            btnText: "个人"
            onButtonClicked:{
                swipeView.currentIndex = 3  // 点击跳转下一页
                console.log("当前页面" + swipeView.currentIndex + 1)
            }
        }
    }
}
