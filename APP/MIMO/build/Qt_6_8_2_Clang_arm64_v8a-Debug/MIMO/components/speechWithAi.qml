import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls.Material

ApplicationWindow {
    id: window
    visible: true
    width: 618
    height: 1338
    title: qsTr("登录/注册")

    // 使用Material主题并自定义颜色
    Material.theme: Material.Dark
    Material.accent: Material.Purple
    Material.primary: Material.DeepPurple

    // 动态背景
    Rectangle {
        id: background
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#121212" }
            GradientStop { position: 1.0; color: "#1E1E1E" }
        }

        // 动态粒子背景
        ShaderEffect {
            id: shaderEffect
            anchors.fill: parent

            property real time: 0.0
            property vector2d resolution: Qt.vector2d(width, height)
            property vector2d touch: Qt.vector2d(-1.0, -1.0)

            fragmentShader: "
                #version 440

                layout(location = 0) in vec2 qt_TexCoord0;
                layout(location = 0) out vec4 fragColor;

                layout(std140, binding = 0) uniform buf {
                    mat4 qt_Matrix;
                    float qt_Opacity;
                    float time;
                    vec2 resolution;
                    vec2 touch;
                };

                float rand(vec2 co) {
                    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
                }

                void main() {
                    vec2 uv = qt_TexCoord0.xy;
                    vec2 p = uv * 2.0 - 1.0;

                    vec3 finalColor = vec3(0.0);

                    // Create cells
                    float size = 20.0;
                    vec2 cell = floor(uv * size) / size;

                    // Animate particles
                    for (int i = 0; i < 3; i++) {
                        float randVal = rand(cell + float(i));
                        float speed = 0.1 + randVal * 0.2;

                        // Particle position
                        float t = fract(time * speed + randVal);
                        vec2 pos = cell + vec2(
                            0.5 + 0.4 * sin(time * (0.5 + randVal) + randVal * 6.28),
                            0.5 + 0.4 * cos(time * (0.5 + randVal) + randVal * 6.28)
                        );

                        // Touch effect
                        if (touch.x > 0.0) {
                            vec2 touchUV = touch / resolution;
                            float dist = distance(pos, touchUV);
                            if (dist < 0.15) {
                                pos += normalize(pos - touchUV) * 0.02 * (1.0 - dist / 0.15);
                            }
                        }

                        // Draw particle
                        float d = length(uv - pos);
                        float brightness = 0.01 / d;
                        brightness = clamp(brightness, 0.0, 1.0);

                        // Color based on position
                        vec3 col = mix(
                            vec3(0.4, 0.1, 0.8), // Purple
                            vec3(0.6, 0.3, 1.0), // Light purple
                            randVal
                        );

                        finalColor += col * brightness * 0.5;
                    }

                    fragColor = vec4(finalColor, 1.0);
                }
            "

            NumberAnimation on time {
                from: 0.0
                to: 100.0
                duration: 100000
                loops: Animation.Infinite
                running: true
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onPositionChanged: {
                    shaderEffect.touch = Qt.vector2d(mouseX, mouseY)
                }

                onReleased: {
                    shaderEffect.touch = Qt.vector2d(-1.0, -1.0)
                }
            }
        }
    }

    // Logo和标题区域
    Item {
        id: logoArea
        anchors.top: parent.top
        anchors.topMargin: 60
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width * 0.35
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

                // 发光效果
                MultiEffect {
                    source: parent
                    anchors.fill: parent
                    shadowEnabled: true
                    shadowColor: "#80FFFFFF"
                    shadowHorizontalOffset: 0
                    shadowVerticalOffset: 0
                    shadowBlur: 0.5
                    shadowOpacity: 0.5
                }
            }
        }
    }

    // 应用名称
    Text {
        anchors.top: logoArea.bottom
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        text: "AkingDsq" // 使用当前用户名
        color: "white"
        font.pixelSize: 28
        font.bold: true

        // 发光效果
        MultiEffect {
            source: parent
            anchors.fill: parent
            shadowEnabled: true
            shadowColor: "#80BB86FC"
            shadowHorizontalOffset: 0
            shadowVerticalOffset: 0
            shadowBlur: 0.5
            shadowOpacity: 0.3
        }
    }

    // 主内容区域 - 登录/注册表单
    SwipeView {
        id: swipeView
        anchors.top: logoArea.bottom
        anchors.topMargin: 80
        anchors.bottom: footer.top
        anchors.bottomMargin: 20
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
                spacing: 20

                Item { Layout.fillHeight: true; Layout.preferredHeight: 10 }

                // 欢迎回来文字
                Label {
                    text: qsTr("欢迎回来")
                    font.pixelSize: 26
                    font.bold: true
                    color: "white"
                    Layout.alignment: Qt.AlignHCenter

                    MultiEffect {
                        source: parent
                        anchors.fill: parent
                        shadowEnabled: true
                        shadowColor: "#80BB86FC"
                        shadowHorizontalOffset: 0
                        shadowVerticalOffset: 0
                        shadowBlur: 0.5
                        shadowOpacity: 0.3
                    }
                }

                Item { Layout.fillHeight: true; Layout.preferredHeight: 20 }

                // 用户名/手机号
                MobileTextField {
                    id: usernameField
                    placeholderText: qsTr("用户名/手机号")
                    Layout.fillWidth: true
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
                    Layout.topMargin: 5

                    Switch {
                        id: rememberSwitch
                        text: qsTr("记住密码")
                        checked: true
                    }

                    Item { Layout.fillWidth: true }

                    Label {
                        text: qsTr("忘记密码?")
                        color: Material.accent

                        MouseArea {
                            anchors.fill: parent
                            anchors.margins: -5
                            onClicked: console.log("忘记密码")
                        }
                    }
                }

                Item { Layout.fillHeight: true; Layout.preferredHeight: 30 }

                // 登录按钮
                MobileButton {
                    text: qsTr("登 录")
                    Layout.fillWidth: true
                    Layout.preferredHeight: 56
                    onClicked: {
                        loginSuccessAnim.start()
                        loader.source = "LoginOn.qml"  // 跳转到主界面
                    }
                }

                Item { Layout.fillHeight: true; Layout.preferredHeight: 20 }

                // 快捷登录选项
                ColumnLayout {
                    spacing: 15
                    Layout.fillWidth: true

                    Label {
                        text: qsTr("—— 快捷登录 ——")
                        color: "#9E9E9E"
                        font.pixelSize: 14
                        Layout.alignment: Qt.AlignHCenter
                    }

                    RowLayout {
                        spacing: 30
                        Layout.alignment: Qt.AlignHCenter

                        Repeater {
                            model: [
                                { name: "微信", emoji: "📱", color: "#07C160" },
                                { name: "支付宝", emoji: "💰", color: "#1677FF" },
                                { name: "微博", emoji: "📚", color: "#E6162D" }
                            ]

                            delegate: Item {
                                Layout.preferredWidth: 50
                                Layout.preferredHeight: 50

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
                                        onClicked: console.log(modelData.name + "登录")
                                    }

                                    Behavior on scale {
                                        NumberAnimation { duration: 100 }
                                    }
                                }
                            }
                        }
                    }
                }

                Item { Layout.fillHeight: true }
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
                    script: console.log("登录成功！")
                }
            }
        }

        // 注册页面
        Item {
            id: registerPage

            ColumnLayout {
                anchors.fill: parent
                spacing: 15

                Item { Layout.preferredHeight: 10 }

                // 标题
                Label {
                    text: qsTr("注册新账号")
                    font.pixelSize: 26
                    font.bold: true
                    color: "white"
                    Layout.alignment: Qt.AlignHCenter

                    MultiEffect {
                        source: parent
                        anchors.fill: parent
                        shadowEnabled: true
                        shadowColor: "#80BB86FC"
                        shadowHorizontalOffset: 0
                        shadowVerticalOffset: 0
                        shadowBlur: 0.5
                        shadowOpacity: 0.3
                    }
                }

                Item { Layout.preferredHeight: 20 }

                // 手机号
                MobileTextField {
                    id: phoneField
                    placeholderText: qsTr("手机号")
                    Layout.fillWidth: true
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
                    Layout.topMargin: 5

                    CheckBox {
                        id: termsCheck
                        checked: false
                    }

                    Text {
                        text: qsTr("我已阅读并同意")
                        color: "#CCCCCC"
                        font.pixelSize: 14
                    }

                    Text {
                        text: qsTr("用户协议")
                        color: Material.accent
                        font.pixelSize: 14

                        MouseArea {
                            anchors.fill: parent
                            anchors.margins: -2
                            onClicked: console.log("打开用户协议")
                        }
                    }

                    Text {
                        text: qsTr("和")
                        color: "#CCCCCC"
                        font.pixelSize: 14
                    }

                    Text {
                        text: qsTr("隐私政策")
                        color: Material.accent
                        font.pixelSize: 14

                        MouseArea {
                            anchors.fill: parent
                            anchors.margins: -2
                            onClicked: console.log("打开隐私政策")
                        }
                    }
                }

                Item { Layout.fillHeight: true; Layout.preferredHeight: 20 }

                // 注册按钮
                MobileButton {
                    text: qsTr("注 册")
                    Layout.fillWidth: true
                    Layout.preferredHeight: 56
                    onClicked: {
                        registerSuccessAnim.start()
                    }
                }

                Item { Layout.fillHeight: true }
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
                        swipeView.currentIndex = 0
                    }
                }
            }
        }
    }

    // 指纹登录按钮 - 在登录页面下显示
    Rectangle {
        id: fingerprintButton
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 70
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
                script: loginSuccessAnim.start()
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

                MultiEffect {
                    source: parent
                    anchors.fill: parent
                    shadowEnabled: true
                    shadowColor: "#80BB86FC"
                    shadowHorizontalOffset: 0
                    shadowVerticalOffset: 0
                    shadowBlur: 0.8
                    shadowOpacity: 0.8
                }
            }
        }
    }

    // 页面切换标签栏
    footer: TabBar {
        id: tabBar
        currentIndex: swipeView.currentIndex
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width * 0.8
        height: 50
        position: TabBar.Footer

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
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        text: "2025-03-25"
        color: "#666666"
        font.pixelSize: 12
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

            // 亮度增加光晕效果
            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: "#40BB86FC"
                shadowHorizontalOffset: 0
                shadowVerticalOffset: 0
                shadowBlur: 0.5
                shadowOpacity: 0.5
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
}
