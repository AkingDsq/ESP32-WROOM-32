import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

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
