pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls

import Call_AI 1.0 // 导入注册的模块


ApplicationWindow {
    width: 480
    height: 640
    visible: true
    color: Qt.rgba(47,79,79)

    title: qsTr("Hello World")
    // 监听屏幕旋转事件并调整布局：
    Screen.onPrimaryOrientationChanged: {
        if (Screen.primaryOrientation === Qt.LandscapeOrientation) {
            console.log("切换到横屏模式")
        } else {
            console.log("切换到竖屏模式")
        }
    }

    Text {
        text: "Hello, World!"
        font.family: "Helvetica"
        font.pixelSize: parent.width * 0.05
        font.bold: true
        color: "white"
        x: parent.width / 2 - width / 2  // 水平中心 = 父宽/2 - 文本自身宽度/2
        y: parent.height * 0.1
    }

    // 轮播图区域
    Rectangle {
        id: carouselContainer
        anchors {
            top: buttonCarousel.top
            bottom: buttonCarousel.bottom
            left: parent.left
            right: parent.right
            margins: 10
        }
        color: "blue"

        // 可以在这里添加与当前按钮索引关联的内容
        Text {
            width: parent.width * 0.9
            height:parent.height * 0.5
            anchors {
                bottom: parent.top
            }
            text: "当前选中：按钮" + (buttonCarousel.currentIndex + 1)
            color: "white"
            font.pixelSize: height * 0.5
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    // AI助手按钮
    // 创建 Call_AI 实例
    Call_AI {
        id: callAI
    }
    Rectangle {
        id: aiCall
        radius: width/2
        anchors {
            top: parent.top * 0.1
            bottom: parent.bottom
            left: parent.left/4
            right: parent.right/4
         }
        color: "red"

        // SequentialAnimation on scale {
        //     id: clickAnim
        //     loops: 1
        //     NumberAnimation { to: 0.9; duration: 100 }
        //     NumberAnimation { to: 1.0; duration: 100 }
        // }

        // Text {
        //     id: label
        //     anchors.centerIn: parent
        //     color: "white"
        //     font { bold: true; pixelSize: 16 }
        // }

        // MouseArea {
        //     anchors.fill: parent
        //     onClicked: {
        //         clickAnim.start();
        //         //call_AI.call();
        //     }
        //     onPressed: parent.color = Qt.darker("#2196F3", 1.2)
        //     onReleased: parent.color = "#2196F3"
        // }
    }

    // 轮播按钮
    ListView {
        id: buttonCarousel
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        width: parent.width
        height: 60
        orientation: ListView.Horizontal
        spacing: 10
        snapMode: ListView.SnapToItem
        model: 5
        clip: true  // 防止按钮超出ListView边界

        // delegate: Button {

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
        // }

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
    }
}
