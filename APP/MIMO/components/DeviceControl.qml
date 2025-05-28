import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

// 智能家居设备控制组件
Rectangle {
    id: root

    // 属性定义
    property string deviceName: "设备"
    property string deviceIcon: "💡"
    property bool deviceStatus: false
    property string deviceType: "light" // light, ac, fan, curtain, etc.

    property int idnum: 0
    property int brightness: 100 // 亮度 0-100
    Component.onCompleted: {
        adjustBrightness.connect(blueToothController.onAdjustBrightness)
    }

    property int temperature: 24 // 温度 16-30

    // 信号
    signal toggleDevice()
    signal adjustBrightness(int idnum, int value)
    signal adjustTemperature(int value)

    // 样式
    radius: 10
    color: "#2A2A2A"
    border.width: 1
    border.color: deviceStatus ? "#BB86FC" : "#555555"

    // 状态样式过渡动画
    Behavior on border.color {
        ColorAnimation { duration: 300 }
    }

    // 布局
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 8

        // 顶部标题栏
        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            // 设备图标
            Text {
                text: deviceIcon
                font.pixelSize: 24
            }

            // 设备名称
            Text {
                text: deviceName
                color: "white"
                font.pixelSize: 16
                font.bold: deviceStatus
                Layout.fillWidth: true
            }

            // 状态指示
            Rectangle {
                width: 12
                height: 12
                radius: 6
                color: deviceStatus ? "#5AF7FF" : "#777777"

                // 亮起时的脉动动画
                SequentialAnimation on opacity {
                    running: deviceStatus
                    loops: Animation.Infinite
                    NumberAnimation { to: 0.6; duration: 1500 }
                    NumberAnimation { to: 1.0; duration: 1500 }
                }
            }
        }

        // 中央内容区域 - 根据设备类型显示不同控件
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            // 灯光设备特有
            Column {
                visible: deviceType === "light" && deviceStatus
                anchors.centerIn: parent
                spacing: 5
                width: parent.width

                Text {
                    text: "编号: " + idnum
                    color: "#AAAAAA"
                    font.pixelSize: 12
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text: "亮度: " + brightness + "%"
                    color: "#AAAAAA"
                    font.pixelSize: 12
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Rectangle {
                    width: parent.width * 0.3
                    height: parent.width * 0.3
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: Qt.hsv(
                        colorDialog.selectedColor.hsvHue/360,
                        colorDialog.selectedColor.hsvSaturation,
                        colorDialog.selectedColor.hsvValue,
                    )
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            colorDialog.open()
                        }
                    }
                }

                ColorDialog {
                    id: colorDialog
                    title: "选择颜色"
                    selectedColor: "white" // 初始颜色
                    onAccepted: {
                        console.log("led2:" + idnum + "," + Math.round(selectedColor.hsvHue*255/360) + "," + Math.round(selectedColor.hsvSaturation*255) + "," + Math.round(selectedColor.hsvValue*255))
                        blueToothController.sendCommand("led2:" + idnum + "," + Math.round(selectedColor.hsvHue*255/360) + "," + Math.round(selectedColor.hsvSaturation*255) + "," + Math.round(selectedColor.hsvValue*255))
                    }
                }

                // 亮度调节滑块
                Slider {
                    width: parent.width * 0.8
                    from: 10
                    to: 100
                    value: brightness
                    anchors.horizontalCenter: parent.horizontalCenter

                    background: Rectangle {
                        x: parent.leftPadding
                        y: parent.topPadding + parent.availableHeight / 2 - height / 2
                        width: parent.availableWidth
                        height: 4
                        radius: 2
                        color: "#555555"

                        Rectangle {
                            width: parent.parent.visualPosition * parent.width
                            height: parent.height
                            color: "#BB86FC"
                            radius: 2
                        }
                    }

                    handle: Rectangle {
                        x: parent.leftPadding + parent.visualPosition * (parent.availableWidth - width)
                        y: parent.topPadding + parent.availableHeight / 2 - height / 2
                        width: 16
                        height: 16
                        radius: 8
                        color: "#BB86FC"
                        border.color: "#ffffff"
                        border.width: 2
                    }

                    onMoved: {
                        brightness = Math.round(value)
                        adjustBrightness(idnum, brightness*2.55)
                    }
                }
            }

            // 空调设备特有
            Column {
                visible: deviceType === "ac" && deviceStatus
                anchors.centerIn: parent
                spacing: 5
                width: parent.width

                Text {
                    text: "温度: " + temperature + "°C"
                    color: "#AAAAAA"
                    font.pixelSize: 12
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                // 温度调节按钮
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 20

                    // 减温按钮
                    Rectangle {
                        width: 30
                        height: 30
                        radius: 15
                        color: "#444444"

                        Text {
                            anchors.centerIn: parent
                            text: "-"
                            color: "white"
                            font.pixelSize: 16
                            font.bold: true
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if (temperature > 16) {
                                    temperature--
                                    adjustTemperature(temperature)
                                }
                            }
                        }
                    }

                    // 显示温度
                    Rectangle {
                        width: 40
                        height: 30
                        radius: 4
                        color: "#333333"

                        Text {
                            anchors.centerIn: parent
                            text: temperature
                            color: "#5AF7FF"
                            font.pixelSize: 16
                            font.bold: true
                        }
                    }

                    // 加温按钮
                    Rectangle {
                        width: 30
                        height: 30
                        radius: 15
                        color: "#444444"

                        Text {
                            anchors.centerIn: parent
                            text: "+"
                            color: "white"
                            font.pixelSize: 16
                            font.bold: true
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if (temperature < 30) {
                                    temperature++
                                    adjustTemperature(temperature)
                                }
                            }
                        }
                    }
                }

                // 模式选择
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 10
                    topPadding: 10

                    Repeater {
                        model: ["制冷", "制热", "自动"]

                        Rectangle {
                            width: 50
                            height: 24
                            radius: 12
                            color: index === 0 ? "#5AF7FF" : "#444444"

                            Text {
                                anchors.centerIn: parent
                                text: modelData
                                color: index === 0 ? "#000000" : "#AAAAAA"
                                font.pixelSize: 12
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    // 切换模式
                                }
                            }
                        }
                    }
                }
            }

            // 窗帘设备特有
            Column {
                visible: deviceType === "curtain" && deviceStatus
                anchors.centerIn: parent
                spacing: 10
                width: parent.width

                Text {
                    text: "开合度: 80%"
                    color: "#AAAAAA"
                    font.pixelSize: 12
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                // 开合度滑块
                Slider {
                    width: parent.width * 0.8
                    from: 0
                    to: 100
                    value: 80
                    anchors.horizontalCenter: parent.horizontalCenter

                    background: Rectangle {
                        x: parent.leftPadding
                        y: parent.topPadding + parent.availableHeight / 2 - height / 2
                        width: parent.availableWidth
                        height: 4
                        radius: 2
                        color: "#555555"

                        Rectangle {
                            width: parent.parent.visualPosition * parent.width
                            height: parent.height
                            color: "#BB86FC"
                            radius: 2
                        }
                    }

                    handle: Rectangle {
                        x: parent.leftPadding + parent.visualPosition * (parent.availableWidth - width)
                        y: parent.topPadding + parent.availableHeight / 2 - height / 2
                        width: 16
                        height: 16
                        radius: 8
                        color: "#BB86FC"
                        border.color: "#ffffff"
                        border.width: 2
                    }
                }

                // 操作按钮
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 20

                    Rectangle {
                        width: 60
                        height: 26
                        radius: 13
                        color: "#444444"

                        Text {
                            anchors.centerIn: parent
                            text: "全开"
                            color: "#AAAAAA"
                            font.pixelSize: 12
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                // 全开窗帘
                            }
                        }
                    }

                    Rectangle {
                        width: 60
                        height: 26
                        radius: 13
                        color: "#444444"

                        Text {
                            anchors.centerIn: parent
                            text: "全关"
                            color: "#AAAAAA"
                            font.pixelSize: 12
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                // 全关窗帘
                            }
                        }
                    }
                }
            }

            // 其他设备类型的通用占位符
            Text {
                visible: !deviceStatus || (deviceType !== "light" && deviceType !== "ac" && deviceType !== "curtain")
                anchors.centerIn: parent
                text: deviceStatus ? "设备运行中" : "设备已关闭"
                color: "#AAAAAA"
                font.pixelSize: 14
            }
        }

        // 底部操作栏
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            color: "transparent"

            // 电源按钮
            Rectangle {
                width: 80
                height: 34
                radius: 17
                anchors.centerIn: parent
                gradient: Gradient {
                    GradientStop { position: 0.0; color: deviceStatus ? "#5AF7FF" : "#777777" }
                    GradientStop { position: 1.0; color: deviceStatus ? "#00A9FF" : "#444444" }
                }

                Text {
                    anchors.centerIn: parent
                    text: deviceStatus ? "开启" : "关闭"
                    color: "white"
                    font.pixelSize: 14
                    font.bold: true
                }

                MouseArea {
                    anchors.fill: parent
                    onPressed: parent.scale = 0.95
                    onReleased: parent.scale = 1.0
                    onClicked: toggleDevice()
                }

                Behavior on scale {
                    NumberAnimation { duration: 100 }
                }
            }
        }
    }
}
