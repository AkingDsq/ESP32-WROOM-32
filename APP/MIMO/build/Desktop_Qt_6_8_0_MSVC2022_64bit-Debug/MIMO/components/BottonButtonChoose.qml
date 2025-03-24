import QtQuick

Rectangle{
    id: bottonButton
    // 定义可外部修改的属性
    property string btnText: "按钮"  // 文字内容[1](@ref)
    property color btnColor: "lightblue"  // 背景色
    signal buttonClicked()  // 点击信号[3](@ref)

    width: parent.width/4.0
    height: parent.height
    color: Qt.rgba(50, 50, 50, 0.5)
    anchors{
        top: parent.top
        bottom: parent.bottom
    }
    Text{
        width: parent.width
        height: parent.height
        anchors.fill: parent
        color: "white"
        font.pixelSize: height * 0.25
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: bottonButton.btnText
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            bottonButton.buttonClicked()
        }
        onPressed: {
            parent.color = Qt.darker("#2196F3", 1.2);
        }
        onReleased:{
            parent.color = Qt.rgba(50, 50, 50, 0.5)
        }
    }
}
