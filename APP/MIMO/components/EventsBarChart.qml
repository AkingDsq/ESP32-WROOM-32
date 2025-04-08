// EventsBarChart.qml
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root
    color: "#2A2A2A"
    radius: 10

    property var days: []
    property var counts: []

    // 标题
    Text {
        id: chartTitle
        text: "安全事件统计"
        color: "white"
        font.pixelSize: 16
        font.bold: true
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 15
    }

    // 图表区域
    Rectangle {
        id: chartArea
        anchors.top: chartTitle.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 15
        color: "#1E1E1E"
        radius: 5

        // 网格线
        Canvas {
            id: gridCanvas
            anchors.fill: parent
            antialiasing: true
            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();

                // 绘制水平网格线
                ctx.strokeStyle = "#333333";
                ctx.lineWidth = 1;

                var stepY = height / 5;
                for (var i = 1; i < 5; i++) {
                    var y = height - stepY * i;
                    ctx.beginPath();
                    ctx.moveTo(0, y);
                    ctx.lineTo(width, y);
                    ctx.stroke();
                }
            }
        }

        // 柱状图
        Canvas {
            id: barsCanvas
            anchors.fill: parent
            anchors.bottomMargin: 25  // 留出空间给标签
            antialiasing: true
            onPaint: {
                if (days.length === 0 || counts.length === 0) return;

                var ctx = getContext("2d");
                ctx.reset();

                // 找出最大计数值用于缩放
                var maxCount = Math.max.apply(null, counts);
                maxCount = maxCount + 2; // 添加一些间隙

                // 计算柱状图宽度
                var barWidth = width / counts.length * 0.6;
                var barSpacing = width / counts.length;

                // 绘制柱状图
                for (var i = 0; i < counts.length; i++) {
                    var x = i * barSpacing + (barSpacing - barWidth) / 2;
                    var barHeight = (counts[i] / maxCount) * height;
                    var y = height - barHeight;

                    // 绘制渐变柱状图
                    var gradient = ctx.createLinearGradient(x, y, x, height);
                    gradient.addColorStop(0, "#BB86FC");
                    gradient.addColorStop(1, "#7B2BFF");

                    ctx.fillStyle = gradient;
                    ctx.beginPath();
                    ctx.roundRect(x, y, barWidth, barHeight, 5);
                    ctx.fill();

                    // 绘制顶部值标签
                    ctx.fillStyle = "white";
                    ctx.font = "bold 12px sans-serif";
                    ctx.textAlign = "center";
                    ctx.fillText(counts[i], x + barWidth/2, y - 5);
                }
            }
        }

        // 底部类别标签
        Row {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 25

            Repeater {
                model: days.length

                Text {
                    width: parent.width / days.length
                    height: 25
                    text: days[index]
                    color: "#AAAAAA"
                    font.pixelSize: 12
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }

    // 更新函数
    function updateChart() {
        gridCanvas.requestPaint();
        barsCanvas.requestPaint();
    }

    // 监听数据变化
    onDaysChanged: updateChart()
    onCountsChanged: updateChart()

    Component.onCompleted: {
        updateChart();
    }
}
