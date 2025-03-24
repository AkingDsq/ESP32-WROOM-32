pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls

//import callAi // 导入注册的模块


ApplicationWindow {
    id: mainWindow
    width: 618
    height: 1338
    visible: true
    color: Qt.rgba(47/255,36/255,36/255,1)

    //property alias callAI: callAI  // 若已注册到上下文，通过别名限定作用域

    title: qsTr("Hello World")
    // 监听屏幕旋转事件并调整布局：
    Screen.onPrimaryOrientationChanged: {
        if (Screen.primaryOrientation === Qt.LandscapeOrientation) {
            console.log("切换到横屏模式")
        } else {
            console.log("切换到竖屏模式")
        }
    }

    // 顶部区域
    Rectangle {
        id: topArea
        width: parent.width
        height: parent.height * 0.05
        anchors {
            top: parent.top
            bottom: parent.bottom * 0.15
            left: parent.left
            right: parent.right
        }
        color: Qt.rgba(29/255,77/255,211/255, 1)

        // 可以在这里添加与当前按钮索引关联的内容
        Text {
            width: parent.width
            height:parent.height
            anchors.centerIn: parent
            text: "智能家居"
            color: "white"
            font.pixelSize: height * 0.5
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        Rectangle{
            color: "red"
            width: parent.width * 0.2
            height: parent.height
            anchors{
                top: parent.top * 0.8
                bottom: parent.bottom
                left: parent.left * 0.8
                right: parent.right
            }

            Button{
                anchors.fill: parent
                text: "添加房间"
                onClicked: listModel.append({})  // 动态增加一项
            }
        }
    }

    // 轮播图区域
    // Rectangle {
    //     id: carouselContainer
    //     anchors {
    //         top: buttonCarousel.top
    //         bottom: buttonCarousel.bottom
    //         left: parent.left
    //         right: parent.right
    //     }
    //     radius: 5
    //     color: Qt.rgba(0.5,0.5,0.5, 1)

    //     // 可以在这里添加与当前按钮索引关联的内容
    //     Text {
    //         width: parent.width * 0.9
    //         height:parent.height * 0.5
    //         anchors {
    //             bottom: parent.top
    //         }
    //         text: "当前选中：按钮" + (buttonCarousel.currentIndex + 1)
    //         color: "white"
    //         font.pixelSize: height * 0.5
    //         horizontalAlignment: Text.AlignHCenter
    //         verticalAlignment: Text.AlignVCenter
    //     }
    // }

    // AI助手按钮
    Rectangle {
        id: aiCall
        width: parent.width * 0.15
        height: width
        radius: width/2
        x: parent.width/2 - width/2
        y: parent.height * 0.8
        color: Qt.rgba(65/255,167/255,166/255,1)
        // 点击的动画
        SequentialAnimation on scale {
            id: clickAiCall
            loops: 1
            NumberAnimation { to: 0.9; duration: 100 }
            NumberAnimation { to: 1.0; duration: 100 }
        }
        // 复位的动画
        NumberAnimation{
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

        Text {
            id: label
            //property var statusLabelRef: statusText  // 将子组件引用暴露为属性
            text: "YES"
            anchors.centerIn: parent
            color: "white"
            font { bold: true; pixelSize: 16 }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                clickAiCall.start();

            }
            onPressed: {
                //mainWindow.callAI.call();  // 通过根组件 id 限定访问
                pressAiCall.start();
                parent.color = Qt.darker("#2196F3", 1.2);
            }
            onReleased:{
                parent.color = Qt.rgba(65/255, 167/255, 166/255, 1)
                back.start();
            }
        }
    }

    // 侧边房间选择
    ListModel {
        id: listModel
        // 初始添加 5 个空项
        Component.onCompleted: {
            for (var i = 0; i < 3; i++) append({})
        }
    }
    ListView {
        id: roomsChoose
        width: parent.width * 0.1
        height: parent.height - topArea.height - bottomArea.height

        anchors {
            top: topArea.bottom
            bottom: bottomArea.bottom
            left: parent.left
            right: parent.right * 0.1
        }

        orientation: ListView.Vertical // orientation设置为纵向排列
        spacing: 30
        snapMode: ListView.SnapToItem // snapMode确保滑动停止时自动对齐项
        model: listModel
        clip: true  // 防止按钮超出ListView边界
        boundsBehavior: Flickable.StopAtBounds // boundsBehavior限制越界滚动
        flickDeceleration: 1500  // flickDeceleration控制滑动惯性

        onMovementEnded: {
            var centerPos = mapToItem(contentItem, width/2, height/2)
            currentIndex = indexAt(centerPos.x, centerPos.y)
            positionViewAtIndex(currentIndex, ListView.Center)
        }

        // 强制选中项居中
        highlightRangeMode: ListView.StrictlyEnforceRange
        preferredHighlightBegin: height/2 - 50  // 假设按钮高度100
        preferredHighlightEnd: height/2 + 50
        highlightMoveDuration: 200

        // 选中项高亮样式
        highlight: Rectangle {
            color: "transparent"
            border { width: 2; color: "blue" }
            radius: 8
        }

        // 动态响应选中变化
        onCurrentIndexChanged: {
            console.log("Selected index:", currentIndex)
            // 执行对应按钮逻辑
        }

        MouseArea {
            anchors.fill: parent
            drag.target: parent
            drag.axis: Drag.YAxis

            onReleased: {
                parent.y = 0  // 复位位置
                roomsChoose.currentIndex = roomsChoose.indexAt(width/2, parent.y + height/2)
            }
        }

        delegate: Button {
            required property int index
            text: "按钮" + (index + 1)

            // 根据与当前索引的距离动态调整大小和透明度
            width: parent.width
            height: ListView.isCurrentItem ? parent.height * 0.25 : parent.height * 0.18  // 固定高度
            opacity: 1 - Math.abs(y - roomsChoose.contentY - roomsChoose.height/2)/100
            anchors {
                top: parent.left * 0.05
                bottom: parent.right * 0.05
                left: parent.left
                right: parent.right
            }
            // 自定义背景颜色
            background: Rectangle {
                color: Qt.rgba(40/255, 1, 1, 1)  // 半透明黑色
                radius: 5  // 圆角
            }
            // 自动触发选中
            Component.onCompleted: {
                if(ListView.isCurrentItem) forceActiveFocus()
            }
        }
    }

    // 底部区域
    Rectangle {
        id: bottomArea
        width: parent.width
        height: parent.height * 0.05
        anchors {
            top: parent.top * 0.95
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        radius: 5
        color: Qt.rgba(29/255,77/255,211/255, 1)

        Rectangle{
            id: rooms
            width: parent.width/4.0
            height: parent.height
            color: Qt.rgba(50, 50, 50, 0.5)
            anchors{
                top: parent.top
                bottom: parent.bottom
                left: parent.left
                right: parent.right * 0.25
            }
            Text{
                width: parent.width
                height: parent.height
                anchors.fill: parent
                color: "white"
                font.pixelSize: height * 0.5
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: "房间"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    parent.color = Qt.darker("#2196F3", 1.2);
                }
            }
        }

        Rectangle{
            id: no
            width: parent.width/4.0
            height: parent.height
            color: Qt.rgba(50, 50, 50, 0.5)
            anchors{
                top: parent.top
                bottom: parent.bottom
                left: rooms.right
                right: parent.right * 0.5
            }
            Text{
                width: parent.width
                height: parent.height
                anchors.fill: parent
                color: "white"
                font.pixelSize: height * 0.5
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: "no"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    parent.color = Qt.darker("#2196F3", 1.2);
                }
            }
        }
        Rectangle{
            id: safety
            width: parent.width/4.0
            height: parent.height
            color: Qt.rgba(50, 50, 50, 0.5)
            anchors{
                top: parent.top
                bottom: parent.bottom
                left: parent.right * 0.5
                right: personalCenter.left
            }
            Text{
                width: parent.width
                height: parent.height
                anchors.fill: parent
                color: "white"
                font.pixelSize: height * 0.5
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: "安保"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    parent.color = Qt.darker("#2196F3", 1.2);
                }
            }
        }
        Rectangle{
            id: personalCenter
            width: parent.width/4.0
            height: parent.height
            color: Qt.rgba(50, 50, 50, 0.5)
            anchors{
                top: parent.top
                bottom: parent.bottom
                left: parent.right * 0.75
                right: parent.right
            }
            Text{
                width: parent.width
                height: parent.height
                anchors.fill: parent
                color: "white"
                font.pixelSize: height * 0.5
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: "个人"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    parent.color = Qt.darker("#2196F3", 1.2);
                }
            }
        }
    }

    // 轮播按钮
    // ListView {
    //     id: buttonCarousel
    //     anchors {
    //         bottom: parent.bottom
    //         left: parent.left
    //         right: parent.right
    //     }
    //     width: parent.width
    //     height: 60
    //     orientation: ListView.Horizontal
    //     spacing: 10
    //     snapMode: ListView.SnapToItem
    //     model: 5
    //     clip: true  // 防止按钮超出ListView边界

    //     delegate: Button {

        //     required property int index
        //     text: "按钮" + (index + 1)

        //     // 根据与当前索引的距离动态调整大小和透明度
        //     width: buttonCarousel.currentIndex === index ? parent.width * 0.25 : parent.width * 0.18  // 当前项更大
        //     height: buttonCarousel.currentIndex === index ? parent.height * 1.2 : parent.height
        //     opacity: 1.0 - Math.min(0.6, Math.abs(buttonCarousel.currentIndex - index) * 0.2)

        //     background: Rectangle {
        //         color: buttonCarousel.currentIndex === index ? "#3498db" : "lightblue"
        //         radius: 8

        //         // 添加平滑动画
        //         Behavior on color {
        //             ColorAnimation { duration: 200 }
        //         }
        //     }

        //     onClicked: {
        //         parent.currentIndex = index
        //     }

        //     // 添加大小变化的动画
        //     Behavior on width {
        //         NumberAnimation {
        //             duration: 200
        //             easing.type: Easing.OutQuad
        //         }
        //     }

        //     Behavior on height {
        //         NumberAnimation {
        //             duration: 200
        //             easing.type: Easing.OutQuad
        //         }
        //     }

        //     Behavior on opacity {
        //         NumberAnimation {
        //             duration: 200
        //             easing.type: Easing.OutQuad
        //         }
        //     }
        //}

    //     // 确保当前项位于中心
    //     preferredHighlightBegin: width / 2 - 60
    //     preferredHighlightEnd: width / 2 + 60
    //     highlightRangeMode: ListView.StrictlyEnforceRange
    //     highlightMoveDuration: 300

    //     // 使用动画来平滑地过渡currentIndex的变化
    //     Behavior on currentIndex {
    //         NumberAnimation {
    //             duration: 300
    //             easing.type: Easing.OutCubic  // 使用OutCubic提供更自然的减速效果
    //         }
    //     }
    // }

    // Timer {
    //     id: autoScrollTimer
    //     interval: 3000
    //     running: true
    //     repeat: true
    //     onTriggered: {
    //         if (buttonCarousel.count === 0) return;
    //         buttonCarousel.currentIndex = (buttonCarousel.currentIndex + 1) % buttonCarousel.count;
    //     }
    // }

    // // 添加触摸滑动手势（使用者可以左右滑动切换）
    // MouseArea {
    //     property int startX: 0
    //     property bool swiping: false

    //     anchors.fill: carouselContainer

    //     onPressed: (mouse) =>{
    //         startX = mouse.x
    //         swiping = true
    //     }

    //     onReleased: (mouse) => {
    //         if (swiping) {
    //             var delta = mouse.x - startX
    //             if (Math.abs(delta) > width * 0.1) { // 滑动超过10%宽度才触发
    //                 if (delta > 0) {
    //                     // 向右滑，上一个
    //                     if (buttonCarousel.currentIndex > 0) {
    //                         buttonCarousel.currentIndex -= 1
    //                     } else {
    //                         buttonCarousel.currentIndex = buttonCarousel.count - 1
    //                     }
    //                 } else {
    //                     // 向左滑，下一个
    //                     buttonCarousel.currentIndex = (buttonCarousel.currentIndex + 1) % buttonCarousel.count
    //                 }
    //             }
    //             swiping = false
    //         }
    //     }
    //}
}
