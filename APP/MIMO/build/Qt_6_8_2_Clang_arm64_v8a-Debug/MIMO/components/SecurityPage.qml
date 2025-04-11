import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

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
