import QtQuick

Rectangle {
    id: cancel_callai
    color: Qt.rgba(46/255, 38/255, 38/255, 0.85)
    signal buttonClicked()
    z : 100
    MouseArea {
        anchors.fill: parent
        onClicked: {
            cancel_callai.buttonClicked()
        }
    }
}
