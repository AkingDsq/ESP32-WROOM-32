import QtQuick

Item {
    id: root
    width: 300
    height: 300

    // 配置参数
    property real minValue: 0      // 最小值
    property real maxValue: 100    // 最大值
    property real currentValue: 50 // 当前值
    property real startAngle: -120 // 起始角度（度）
    property real endAngle: 120    // 结束角度（度）
    property color trackColor: "#e0e0e0"
    property color progressColor: "#2196F3"
    property real trackWidth: 8

    // 计算圆弧半径
    readonly property real radius: Math.min(width, height) * 0.4 - trackWidth

    // 中心点坐标
    readonly property point center: Qt.point(width/2, height/2)

    // 当前角度（根据值计算）
    readonly property real currentAngle: {
        const range = endAngle - startAngle
        return startAngle + (currentValue - minValue)/(maxValue - minValue) * range
    }

    // 画布：绘制轨道和进度
    Canvas {
        id: canvas
        anchors.fill: parent
        antialiasing: true

        onPaint: {
            const ctx = getContext("2d")
            ctx.reset()

            // 绘制背景轨道
            drawArc(ctx, trackColor, startAngle, endAngle)

            // 绘制进度轨道
            drawArc(ctx, progressColor, startAngle, currentAngle)
        }

        function drawArc(ctx, color, start, end) {
            ctx.beginPath()
            ctx.strokeStyle = color
            ctx.lineWidth = trackWidth
            ctx.arc(center.x, center.y, radius,
                degToRad(start - 90), degToRad(end - 90)) // -90 修正起始点
            ctx.stroke()
        }

        function degToRad(deg) {
            return deg * (Math.PI / 180)
        }
    }

    // 滑块手柄
    Rectangle {
        id: handle
        width: 24
        height: 24
        radius: 12
        color: progressColor
        border.width: 2
        border.color: Qt.darker(progressColor, 1.2)

        x: center.x + Math.cos(degToRad(currentAngle - 90)) * radius - width/2
        y: center.y + Math.sin(degToRad(currentAngle - 90)) * radius - height/2

        Behavior on x { NumberAnimation { duration: 100 } }
        Behavior on y { NumberAnimation { duration: 100 } }

        function degToRad(deg) {
            return deg * (Math.PI / 180)
        }
    }

    // 交互区域
    MouseArea {
        anchors.fill: parent
        preventStealing: true

        function calculateValue(mouseX, mouseY) {
            // 计算相对中心点的角度
            const dx = mouseX - center.x
            const dy = mouseY - center.y
            let angle = Math.atan2(dy, dx) * (180 / Math.PI) + 90 // 修正角度偏移

            // 标准化到 [startAngle, endAngle] 范围
            angle = Math.max(startAngle, Math.min(endAngle, angle))

            // 转换角度为数值
            const range = endAngle - startAngle
            root.currentValue = minValue + (angle - startAngle)/range * (maxValue - minValue)
        }

        onPositionChanged: calculateValue(mouse.x, mouse.y)
        onClicked: calculateValue(mouse.x, mouse.y)
    }

    // 显示当前值
    Text {
        anchors.centerIn: parent
        text: currentValue.toFixed(0)
        font.pixelSize: 24
        color: progressColor
    }
}
