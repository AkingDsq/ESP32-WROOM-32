import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    visible: true
    width: 360
    height: 640
    title: "数据库操作演示"

    property int selectedUserId: -1

    Component.onCompleted: {
        refreshUsers()
    }

    function refreshUsers() {
        var users = dbManager.getAllUsers()
        listModel.clear()
        for (var i = 0; i < users.length; i++) {
            listModel.append(users[i])
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        GroupBox {
            title: "添加/编辑用户"
            Layout.fillWidth: true

            GridLayout {
                columns: 2
                anchors.fill: parent

                Label { text: "姓名:" }
                TextField {
                    id: nameField
                    Layout.fillWidth: true
                    placeholderText: "输入姓名"
                }

                Label { text: "年龄:" }
                SpinBox {
                    id: ageField
                    Layout.fillWidth: true
                    from: 1
                    to: 120
                    value: 18
                }

                Label { text: "邮箱:" }
                TextField {
                    id: emailField
                    Layout.fillWidth: true
                    placeholderText: "输入邮箱"
                }

                RowLayout {
                    Layout.columnSpan: 2
                    Layout.fillWidth: true
                    Layout.topMargin: 10

                    Button {
                        text: selectedUserId === -1 ? "添加" : "更新"
                        Layout.fillWidth: true
                        onClicked: {
                            if (selectedUserId === -1) {
                                dbManager.addUser(nameField.text, ageField.value, emailField.text)
                            } else {
                                dbManager.updateUser(selectedUserId, nameField.text, ageField.value, emailField.text)
                            }
                            refreshUsers()
                            nameField.text = ""
                            ageField.value = 18
                            emailField.text = ""
                            selectedUserId = -1
                        }
                    }

                    Button {
                        text: "取消"
                        Layout.fillWidth: true
                        enabled: selectedUserId !== -1
                        onClicked: {
                            nameField.text = ""
                            ageField.value = 18
                            emailField.text = ""
                            selectedUserId = -1
                        }
                    }
                }
            }
        }

        TextField {
            id: searchField
            Layout.fillWidth: true
            placeholderText: "搜索用户..."
            onTextChanged: {
                if (text.length > 0) {
                    var results = dbManager.searchUsers(text)
                    listModel.clear()
                    for (var i = 0; i < results.length; i++) {
                        listModel.append(results[i])
                    }
                } else {
                    refreshUsers()
                }
            }
        }

        ListView {
            id: userListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            model: ListModel {
                id: listModel
            }

            delegate: SwipeDelegate {
                width: userListView.width
                contentItem: Column {
                    padding: 10
                    spacing: 5

                    Text {
                        text: "<b>姓名:</b> " + name
                        width: parent.width
                    }
                    Text {
                        text: "<b>年龄:</b> " + age
                        width: parent.width
                    }
                    Text {
                        text: "<b>邮箱:</b> " + email
                        width: parent.width
                    }
                }

                swipe.right: Row {
                    anchors.right: parent.right
                    height: parent.height

                    Button {
                        text: "编辑"
                        height: parent.height
                        onClicked: {
                            nameField.text = name
                            ageField.value = age
                            emailField.text = email
                            selectedUserId = id
                            swipe.close()
                        }
                    }

                    Button {
                        text: "删除"
                        height: parent.height
                        onClicked: {
                            dbManager.deleteUser(id)
                            refreshUsers()
                            swipe.close()
                        }
                    }
                }
            }
        }
    }
}
