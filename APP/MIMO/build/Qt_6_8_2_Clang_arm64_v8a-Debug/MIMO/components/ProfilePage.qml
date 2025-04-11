import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
// 页面4 - 个人中心页面
Page {
    id: profilePage
    background: Rectangle { color: "transparent" }

    Rectangle {
        width: parent.width * 0.9
        height: parent.height * 0.9
        anchors.centerIn: parent
        color: "#1E1E1E"
        radius: 15

        Column {
            anchors.centerIn: parent
            spacing: 25
            width: parent.width * 0.8

            // 用户头像
            Rectangle {
                width: 120
                height: 120
                radius: 60
                anchors.horizontalCenter: parent.horizontalCenter
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#7B2BFF" }
                    GradientStop { position: 1.0; color: "#BB86FC" }
                }

                Text {
                    anchors.centerIn: parent
                    text: username.charAt(0).toUpperCase()
                    color: "white"
                    font.pixelSize: 60
                    font.bold: true
                }
            }

            // 用户名
            Text {
                text: username
                color: "white"
                font.pixelSize: 24
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
            }

            // 登录时间
            Text {
                text: "登录时间: " + currentDateTime
                color: "#AAAAAA"
                font.pixelSize: 14
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Rectangle {
                width: parent.width
                height: 1
                color: "#333333"
            }

            // 设置项
            Column {
                width: parent.width
                spacing: 15

                Repeater {
                    model: [
                        { name: "个人信息", icon: "👤" },
                        { name: "通知设置", icon: "🔔" },
                        { name: "隐私设置", icon: "🔒" },
                        { name: "帮助中心", icon: "❓" }
                    ]

                    Rectangle {
                        width: parent.width
                        height: 60
                        radius: 8
                        color: "#2A2A2A"

                        Row {
                            anchors.fill: parent
                            anchors.margins: 10
                            spacing: 15

                            Text {
                                text: modelData.icon
                                font.pixelSize: 24
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Text {
                                text: modelData.name
                                color: "white"
                                font.pixelSize: 16
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Item { width: parent.width - 100; height: 1 }

                            Text {
                                text: ">"
                                color: "#AAAAAA"
                                font.pixelSize: 18
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onPressed: parent.scale = 0.98
                            onReleased: parent.scale = 1.0
                        }

                        Behavior on scale {
                            NumberAnimation { duration: 100 }
                        }
                    }
                }
            }

            // 退出登录按钮
            Rectangle {
                width: parent.width * 0.7
                height: 56
                radius: 28
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#E53935"

                Text {
                    anchors.centerIn: parent
                    text: "退出登录"
                    color: "white"
                    font.pixelSize: 16
                    font.bold: true
                }

                MouseArea {
                    anchors.fill: parent
                    onPressed: parent.scale = 0.95
                    onReleased: parent.scale = 1.0
                    onClicked: homePage.logout()
                }

                Behavior on scale {
                    NumberAnimation { duration: 100 }
                }
            }
        }
    }
}
