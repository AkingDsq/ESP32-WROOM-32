import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.LocalStorage 2.15

Rectangle {
    id: root
    width: 640
    height: 480

    property var db

    // 数据库处理函数
    function getDatabase() {
        return LocalStorage.openDatabaseSync("RoomApp", "1.0", "Room Storage", 1000000);
    }

    // 初始化数据库
    function initDatabase() {
        db = getDatabase();
        db.transaction(function(tx) {
            // 创建房间表
            tx.executeSql('CREATE TABLE IF NOT EXISTS Rooms(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)');
        });
    }

    // 加载所有房间
    function loadRooms() {
        db = getDatabase();
        roomListModel.clear();

        db.transaction(function(tx) {
            var results = tx.executeSql('SELECT * FROM Rooms ORDER BY id');

            // 如果没有房间，创建默认房间
            if (results.rows.length === 0) {
                tx.executeSql('INSERT INTO Rooms (name) VALUES (?)', ["Living Room"]);
                tx.executeSql('INSERT INTO Rooms (name) VALUES (?)', ["Bedroom"]);
                loadRooms(); // 重新加载
                return;
            }

            // 添加房间到模型
            for (var i = 0; i < results.rows.length; i++) {
                roomListModel.append({
                    id: results.rows.item(i).id,
                    name: results.rows.item(i).name
                });
            }
        });
    }

    // 添加房间
    function addRoom(name) {
        db = getDatabase();
        db.transaction(function(tx) {
            tx.executeSql('INSERT INTO Rooms (name) VALUES (?)', [name]);
        });
        loadRooms(); // 重新加载列表
    }

    // 删除房间
    function removeRoom(id) {
        db = getDatabase();
        db.transaction(function(tx) {
            tx.executeSql('DELETE FROM Rooms WHERE id = ?', [id]);
        });
        loadRooms(); // 重新加载列表
    }

    // 初始化数据库和加载房间
    Component.onCompleted: {
        initDatabase();
        loadRooms();
    }

    // 房间列表模型
    ListModel {
        id: roomListModel
    }

    // 房间滚轮选择器
    ListView {
        id: roomsChoose
        width: parent.width * 0.25
        height: parent.height - 120
        anchors {
            top: parent.top
            topMargin: 60
            left: parent.left
            leftMargin: 20
        }

        model: roomListModel
        orientation: ListView.Vertical
        spacing: 10
        snapMode: ListView.SnapToItem
        clip: true

        preferredHighlightBegin: height/2 - 30
        preferredHighlightEnd: height/2 + 30
        highlightRangeMode: ListView.StrictlyEnforceRange
        highlightMoveDuration: 200

        delegate: Button {
            required property int index
            required property var model

            width: parent.width - 20
            height: 60

            text: model.name

            contentItem: Text {
                text: parent.text
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            background: Rectangle {
                color: "#333333"
                radius: 8
            }

            // 添加删除按钮
            Button {
                anchors {
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                    rightMargin: 5
                }
                width: 30
                height: 30
                text: "✕"

                onClicked: {
                    removeRoom(model.id)
                }
            }
        }
    }

    // 添加新房间按钮
    Button {
        anchors {
            bottom: parent.bottom
            bottomMargin: 20
            left: parent.left
            leftMargin: 20
        }
        width: roomsChoose.width
        height: 50
        text: "添加房间"

        onClicked: {
            addRoomDialog.open()
        }
    }

    // 添加房间对话框
    Dialog {
        id: addRoomDialog
        title: "添加新房间"
        standardButtons: Dialog.Ok | Dialog.Cancel
        modal: true
        anchors.centerIn: parent

        onAccepted: {
            if (roomNameField.text.trim() !== "") {
                addRoom(roomNameField.text.trim());
                roomNameField.text = "";
            }
        }

        onRejected: {
            roomNameField.text = "";
        }

        TextField {
            id: roomNameField
            placeholderText: "输入房间名称"
            width: parent.width
        }
    }
}
