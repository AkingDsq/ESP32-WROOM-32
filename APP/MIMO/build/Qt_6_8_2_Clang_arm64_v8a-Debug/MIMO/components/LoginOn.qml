import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material

Item {
    id: rootItem
    width: parent.width
    height: parent.height

    // 准备登入注册信号
    signal logining()
    signal registering()
    // 信号声明 - 用于登录成功后通知
    signal loginSuccess()
    signal registerSuccess()


    // 使用Material主题并自定义颜色
    Material.theme: Material.Dark
    Material.accent: Material.Purple
    Material.primary: Material.DeepPurple

    // 登录注册容器
    Rectangle {
        id: background
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#121212" }
            GradientStop { position: 1.0; color: "#1E1E1E" }
        }

        // 使用Canvas代替ShaderEffect
        Canvas {
            id: particleCanvas
            anchors.fill: parent
            property var particles: []
            property int particleCount: 40
            property point touchPoint: Qt.point(-100, -100)
            property bool touching: false

            Component.onCompleted: {
                // 创建粒子
                for (var i = 0; i < particleCount; i++) {
                    particles.push({
                        x: Math.random() * width,
                        y: Math.random() * height,
                        size: Math.random() * 4 + 1,
                        opacity: Math.random() * 0.3 + 0.1,
                        speed: Math.random() * 0.5 + 0.2,
                        angle: Math.random() * Math.PI * 2
                    });
                }
                animationTimer.start();
            }

            Timer {
                id: animationTimer
                interval: 30
                repeat: true
                running: true
                onTriggered: {
                    for (var i = 0; i < particleCanvas.particles.length; i++) {
                        var p = particleCanvas.particles[i];

                        // 更新粒子位置
                        p.x += Math.cos(p.angle) * p.speed;
                        p.y += Math.sin(p.angle) * p.speed;

                        // 触摸影响
                        if (particleCanvas.touching) {
                            var dx = particleCanvas.touchPoint.x - p.x;
                            var dy = particleCanvas.touchPoint.y - p.y;
                            var dist = Math.sqrt(dx * dx + dy * dy);

                            if (dist < 80) {
                                p.x += dx * 0.02;
                                p.y += dy * 0.02;
                            }
                        }

                        // 边界检查
                        if (p.x < 0) p.x = particleCanvas.width;
                        if (p.x > particleCanvas.width) p.x = 0;
                        if (p.y < 0) p.y = particleCanvas.height;
                        if (p.y > particleCanvas.height) p.y = 0;
                    }
                    particleCanvas.requestPaint();
                }
            }

            onPaint: {
                var ctx = getContext("2d");
                ctx.clearRect(0, 0, width, height);

                for (var i = 0; i < particles.length; i++) {
                    var p = particles[i];
                    ctx.beginPath();
                    ctx.fillStyle = Qt.rgba(0.6, 0.4, 1.0, p.opacity);
                    ctx.arc(p.x, p.y, p.size, 0, Math.PI * 2);
                    ctx.fill();
                }

                // 绘制触摸波纹效果
                if (touching) {
                    ctx.beginPath();
                    var gradient = ctx.createRadialGradient(
                        touchPoint.x, touchPoint.y, 0,
                        touchPoint.x, touchPoint.y, 80);
                    gradient.addColorStop(0, Qt.rgba(0.6, 0.4, 1.0, 0.2));
                    gradient.addColorStop(1, Qt.rgba(0.6, 0.4, 1.0, 0));
                    ctx.fillStyle = gradient;
                    ctx.arc(touchPoint.x, touchPoint.y, 80, 0, Math.PI * 2);
                    ctx.fill();
                }
            }

            MouseArea {
                anchors.fill: parent
                onPressed: {
                    parent.touchPoint = Qt.point(mouseX, mouseY);
                    parent.touching = true;
                }
                onPositionChanged: {
                    parent.touchPoint = Qt.point(mouseX, mouseY);
                }
                onReleased: {
                    parent.touching = false;
                }
            }
        }
    }

    // 创建主布局容器 - 使用Column替代ColumnLayout以更好地控制大小
    Item {
        anchors.fill: parent

        // Logo区域
        Item {
            id: logoArea
            anchors.top: parent.top
            anchors.topMargin: parent.height * 0.05
            anchors.horizontalCenter: parent.horizontalCenter
            width: Math.min(parent.width * 0.35, 120)
            height: width

            // 旋转的Logo外框
            Rectangle {
                id: logoBackground
                anchors.centerIn: parent
                width: parent.width
                height: width
                radius: width / 2
                color: "transparent"
                border.width: 2
                border.color: "#BB86FC"
                opacity: 0.7

                RotationAnimation {
                    target: logoBackground
                    property: "rotation"
                    from: 0
                    to: 360
                    duration: 15000
                    loops: Animation.Infinite
                    running: true
                }

                SequentialAnimation {
                    running: true
                    loops: Animation.Infinite

                    ParallelAnimation {
                        NumberAnimation {
                            target: logoBackground
                            property: "scale"
                            from: 1.0
                            to: 1.15
                            duration: 1500
                            easing.type: Easing.InOutQuad
                        }
                        NumberAnimation {
                            target: logoBackground
                            property: "opacity"
                            from: 0.7
                            to: 0.4
                            duration: 1500
                            easing.type: Easing.InOutQuad
                        }
                    }

                    ParallelAnimation {
                        NumberAnimation {
                            target: logoBackground
                            property: "scale"
                            from: 1.15
                            to: 1.0
                            duration: 1500
                            easing.type: Easing.InOutQuad
                        }
                        NumberAnimation {
                            target: logoBackground
                            property: "opacity"
                            from: 0.4
                            to: 0.7
                            duration: 1500
                            easing.type: Easing.InOutQuad
                        }
                    }
                }
            }

            // Logo中心
            Rectangle {
                anchors.centerIn: parent
                width: parent.width * 0.85
                height: width
                radius: width / 2
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#7B2BFF" }
                    GradientStop { position: 1.0; color: "#BB86FC" }
                }

                // Logo文字 - 使用当前用户的首字母
                Text {
                    anchors.centerIn: parent
                    text: "A"  // 使用AkingDsq的首字母
                    color: "white"
                    font.pixelSize: parent.width * 0.5
                    font.bold: true
                }
            }
        }

        Item { Layout.fillHeight: true; Layout.preferredHeight: 20 }

        // 应用名称
        Text {
            id: appNameText
            anchors.top: logoArea.bottom
            anchors.topMargin: 5
            anchors.horizontalCenter: parent.horizontalCenter
            text: "AkingDsq" // 使用当前用户名
            color: "white"
            font.pixelSize: 24
            font.bold: true
        }

        Item { Layout.fillHeight: true; Layout.preferredHeight: 10 }

        // 主内容区域 - 登录/注册表单
        SwipeView {
            id: swipeView
            anchors.top: appNameText.bottom
            anchors.topMargin: 15
            anchors.bottom: fingerprintArea.top
            anchors.bottomMargin: 5
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 30
            anchors.rightMargin: 30
            currentIndex: tabBar.currentIndex
            interactive: true
            clip: true

            // 登录页
            Item {
                id: loginPage

                ColumnLayout {
                    anchors.fill: parent
                    anchors.topMargin: 5
                    spacing: 15

                    // 欢迎回来文字
                    Label {
                        text: qsTr("欢迎回来")
                        font.pixelSize: 22
                        font.bold: true
                        color: "white"
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Item { Layout.fillHeight: true; Layout.preferredHeight: 10 }

                    // 用户名/手机号
                    MobileTextField {
                        id: usernameField
                        placeholderText: qsTr("用户名/手机号")
                        Layout.fillWidth: true
                        Layout.preferredHeight: 50
                        leftPadding: 45
                        text: "AkingDsq" // 预填充当前用户名

                        Rectangle {
                            width: 30
                            height: 30
                            radius: 15
                            anchors.left: parent.left
                            anchors.leftMargin: 10
                            anchors.verticalCenter: parent.verticalCenter
                            color: "transparent"

                            Text {
                                anchors.centerIn: parent
                                text: "👤"
                                font.pixelSize: 18
                                color: "#9E9E9E"
                            }
                        }
                    }

                    // 密码
                    MobileTextField {
                        id: passwordField
                        placeholderText: qsTr("密码")
                        echoMode: TextInput.Password
                        Layout.fillWidth: true
                        Layout.preferredHeight: 50
                        leftPadding: 45

                        Rectangle {
                            width: 30
                            height: 30
                            radius: 15
                            anchors.left: parent.left
                            anchors.leftMargin: 10
                            anchors.verticalCenter: parent.verticalCenter
                            color: "transparent"

                            Text {
                                anchors.centerIn: parent
                                text: "🔒"
                                font.pixelSize: 18
                                color: "#9E9E9E"
                            }
                        }

                        // 显示/隐藏密码按钮
                        Rectangle {
                            width: 30
                            height: 30
                            radius: 15
                            anchors.right: parent.right
                            anchors.rightMargin: 10
                            anchors.verticalCenter: parent.verticalCenter
                            color: "transparent"

                            Text {
                                anchors.centerIn: parent
                                text: passwordField.echoMode === TextInput.Password ? "👁️" : "👁️‍🗨️"
                                font.pixelSize: 18
                                color: "#9E9E9E"
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    passwordField.echoMode = passwordField.echoMode === TextInput.Password ? TextInput.Normal : TextInput.Password
                                }
                            }
                        }
                    }

                    // 记住密码和忘记密码
                    RowLayout {
                        Layout.fillWidth: true
                        Layout.topMargin: 0

                        Switch {
                            id: rememberSwitch
                            text: qsTr("记住密码")
                            checked: true
                            font.pixelSize: 13
                        }

                        Item { Layout.fillWidth: true }

                        Label {
                            text: qsTr("忘记密码?")
                            color: Material.accent
                            font.pixelSize: 13

                            MouseArea {
                                anchors.fill: parent
                                anchors.margins: -5
                                onClicked: console.log("忘记密码")
                            }
                        }
                    }

                    Item { Layout.fillHeight: true; Layout.preferredHeight: 10 }

                    // 登录按钮
                    MobileButton {
                        id: loginButton
                        text: qsTr("登 录")
                        Layout.fillWidth: true
                        Layout.preferredHeight: 50
                        onClicked: {
                            // 点击检测登入
                            rootItem.logining()
                        }
                    }

                    // 快捷登录选项
                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: 120

                        Column {
                            anchors.fill: parent
                            spacing: 10

                            Label {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: qsTr("—— 快捷登录 ——")
                                color: "#9E9E9E"
                                font.pixelSize: 14
                            }

                            Row {
                                anchors.horizontalCenter: parent.horizontalCenter
                                spacing: 30

                                Repeater {
                                    model: [
                                        { name: "微信", emoji: "📱", color: "#07C160" },
                                        { name: "支付宝", emoji: "💰", color: "#1677FF" },
                                        { name: "微博", emoji: "📚", color: "#E6162D" }
                                    ]

                                    delegate: Item {
                                        width: 50
                                        height: 50

                                        Rectangle {
                                            anchors.fill: parent
                                            radius: width / 2
                                            color: "transparent"
                                            border.width: 1.5
                                            border.color: modelData.color

                                            Text {
                                                anchors.centerIn: parent
                                                text: modelData.emoji
                                                font.pixelSize: 22
                                            }

                                            MouseArea {
                                                anchors.fill: parent
                                                onPressed: parent.scale = 0.9
                                                onReleased: parent.scale = 1.0
                                                onClicked: {
                                                    console.log(modelData.name + "登录")
                                                    quickLoginAnim.start()
                                                }
                                            }

                                            Behavior on scale {
                                                NumberAnimation { duration: 100 }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                // 登录成功动画
                SequentialAnimation {
                    id: loginSuccessAnim

                    ParallelAnimation {
                        NumberAnimation {
                            target: usernameField
                            property: "scale"
                            from: 1.0
                            to: 0.95
                            duration: 150
                        }
                        NumberAnimation {
                            target: passwordField
                            property: "scale"
                            from: 1.0
                            to: 0.95
                            duration: 150
                        }
                    }

                    NumberAnimation {
                        target: loginPage
                        property: "opacity"
                        from: 1.0
                        to: 0.7
                        duration: 200
                    }

                    NumberAnimation {
                        target: loginPage
                        property: "opacity"
                        from: 0.7
                        to: 1.0
                        duration: 400
                        easing.type: Easing.OutBack
                    }

                    ParallelAnimation {
                        NumberAnimation {
                            target: usernameField
                            property: "scale"
                            from: 0.95
                            to: 1.0
                            duration: 300
                            easing.type: Easing.OutBack
                        }
                        NumberAnimation {
                            target: passwordField
                            property: "scale"
                            from: 0.95
                            to: 1.0
                            duration: 300
                            easing.type: Easing.OutBack
                        }
                    }

                    ScriptAction {
                        script: {
                            console.log("登录成功！")
                            rootItem.loginSuccess()
                        }
                    }
                }

                // 快捷登录成功动画
                SequentialAnimation {
                    id: quickLoginAnim

                    NumberAnimation {
                        target: loginPage
                        property: "opacity"
                        from: 1.0
                        to: 0.7
                        duration: 200
                    }

                    NumberAnimation {
                        target: loginPage
                        property: "opacity"
                        from: 0.7
                        to: 1.0
                        duration: 300
                    }

                    ScriptAction {
                        script: {
                            console.log("快捷登录成功！")
                            rootItem.loginSuccess()
                        }
                    }
                }
            }

            // 注册页面
            Item {
                id: registerPage

                ColumnLayout {
                    anchors.fill: parent
                    anchors.topMargin: 5
                    spacing: 15

                    // 标题
                    Label {
                        text: qsTr("注册新账号")
                        font.pixelSize: 22
                        font.bold: true
                        color: "white"
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Item { Layout.fillHeight: true; Layout.preferredHeight: 10 }

                    // 手机号
                    MobileTextField {
                        id: phoneField
                        placeholderText: qsTr("手机号")
                        Layout.fillWidth: true
                        Layout.preferredHeight: 50
                        leftPadding: 45
                        inputMethodHints: Qt.ImhDigitsOnly

                        Rectangle {
                            width: 30
                            height: 30
                            radius: 15
                            anchors.left: parent.left
                            anchors.leftMargin: 10
                            anchors.verticalCenter: parent.verticalCenter
                            color: "transparent"

                            Text {
                                anchors.centerIn: parent
                                text: "📱"
                                font.pixelSize: 18
                                color: "#9E9E9E"
                            }
                        }
                    }

                    // 验证码
                    MobileTextField {
                        id: verificationField
                        placeholderText: qsTr("验证码")
                        Layout.fillWidth: true
                        Layout.preferredHeight: 50
                        leftPadding: 45
                        inputMethodHints: Qt.ImhDigitsOnly

                        Rectangle {
                            width: 30
                            height: 30
                            radius: 15
                            anchors.left: parent.left
                            anchors.leftMargin: 10
                            anchors.verticalCenter: parent.verticalCenter
                            color: "transparent"

                            Text {
                                anchors.centerIn: parent
                                text: "🔢"
                                font.pixelSize: 18
                                color: "#9E9E9E"
                            }
                        }

                        // 获取验证码按钮
                        Rectangle {
                            anchors.right: parent.right
                            anchors.rightMargin: 5
                            anchors.verticalCenter: parent.verticalCenter
                            width: codeText.width + 24
                            height: parent.height - 16
                            radius: 6
                            color: "#3D3D3D"

                            property int countdown: 60

                            Text {
                                id: codeText
                                anchors.centerIn: parent
                                text: parent.countdown < 60 ? qsTr("重新获取(%1)").arg(parent.countdown) : qsTr("获取验证码")
                                color: parent.countdown < 60 ? "#9E9E9E" : Material.accent
                                font.pixelSize: 13
                            }

                            Timer {
                                id: countdownTimer
                                interval: 1000
                                repeat: true
                                onTriggered: {
                                    parent.countdown--;
                                    if (parent.countdown <= 0) {
                                        stop();
                                        parent.countdown = 60;
                                    }
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    if (parent.countdown === 60) {
                                        parent.countdown = 59;
                                        countdownTimer.start();
                                        console.log("发送验证码");
                                    }
                                }
                            }
                        }
                    }

                    // 密码
                    MobileTextField {
                        id: registerPasswordField
                        placeholderText: qsTr("密码")
                        echoMode: TextInput.Password
                        Layout.fillWidth: true
                        Layout.preferredHeight: 50
                        leftPadding: 45

                        Rectangle {
                            width: 30
                            height: 30
                            radius: 15
                            anchors.left: parent.left
                            anchors.leftMargin: 10
                            anchors.verticalCenter: parent.verticalCenter
                            color: "transparent"

                            Text {
                                anchors.centerIn: parent
                                text: "🔒"
                                font.pixelSize: 18
                                color: "#9E9E9E"
                            }
                        }

                        // 显示/隐藏密码按钮
                        Rectangle {
                            width: 30
                            height: 30
                            radius: 15
                            anchors.right: parent.right
                            anchors.rightMargin: 10
                            anchors.verticalCenter: parent.verticalCenter
                            color: "transparent"

                            Text {
                                anchors.centerIn: parent
                                text: registerPasswordField.echoMode === TextInput.Password ? "👁️" : "👁️‍🗨️"
                                font.pixelSize: 18
                                color: "#9E9E9E"
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    registerPasswordField.echoMode = registerPasswordField.echoMode === TextInput.Password ?
                                                             TextInput.Normal : TextInput.Password
                                }
                            }
                        }
                    }

                    // 确认密码
                    MobileTextField {
                        id: confirmPasswordField
                        placeholderText: qsTr("确认密码")
                        echoMode: TextInput.Password
                        Layout.fillWidth: true
                        Layout.preferredHeight: 50
                        leftPadding: 45

                        Rectangle {
                            width: 30
                            height: 30
                            radius: 15
                            anchors.left: parent.left
                            anchors.leftMargin: 10
                            anchors.verticalCenter: parent.verticalCenter
                            color: "transparent"

                            Text {
                                anchors.centerIn: parent
                                text: "🔒"
                                font.pixelSize: 18
                                color: "#9E9E9E"
                            }
                        }

                        // 显示/隐藏密码按钮
                        Rectangle {
                            width: 30
                            height: 30
                            radius: 15
                            anchors.right: parent.right
                            anchors.rightMargin: 10
                            anchors.verticalCenter: parent.verticalCenter
                            color: "transparent"

                            Text {
                                anchors.centerIn: parent
                                text: confirmPasswordField.echoMode === TextInput.Password ? "👁️" : "👁️‍🗨️"
                                font.pixelSize: 18
                                color: "#9E9E9E"
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    confirmPasswordField.echoMode = confirmPasswordField.echoMode === TextInput.Password ?
                                                             TextInput.Normal : TextInput.Password
                                }
                            }
                        }
                    }

                    // 用户协议
                    RowLayout {
                        Layout.fillWidth: true
                        Layout.topMargin: 0

                        CheckBox {
                            id: termsCheck
                            checked: false
                            padding: 0
                            Layout.preferredHeight: 30
                        }

                        Text {
                            text: qsTr("我已阅读并同意")
                            color: "#CCCCCC"
                            font.pixelSize: 13
                        }

                        Text {
                            text: qsTr("用户协议")
                            color: Material.accent
                            font.pixelSize: 13

                            MouseArea {
                                anchors.fill: parent
                                anchors.margins: -2
                                onClicked: console.log("打开用户协议")
                            }
                        }

                        Text {
                            text: qsTr("和")
                            color: "#CCCCCC"
                            font.pixelSize: 13
                        }

                        Text {
                            text: qsTr("隐私政策")
                            color: Material.accent
                            font.pixelSize: 13

                            MouseArea {
                                anchors.fill: parent
                                anchors.margins: -2
                                onClicked: console.log("打开隐私政策")
                            }
                        }

                        Item { Layout.fillWidth: true }
                    }

                    // 注册按钮
                    MobileButton {
                        text: qsTr("注 册")
                        Layout.fillWidth: true
                        Layout.preferredHeight: 50
                        onClicked: {
                            registerSuccessAnim.start()
                        }
                    }

                    // 填充空间
                    Item {
                        Layout.fillHeight: true
                    }
                }

                // 注册成功动画
                SequentialAnimation {
                    id: registerSuccessAnim

                    ParallelAnimation {
                        NumberAnimation {
                            target: phoneField
                            property: "scale"
                            from: 1.0
                            to: 0.95
                            duration: 100
                        }
                        NumberAnimation {
                            target: verificationField
                            property: "scale"
                            from: 1.0
                            to: 0.95
                            duration: 100
                        }
                        NumberAnimation {
                            target: registerPasswordField
                            property: "scale"
                            from: 1.0
                            to: 0.95
                            duration: 100
                        }
                        NumberAnimation {
                            target: confirmPasswordField
                            property: "scale"
                            from: 1.0
                            to: 0.95
                            duration: 100
                        }
                    }

                    NumberAnimation {
                        target: registerPage
                        property: "opacity"
                        from: 1.0
                        to: 0.7
                        duration: 200
                    }

                    NumberAnimation {
                        target: registerPage
                        property: "opacity"
                        from: 0.7
                        to: 1.0
                        duration: 400
                        easing.type: Easing.OutBack
                    }

                    ParallelAnimation {
                        NumberAnimation {
                            target: phoneField
                            property: "scale"
                            from: 0.95
                            to: 1.0
                            duration: 300
                            easing.type: Easing.OutBack
                        }
                        NumberAnimation {
                            target: verificationField
                            property: "scale"
                            from: 0.95
                            to: 1.0
                            duration: 300
                            easing.type: Easing.OutBack
                        }
                        NumberAnimation {
                            target: registerPasswordField
                            property: "scale"
                            from: 0.95
                            to: 1.0
                            duration: 300
                            easing.type: Easing.OutBack
                        }
                        NumberAnimation {
                            target: confirmPasswordField
                            property: "scale"
                            from: 0.95
                            to: 1.0
                            duration: 300
                            easing.type: Easing.OutBack
                        }
                    }

                    // 注册成功后切换到登录页
                    ScriptAction {
                        script: {
                            console.log("注册成功！")
                            rootItem.registerSuccess()
                            // 由于是新用户，先回到登录页让用户登录
                            swipeView.currentIndex = 0
                        }
                    }
                }
            }
        }

        // 指纹登录区域
        Item {
            id: fingerprintArea
            anchors.bottom: tabBar.top
            anchors.bottomMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            height: 70
            width: 70

            // 指纹登录按钮 - 在登录页面下显示
            Rectangle {
                id: fingerprintButton
                anchors.centerIn: parent
                width: 60
                height: 60
                radius: 30
                color: "transparent"
                border.width: 2
                border.color: "#BB86FC"
                visible: swipeView.currentIndex === 0
                opacity: visible ? 1.0 : 0.0

                Behavior on opacity {
                    NumberAnimation { duration: 300 }
                }

                SequentialAnimation {
                    running: fingerprintButton.visible
                    loops: Animation.Infinite

                    ParallelAnimation {
                        NumberAnimation {
                            target: fingerprintButton
                            property: "scale"
                            from: 1.0
                            to: 1.1
                            duration: 1000
                            easing.type: Easing.InOutQuad
                        }
                        NumberAnimation {
                            target: fingerprintButton
                            property: "opacity"
                            from: 1.0
                            to: 0.7
                            duration: 1000
                            easing.type: Easing.InOutQuad
                        }
                    }

                    ParallelAnimation {
                        NumberAnimation {
                            target: fingerprintButton
                            property: "scale"
                            from: 1.1
                            to: 1.0
                            duration: 1000
                            easing.type: Easing.InOutQuad
                        }
                        NumberAnimation {
                            target: fingerprintButton
                            property: "opacity"
                            from: 0.7
                            to: 1.0
                            duration: 1000
                            easing.type: Easing.InOutQuad
                        }
                    }
                }

                Text {
                    anchors.centerIn: parent
                    text: "👆"
                    font.pixelSize: 26
                    color: "#BB86FC"
                }

                MouseArea {
                    anchors.fill: parent
                    onPressed: parent.scale = 0.9
                    onReleased: parent.scale = 1.0
                    onClicked: {
                        fingerprintScanAnim.start()
                    }
                }

                // 指纹扫描动画
                SequentialAnimation {
                    id: fingerprintScanAnim

                    PropertyAction { target: scannerEffect; property: "visible"; value: true }

                    NumberAnimation {
                        target: scanLine
                        property: "y"
                        from: 0
                        to: fingerprintButton.height
                        duration: 1200
                        easing.type: Easing.InOutQuad
                    }

                    PauseAnimation { duration: 300 }

                    PropertyAction { target: scannerEffect; property: "visible"; value: false }

                    ScriptAction {
                        script: {
                            console.log("指纹登录成功")
                            rootItem.loginSuccess()
                        }
                    }
                }

                // 指纹扫描效果
                Item {
                    id: scannerEffect
                    anchors.fill: parent
                    visible: false
                    clip: true

                    Rectangle {
                        id: scanLine
                        width: parent.width
                        height: 3
                        radius: 1.5
                        color: "#BB86FC"
                        y: 0
                    }
                }
            }
        }

        // 底部标签栏
        TabBar {
            id: tabBar
            currentIndex: swipeView.currentIndex
            anchors.bottom: dateText.top
            anchors.bottomMargin: 5
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            height: 40

            background: Rectangle {
                color: "transparent"
            }

            // 自定义标签按钮
            TabButton {
                text: qsTr("登录")
                font.pixelSize: 16
                font.bold: TabBar.index === tabBar.currentIndex

                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    color: parent.TabBar.index === tabBar.currentIndex ? Material.accent : "#9E9E9E"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                background: Rectangle {
                    color: "transparent"
                    Rectangle {
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.width * 0.7
                        height: 2
                        color: parent.TabBar.index === tabBar.currentIndex ? Material.accent : "transparent"
                        Behavior on color {
                            ColorAnimation { duration: 200 }
                        }
                    }
                }
            }

            TabButton {
                text: qsTr("注册")
                font.pixelSize: 16
                font.bold: TabBar.index === tabBar.currentIndex

                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    color: parent.TabBar.index === tabBar.currentIndex ? Material.accent : "#9E9E9E"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                background: Rectangle {
                    color: "transparent"
                    Rectangle {
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.width * 0.7
                        height: 2
                        color: parent.TabBar.index === tabBar.currentIndex ? Material.accent : "transparent"
                        Behavior on color {
                            ColorAnimation { duration: 200 }
                        }
                    }
                }
            }
        }

        // 时间戳显示（底部小字）
        Text {
            id: dateText
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            text: "2025-03-28 08:57:52"  // 使用当前日期时间
            color: "#666666"
            font.pixelSize: 12
        }
    }

    // 自定义输入框组件
    component MobileTextField : TextField {
        id: customField
        height: 56
        font.pixelSize: 16
        color: "white"
        placeholderTextColor: "#9E9E9E"

        background: Rectangle {
            id: fieldBackground
            color: "#2A2A2A"
            radius: height / 2
            border.width: customField.activeFocus ? 2 : 1
            border.color: customField.activeFocus ? Material.accent : "#3D3D3D"

            // 获取焦点时的动画
            Behavior on border.color {
                ColorAnimation { duration: 200 }
            }
            Behavior on border.width {
                NumberAnimation { duration: 200 }
            }

            // 输入框高亮动画
            Rectangle {
                id: focusHighlight
                anchors.fill: parent
                radius: parent.radius
                color: Material.accent
                opacity: 0

                SequentialAnimation on opacity {
                    running: customField.activeFocus
                    NumberAnimation { to: 0.08; duration: 200 }
                    PauseAnimation { duration: 100 }
                    NumberAnimation { to: 0; duration: 600 }
                }
            }
        }

        // 触摸反馈动画
        onPressed: pressAnimation.start()

        SequentialAnimation {
            id: pressAnimation

            NumberAnimation {
                target: customField
                property: "scale"
                from: 1.0
                to: 0.98
                duration: 100
            }

            NumberAnimation {
                target: customField
                property: "scale"
                from: 0.98
                to: 1.0
                duration: 200
                easing.type: Easing.OutBack
            }
        }

        // 水波纹效果 - 点击时
        Rectangle {
            id: ripple
            property real centerX
            property real centerY

            x: centerX - width / 2
            y: centerY - height / 2
            width: 0
            height: 0
            radius: width / 2
            color: Material.accent
            opacity: 0
            visible: false

            function start(mouseX, mouseY) {
                centerX = mouseX
                centerY = mouseY
                visible = true
                rippleAnimation.start()
            }

            ParallelAnimation {
                id: rippleAnimation

                NumberAnimation {
                    target: ripple
                    properties: "width,height"
                    from: 0
                    to: customField.width * 1.5
                    duration: 500
                    easing.type: Easing.OutQuad
                }

                NumberAnimation {
                    target: ripple
                    property: "opacity"
                    from: 0.3
                    to: 0
                    duration: 500
                    easing.type: Easing.OutQuad
                }

                onFinished: ripple.visible = false
            }
        }

        MouseArea {
            anchors.fill: parent
            propagateComposedEvents: true
            onPressed: {
                ripple.start(mouseX, mouseY)
                mouse.accepted = false
            }
        }
    }

    // 自定义按钮组件
    component MobileButton : Button {
        id: customButton

        contentItem: Text {
            text: customButton.text
            font.pixelSize: 16
            font.bold: true
            color: "white"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            scale: customButton.down ? 0.95 : 1.0
            Behavior on scale {
                NumberAnimation { duration: 100 }
            }
        }

        background: Rectangle {
            id: buttonBg
            radius: height / 2

            gradient: Gradient {
                GradientStop { position: 0.0; color: customButton.pressed ? "#6D4CD4" : "#7B2BFF" }
                GradientStop { position: 1.0; color: customButton.pressed ? "#9F6DFF" : "#BB86FC" }
            }

            // 点击波纹效果
            Rectangle {
                id: buttonRipple
                property real centerX
                property real centerY

                x: centerX - width / 2
                y: centerY - height / 2
                width: 0
                height: 0
                radius: width / 2
                color: "white"
                opacity: 0
                visible: false

                function start(mouseX, mouseY) {
                    centerX = mouseX
                    centerY = mouseY
                    visible = true
                    buttonRippleAnim.start()
                }

                ParallelAnimation {
                    id: buttonRippleAnim

                    NumberAnimation {
                        target: buttonRipple
                        properties: "width,height"
                        from: 0
                        to: buttonBg.width * 2
                        duration: 400
                        easing.type: Easing.OutQuad
                    }

                    NumberAnimation {
                        target: buttonRipple
                        property: "opacity"
                        from: 0.4
                        to: 0
                        duration: 400
                        easing.type: Easing.OutQuad
                    }

                    onFinished: buttonRipple.visible = false
                }
            }
        }

        // 悬停和按下效果
        states: [
            State {
                name: "hovered"
                when: customButton.hovered && !customButton.pressed
                PropertyChanges {
                    target: buttonBg
                    scale: 1.02
                }
            },
            State {
                name: "pressed"
                when: customButton.pressed
                PropertyChanges {
                    target: buttonBg
                    scale: 0.96
                }
            }
        ]

        transitions: Transition {
            NumberAnimation {
                properties: "scale"
                duration: 150
                easing.type: Easing.OutCubic
            }
        }

        MouseArea {
            anchors.fill: parent
            propagateComposedEvents: true
            onPressed: {
                buttonRipple.start(mouseX, mouseY)
                mouse.accepted = false
            }
        }
    }

    // 连接信号
    Connections {
        target: rootItem

        // 登录
        function onLogining() {
            console.log("准备登录")
            if(!usernameField.text || usernameField.text.trim() === ""){
                console.log("用户名为空")
                return
            }
            if(!passwordField.text || passwordField.text.trim() === ""){
                console.log("密码为空")
                return
            }

            // 检测用户名或手机号是否存在
            if(dbManager.checkUserExists(usernameField.text) || dbManager.checkPhoneExists(usernameField.text)){
                console.log("正在检测密码")
                // 与密码匹配
                if(dbManager.validateUser(usernameField.text, passwordField.text)){
                    // 更新上次登录时间
                    dbManager.updateUserLastLogin(usernameField.text)
                    // 成功登录动画
                    loginSuccessAnim.start()
                }
                else{
                    console.log("登录失败，密码错误")
                }
            }
            else{
                console.log("登录失败，用户名或手机号不存在")
            }
        }
    }
    // 连接信号
    Connections {
        target: rootItem

        // 登录
        function onRegistering() {
            console.log("准备注册")
            if(!phoneField.text || phoneField.text.trim() === ""){
                console.log("手机号为空")
                return
            }
            if(!verificationField.text || verificationField.text.trim() === ""){
                console.log("验证码为空")
                return
            }
            if(!registerPasswordField.text || registerPasswordField.text.trim() === ""){
                console.log("密码为空")
                return
            }
            if(!confirmPasswordField.text || confirmPasswordField.text.trim() === ""){
                console.log("验证密码为空")
                return
            }
            if(confirmPasswordField.text != registerPasswordField.text){
                console.log("两次密码不同")
                return
            }

            // 检测用户名或手机号是否存在
            if(dbManager.checkPhoneExists(phoneField.text)){
                console.log("注册失败，手机号已存在")
            }
            else{
                // 注册逻辑

            }
        }
    }
}


