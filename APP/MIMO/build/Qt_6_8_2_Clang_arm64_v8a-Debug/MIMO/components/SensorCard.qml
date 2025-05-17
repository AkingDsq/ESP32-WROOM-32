// SensorCard.qml
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root
    color: "#3A3A3A"
    radius: 10

    property string icon: "🌡️"
    property string title: "温度"
    property string value: "25°C"
    property string trend: "rising" // "rising", "falling", "stable"
    property color accentColor: "#BB86FC"

    // 渐变边框效果
    Rectangle {
        id: gradientBorder
        anchors.fill: parent
        radius: 10
        color: "transparent"

        // 使用矩形代替渐变边框
        Rectangle {
            anchors.fill: parent
            anchors.margins: 2
            radius: 8
            color: root.color
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 15

        // 图标容器
        Rectangle {
            Layout.preferredWidth: 45
            Layout.preferredHeight: 45
            Layout.alignment: Qt.AlignVCenter
            radius: 22.5
            color: Qt.rgba(
                root.accentColor.r,
                root.accentColor.g,
                root.accentColor.b,
                0.2
            )

            Text {
                anchors.centerIn: parent
                text: root.icon
                font.pixelSize: 24
            }
        }

        // 数据内容
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 5

            Text {
                text: root.title
                color: "#AAAAAA"
                font.pixelSize: 14
            }

            Text {
                text: root.value
                color: "white"
                font.pixelSize: 22
                font.bold: true
            }
        }

        // 趋势指示器
        Canvas {
            Layout.preferredWidth: 35
            Layout.preferredHeight: 35
            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
            visible: root.trend !== "stable"

            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();
                ctx.lineWidth = 3;
                ctx.strokeStyle = root.trend === "rising" ? "#4CAF50" : "#F44336";

                if (root.trend === "rising") {
                    // 绘制上升箭头
                    ctx.beginPath();
                    ctx.moveTo(width/2, 5);
                    ctx.lineTo(width/2, height-5);
                    ctx.moveTo(width/2, 5);
                    ctx.lineTo(width/2-8, 13);
                    ctx.moveTo(width/2, 5);
                    ctx.lineTo(width/2+8, 13);
                    ctx.stroke();
                } else {
                    // 绘制下降箭头
                    ctx.beginPath();
                    ctx.moveTo(width/2, height-5);
                    ctx.lineTo(width/2, 5);
                    ctx.moveTo(width/2, height-5);
                    ctx.lineTo(width/2-8, height-13);
                    ctx.moveTo(width/2, height-5);
                    ctx.lineTo(width/2+8, height-13);
                    ctx.stroke();
                }
            }
        }
    }

    // 悬停效果
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: hoverAnimation.start()
        onExited: exitAnimation.start()
    }

    PropertyAnimation {
        id: hoverAnimation
        target: root
        property: "scale"
        to: 1.03
        duration: 200
        easing.type: Easing.OutQuad
    }

    PropertyAnimation {
        id: exitAnimation
        target: root
        property: "scale"
        to: 1.0
        duration: 200
        easing.type: Easing.OutQuad
    }
}
