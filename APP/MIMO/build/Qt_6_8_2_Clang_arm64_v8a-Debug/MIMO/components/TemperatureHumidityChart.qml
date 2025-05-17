import QtQuick
import QtCharts
import QtQuick.Layouts
import QtQuick.Controls

Item {
    id: root

    property var tempData: []
    property var humidityData: []
    property var timeLabels: []

    // 记录上一次的轴范围，用于平滑过渡
    property var lastTempRange: ({min: 0, max: 50})
    property var lastHumRange: ({min: 0, max: 100})

    // 分析数据
    property var analysis: ({
        tempAvg: calculateAverage(tempData),
        tempMin: calculateMin(tempData),
        tempMax: calculateMax(tempData),
        tempTrend: calculateTrend(tempData),
        humidityAvg: calculateAverage(humidityData),
        humidityMin: calculateMin(humidityData),
        humidityMax: calculateMax(humidityData),
        humidityTrend: calculateTrend(humidityData)
    })

    // 计算平均值
    function calculateAverage(data) {
        if (!data || data.length === 0) return 0;
        var sum = data.reduce((a, b) => a + b, 0);
        return (sum / data.length).toFixed(1);
    }

    // 计算最小值
    function calculateMin(data) {
        if (!data || data.length === 0) return 0;
        return Math.min(...data).toFixed(1);
    }

    // 计算最大值
    function calculateMax(data) {
        if (!data || data.length === 0) return 0;
        return Math.max(...data).toFixed(1);
    }

    // 计算标准差 - 用于判断数据波动程度
    function calculateStdDev(data) {
        if (!data || data.length <= 1) return 0;
        var avg = data.reduce((a, b) => a + b, 0) / data.length;
        var sumOfSquares = data.reduce((a, b) => a + Math.pow(b - avg, 2), 0);
        return Math.sqrt(sumOfSquares / (data.length - 1));
    }

    // 智能计算轴范围，处理微小变化和突变
    function calculateAxisRange(data, lastRange, isTemp) {
        if (!data || data.length === 0) {
            return lastRange;
        }

        // 获取基本统计数据
        var min = parseFloat(Math.min(...data));
        var max = parseFloat(Math.max(...data));
        var range = max - min;
        var stdDev = calculateStdDev(data);

        // 计算智能填充比例 - 范围小时用更大的填充
        var paddingRatio;
        if (range < 1) {
            // 极小范围，使用较大填充
            paddingRatio = 0.5;  // 50% padding
        } else if (range < 5) {
            // 小范围，中等填充
            paddingRatio = 0.3;  // 30% padding
        } else {
            // 正常或大范围，小填充
            paddingRatio = 0.15; // 15% padding
        }

        // 检测异常值 - 如果有异常值，增加上下界
        var padding = Math.max(range * paddingRatio, stdDev * 0.5);

        // 确保最小填充
        var minPadding = isTemp ? 1 : 2; // 温度最小1度，湿度最小2%
        padding = Math.max(padding, minPadding);

        // 计算新的范围
        var newMin = Math.max(0, min - padding);
        var newMax = max + padding;

        // 如果是湿度，最大不超过100%
        if (!isTemp) {
            newMax = Math.min(100, newMax);
        }

        // 平滑过渡 - 与上次范围混合，避免抖动
        var smoothFactor = 0.7; // 平滑因子，数值越大越平滑
        var smoothMin = lastRange.min * smoothFactor + newMin * (1 - smoothFactor);
        var smoothMax = lastRange.max * smoothFactor + newMax * (1 - smoothFactor);

        // 确保最小范围 - 避免显示过于扁平
        var minDisplayRange = isTemp ? 5 : 10; // 温度最小5度范围，湿度最小10%范围
        if (smoothMax - smoothMin < minDisplayRange) {
            var mid = (smoothMax + smoothMin) / 2;
            smoothMin = mid - minDisplayRange / 2;
            smoothMax = mid + minDisplayRange / 2;

            // 再次检查边界
            if (smoothMin < 0) {
                smoothMin = 0;
                smoothMax = Math.max(smoothMax, minDisplayRange);
            }
            if (!isTemp && smoothMax > 100) {
                smoothMax = 100;
                smoothMin = Math.min(smoothMin, 100 - minDisplayRange);
            }
        }

        return {
            min: smoothMin,
            max: smoothMax
        };
    }

    // 计算趋势 (上升/下降/稳定)
    function calculateTrend(data) {
        if (!data || data.length < 3) return "stable";

        // 使用最近的5个数据点或全部数据点（取较小值）
        var pointsToAnalyze = Math.min(5, data.length);
        var recentData = data.slice(data.length - pointsToAnalyze);

        // 线性回归计算斜率
        var n = recentData.length;
        var sumX = 0;
        var sumY = 0;
        var sumXY = 0;
        var sumXX = 0;

        for (var i = 0; i < n; i++) {
            sumX += i;
            sumY += recentData[i];
            sumXY += i * recentData[i];
            sumXX += i * i;
        }

        var slope = (n * sumXY - sumX * sumY) / (n * sumXX - sumX * sumX);

        // 根据斜率判断趋势
        if (Math.abs(slope) < 0.2) return "stable";
        return slope > 0 ? "rising" : "falling";
    }

    // 更新分析数据
    function updateAnalysis() {
        analysis = {
            tempAvg: calculateAverage(tempData),
            tempMin: calculateMin(tempData),
            tempMax: calculateMax(tempData),
            tempTrend: calculateTrend(tempData),
            humidityAvg: calculateAverage(humidityData),
            humidityMin: calculateMin(humidityData),
            humidityMax: calculateMax(humidityData),
            humidityTrend: calculateTrend(humidityData)
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        // 数据分析卡片
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 70
            color: "#383838"
            radius: 8

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10

                // 温度分析
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "#2A2A2A"
                    radius: 5

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 5

                        Column {
                            Layout.preferredWidth: 60
                            spacing: 2

                            Text {
                                text: "🌡️ 温度"
                                color: "#AAAAAA"
                                font.pixelSize: 12
                            }

                            Text {
                                text: analysis.tempAvg + "°C"
                                color: "#BB86FC"
                                font.pixelSize: 16
                                font.bold: true
                            }

                            Row {
                                spacing: 2
                                Text {
                                    text: analysis.tempTrend === "rising" ? "↗" :
                                          analysis.tempTrend === "falling" ? "↘" : "→"
                                    color: analysis.tempTrend === "rising" ? "#4CAF50" :
                                           analysis.tempTrend === "falling" ? "#F44336" : "#AAAAAA"
                                    font.pixelSize: 10
                                    font.bold: true
                                }

                                Text {
                                    text: analysis.tempTrend === "rising" ? "上升" :
                                          analysis.tempTrend === "falling" ? "下降" : "稳定"
                                    color: analysis.tempTrend === "rising" ? "#4CAF50" :
                                           analysis.tempTrend === "falling" ? "#F44336" : "#AAAAAA"
                                    font.pixelSize: 10
                                }
                            }
                        }

                        Rectangle {
                            color: "#444"
                            width: 1
                            Layout.fillHeight: true
                            opacity: 0.5
                        }

                        Column {
                            Layout.fillWidth: true
                            spacing: 3

                            Row {
                                width: parent.width
                                spacing: 5

                                Text {
                                    text: "最低:"
                                    color: "#AAAAAA"
                                    font.pixelSize: 11
                                }

                                Text {
                                    text: analysis.tempMin + "°C"
                                    color: "#03DAC5"
                                    font.pixelSize: 11
                                    font.bold: true
                                }

                                Item { width: 15; height: 1 }

                                Text {
                                    text: "最高:"
                                    color: "#AAAAAA"
                                    font.pixelSize: 11
                                }

                                Text {
                                    text: analysis.tempMax + "°C"
                                    color: "#F44336"
                                    font.pixelSize: 11
                                    font.bold: true
                                }
                            }

                            ProgressBar {
                                width: parent.width
                                height: 8
                                from: Math.max(0, parseFloat(analysis.tempMin) - 2)
                                to: parseFloat(analysis.tempMax) + 2
                                value: parseFloat(analysis.tempAvg)
                                background: Rectangle {
                                    color: "#1E1E1E"
                                    radius: 2
                                }
                                contentItem: Rectangle {
                                    width: parent.visualPosition * parent.width
                                    height: parent.height
                                    radius: 2
                                    gradient: Gradient {
                                        GradientStop { position: 0.0; color: "#03DAC5" }
                                        GradientStop { position: 0.5; color: "#BB86FC" }
                                        GradientStop { position: 1.0; color: "#F44336" }
                                    }
                                }
                            }

                            Text {
                                text: "平均: " + analysis.tempAvg + "°C"
                                color: "#BBBBBB"
                                font.pixelSize: 10
                            }
                        }
                    }
                }

                // 湿度分析
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "#2A2A2A"
                    radius: 5

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 5

                        Column {
                            Layout.preferredWidth: 60
                            spacing: 2

                            Text {
                                text: "💧 湿度"
                                color: "#AAAAAA"
                                font.pixelSize: 12
                            }

                            Text {
                                text: analysis.humidityAvg + "%"
                                color: "#03DAC5"
                                font.pixelSize: 16
                                font.bold: true
                            }

                            Row {
                                spacing: 2
                                Text {
                                    text: analysis.humidityTrend === "rising" ? "↗" :
                                          analysis.humidityTrend === "falling" ? "↘" : "→"
                                    color: analysis.humidityTrend === "rising" ? "#4CAF50" :
                                           analysis.humidityTrend === "falling" ? "#F44336" : "#AAAAAA"
                                    font.pixelSize: 10
                                    font.bold: true
                                }

                                Text {
                                    text: analysis.humidityTrend === "rising" ? "上升" :
                                          analysis.humidityTrend === "falling" ? "下降" : "稳定"
                                    color: analysis.humidityTrend === "rising" ? "#4CAF50" :
                                           analysis.humidityTrend === "falling" ? "#F44336" : "#AAAAAA"
                                    font.pixelSize: 10
                                }
                            }
                        }

                        Rectangle {
                            color: "#444"
                            width: 1
                            Layout.fillHeight: true
                            opacity: 0.5
                        }

                        Column {
                            Layout.fillWidth: true
                            spacing: 3

                            Row {
                                width: parent.width
                                spacing: 5

                                Text {
                                    text: "最低:"
                                    color: "#AAAAAA"
                                    font.pixelSize: 11
                                }

                                Text {
                                    text: analysis.humidityMin + "%"
                                    color: "#03DAC5"
                                    font.pixelSize: 11
                                    font.bold: true
                                }

                                Item { width: 15; height: 1 }

                                Text {
                                    text: "最高:"
                                    color: "#AAAAAA"
                                    font.pixelSize: 11
                                }

                                Text {
                                    text: analysis.humidityMax + "%"
                                    color: "#F44336"
                                    font.pixelSize: 11
                                    font.bold: true
                                }
                            }

                            ProgressBar {
                                width: parent.width
                                height: 8
                                from: Math.max(0, parseFloat(analysis.humidityMin) - 2)
                                to: parseFloat(analysis.humidityMax) + 2
                                value: parseFloat(analysis.humidityAvg)
                                background: Rectangle {
                                    color: "#1E1E1E"
                                    radius: 2
                                }
                                contentItem: Rectangle {
                                    width: parent.visualPosition * parent.width
                                    height: parent.height
                                    radius: 2
                                    gradient: Gradient {
                                        GradientStop { position: 0.0; color: "#1E88E5" }
                                        GradientStop { position: 0.5; color: "#03DAC5" }
                                        GradientStop { position: 1.0; color: "#00E5FF" }
                                    }
                                }
                            }

                            Text {
                                text: "平均: " + analysis.humidityAvg + "%"
                                color: "#BBBBBB"
                                font.pixelSize: 10
                            }
                        }
                    }
                }
            }
        }

        // 使用QtCharts实现图表
        ChartView {
            id: chartView
            Layout.fillWidth: true
            Layout.fillHeight: true
            antialiasing: true
            backgroundColor: "#2A2A2A"
            legend.visible: false

            // 防止崩溃:移除默认边框和标题
            title: ""
            margins.top: 5
            margins.bottom: 5
            margins.left: 5
            margins.right: 5

            // 温度线
            SplineSeries {
                id: tempSeries
                name: "温度"
                axisX: axisTime
                axisY: axisTemp
                color: "#BB86FC"
                width: 2
                useOpenGL: true
            }

            // 湿度线
            SplineSeries {
                id: humSeries
                name: "湿度"
                axisX: axisTime
                axisYRight: axisHumidity
                color: "#03DAC5"
                width: 2
                useOpenGL: true
            }

            // 时间轴
            ValuesAxis {
                id: axisTime
                min: 0
                max: 1
                visible: false
            }

            // 温度轴
            ValuesAxis {
                id: axisTemp
                min: 0
                max: 50
                tickCount: 6
                labelFormat: "%.1f°C"
                gridLineColor: "#333333"
                labelsColor: "#BB86FC"
                labelsFont.pixelSize: 10
                shadesVisible: false
            }

            // 湿度轴 (右侧)
            ValuesAxis {
                id: axisHumidity
                min: 0
                max: 100
                tickCount: 6
                labelFormat: "%.1f%%"
                gridLineColor: "#333333"
                labelsColor: "#03DAC5"
                labelsFont.pixelSize: 10
                visible: true
                labelsVisible: true
                shadesVisible: false
            }
        }

        // 时间轴标签容器
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 20
            color: "transparent"

            Row {
                id: timeLabelsRow
                anchors.fill: parent
                anchors.leftMargin: 50
                anchors.rightMargin: 50

                // 动态生成时间标签
                Repeater {
                    model: root.timeLabels.length > 0 ? Math.min(6, root.timeLabels.length) : 0

                    delegate: Item {
                        property int index: modelData
                        property int step: Math.max(1, Math.floor(root.timeLabels.length / 6))
                        property int labelIndex: index * step < root.timeLabels.length ? index * step : root.timeLabels.length - 1

                        width: parent.width / (Math.min(6, root.timeLabels.length))
                        height: parent.height

                        Text {
                            anchors.centerIn: parent
                            text: root.timeLabels.length > 0 ? root.timeLabels[labelIndex] : ""
                            color: "#AAAAAA"
                            font.pixelSize: 10
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }
                }
            }
        }
    }

    // 更新图表数据
    function updateChart() {
        // 确保有有效数据
        if (tempData.length === 0 || humidityData.length === 0) {
            tempSeries.clear();
            humSeries.clear();
            return;
        }

        // 智能计算温度和湿度的显示范围
        var tempRange = calculateAxisRange(tempData, lastTempRange, true);
        var humRange = calculateAxisRange(humidityData, lastHumRange, false);

        // 更新轴范围
        axisTemp.min = tempRange.min;
        axisTemp.max = tempRange.max;
        axisHumidity.min = humRange.min;
        axisHumidity.max = humRange.max;

        // 保存当前范围，用于下次平滑过渡
        lastTempRange = tempRange;
        lastHumRange = humRange;

        // 清除旧数据
        tempSeries.clear();
        humSeries.clear();

        // 添加新数据点
        for (var i = 0; i < tempData.length; i++) {
            var x = i / (tempData.length - 1);
            tempSeries.append(x, tempData[i]);
        }

        for (var j = 0; j < humidityData.length; j++) {
            var x2 = j / (humidityData.length - 1);
            humSeries.append(x2, humidityData[j]);
        }

        // 更新X轴
        axisTime.min = 0;
        axisTime.max = 1;
    }

    // 监听数据变化
    onTempDataChanged: {
        updateAnalysis()
        updateChart()
    }
    onHumidityDataChanged: {
        updateAnalysis()
        updateChart()
    }
    onTimeLabelsChanged: updateChart()

    Component.onCompleted: {
        updateAnalysis();
        updateChart();
    }
}
