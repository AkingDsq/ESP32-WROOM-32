#include "call_ai.h"
#include <QDebug>

#include <QSettings>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QStandardPaths>
#include <QFile>
#include <QDir>
#include <bluetoothcontroller.h>

Call_AI::Call_AI() {
    // 文字转语音模块
    speech = new QTextToSpeech(this);
    QObject::connect(speech, &QTextToSpeech::stateChanged, [this](QTextToSpeech::State state) {
        if (state == QTextToSpeech::Ready) {
            isTtsReady = true;
            qDebug() << "TTS 引擎已就绪";
        }
    });
    speech->setLocale(QLocale::Chinese);
    //speech->setVoice(QVoice::);

    // network
    networkManager = new QNetworkAccessManager(this);

    // ini文件
    QString configPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/config.ini";
    // 确保目标目录存在
    QDir().mkpath(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation));
    // 从资源文件拷贝
    QFile src(":/config.ini");
    if (src.exists()) {
        if (src.copy(configPath)) {
            QFile::setPermissions(configPath, QFile::ReadOwner | QFile::WriteOwner);
        } else {
            qDebug() << "拷贝失败原因:" << src.errorString();
        }
    }
    else {
        qDebug() << "资源文件不存在，检查.qrc配置";
    }
}
Call_AI::~Call_AI() {
}

void Call_AI::call(){
    if (isTtsReady) {
        speech->say("你好，需要什么帮助？");
    } else {
        qDebug() << "TTS 引擎未就绪，请稍后重试";
        // 可以在此处重试或提示用户
    }
}

void Call_AI::requestAI(QString question) {
    qDebug() << "正在思考...";
    if (question.isEmpty()) {qDebug() << "问题为空"; return;}

    // 添加提示词
    QString words = R"(请遵循以下回答规则：
                        1.在以下规定的各种指令中根据语音识别结果选出一条或多条固定的指令组成指令集，
                            指令集的格式为：[指令]-[指令]…等等，
                            语音识别结果将在文末给出。
                            例如：如果有两个指令：开灯-播报温度。
                        2. 回答分为两部分，
                            前半部分是指令集，
                            后半部分是根据具体的指令集作出回复，语气可爱，
                            前后部分用，隔开。
                        3.如果语音识别结果包含完整的指令意思，直接根据上面1.2规则即可。
                        4. 如果语音识别结果没有包含指令的意思，请使用可爱的语气回答或与其对话，前半部分为空，后半部分是回复，
                            例如：
                            识别结果为"你好"，不包含指令意思，根据语意回复。
                            则前半部分为空，后半部分为回复，以，隔开
                        5. 如果语音识别结果包含下达指令的意思，但是都无法确定是具体是哪个或哪些指令，则指令集为空。
                            例如：
                            如果只识别出"灯"，无法确定是"关灯"或"开灯"
                            或者如果同时出现了"关灯"和"开灯"，
                            则前半部分为空，后半部分是回复，隔开，
                            请根据下面给出的内容用可爱的语气回答，可以适当修改以符合语气，50字以内，
                            例如：
                            ，不好意思，可以再说一遍吗，我没有听清。
                        6. 如果可以识别出部分指令，请只给出识别出的指令集，并且用可爱的语气回答无法识别出后续的指令，50字以内
                            例如：
                            识别结果是"开播报"，意思可能包含"开灯"指令，但是"播报"无法确定是温度还是湿度，则首先确定指令集为"开灯"，回复首先包含开灯的语意，然后接着回复播报指令无法确定是播放温度还是湿度，需要重新说明。
                            前半部分为开灯，后半部分为回复
                        7. 所有示例仅供参考，请根据实际情况用可爱的语气回答，包含原有意思即可，并且所有回答的内容将通过语音播报出，
                            如果识别出重复的指令，只需要输出一个即可
                            请符合文字转语音标准，
                            不包含无法转语音的字符以及非必要的动作的文字例如（眨眨眼），
                            不包含违规词汇如主人等。
                        8.如果是播报温度或湿度或者同时出现播报温度和播报湿度时则在后半部分的回答中不给出具体的值，用占位符%1，%2…等等代替，且如果需同时播报则按照先温度后湿度的顺序
                            例如：播报温度-播报湿度，现在是%1度，现在的湿度是%2%
                        9.指令匹配优先级
                            1.1 完全匹配优先（如"开灯"匹配开灯指令）
                            1.2 核心词匹配次之（如"温"匹配播报温度）
                            1.3 模糊匹配最后（如"灯"需进一步确认）

                        指令：
                        1.开灯
                        2.关灯
                        3.播报温度
                        4.播报湿度
                        语音识别结果：)";
    question.prepend(words);

    // 读取API
    QString apiKey = "sk-09482e6b58754726b53c1f26349f208d";
    // QFile targetFile(configPath);
    // if (targetFile.open(QIODevice::ReadOnly)) {
    //     qDebug() << "配置文件内容：" << targetFile.readAll();
    //     apiKey = targetFile.readAll();
    //     targetFile.close();
    // }

    if (apiKey.isEmpty()) {
        qDebug() << "API Key 未找到或为空";
        return;
    }

    // 构造请求
    QNetworkRequest request(QUrl("https://api.deepseek.com/chat/completions"));
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    request.setRawHeader("Authorization", QString("Bearer %1").arg(apiKey).toUtf8());

    // 构造请求体
    QJsonObject jsonBody;
    jsonBody["model"] = "deepseek-chat";
    jsonBody["temperature"] = 0.7;
    QJsonArray messages;
    messages.append(QJsonObject{ {"role", "user"}, {"content", question} });
    jsonBody["messages"] = messages;

    // 发送请求
    QNetworkReply* reply = networkManager->post(request, QJsonDocument(jsonBody).toJson());
    connect(reply, &QNetworkReply::finished, this, &Call_AI::handleReplyFinished);
}

void Call_AI::handleReplyFinished() {
    QNetworkReply* reply = qobject_cast<QNetworkReply*>(sender());
    QString responseText;

    if (reply->error() == QNetworkReply::NoError) {
        QJsonDocument doc = QJsonDocument::fromJson(reply->readAll());
        QJsonObject root = doc.object();
        QString answer = root["choices"].toArray()[0].toObject()["message"].toObject()["content"].toString();
        responseText = "助手：" + answer;

        // 调用data方法处理文本
        data(answer);
        emit endINMP441();
    }
    else {
        responseText = "错误: " + reply->errorString();
        qDebug() << responseText;
    }

    // 发送响应信号
    emit aiResponseReceived(responseText);
    reply->deleteLater();
}

// 指令
QString commendChange(QString commend){
    if(commend == "开灯") return "LED_ON";
    else if(commend == "关灯") return "LED_OFF";
    else if(commend == "播报温度") return "callTem";
    else if(commend == "播报湿度") return "callHem";
    return "";
}
// 解析回复
void Call_AI::data(QString answer){
    qDebug() << "处理AI回复: " << answer;

    // 获取,的位置
    int index1 = answer.indexOf("，");
    QString l = "";
    // 分割前半部分指令集，后半部分回答
    if(index1 != 0){
        l = answer.mid(0, index1);
    }

    QString r = answer.mid(index1 + 1, answer.size() - 1);
    QString ans = r;
    bool tem = false,hem = false;
    qDebug() << "l:" << l << "\nr:" << r;
    // 发送识别的指令集,多个指令以-隔开，例如：[指令]-[指令]
    if (!l.isEmpty()) { // 确保指令字符串非空
        qDebug() << "原始指令集：" << l;

        int startPos = 0;
        for (int i = 0; i <= l.size(); ++i) { // 遍历到字符串末尾+1的位置以处理最后一个指令
            // 遇到分隔符或字符串结尾时截取指令
            if (i == l.size() || l[i] == '-') {
                if (startPos < i) { // 避免空指令
                    QString command = l.mid(startPos, i - startPos).trimmed(); // 截取并去除空格
                    qDebug() << "解析到指令：" << command;

                    // 发送指令到蓝牙设备
                    //emit commandReady(command);
                    m_bluetoothController->sendCommand(commendChange(command));

                    // 处理温湿度播报标记
                    if (command == "播报温度") {
                        tem = true;
                    }
                    if (command == "播报湿度") {
                        hem = true;
                    }
                }
                startPos = i + 1; // 跳过'-'符号
            }
        }
    }
    qDebug() << "tem:" << tem << "\nhem:" << hem;
    // 嵌入实时温湿度
    if(tem && hem){
        ans = r.arg(m_bluetoothController->temperature()).arg(m_bluetoothController->humidity());
    }
    if(tem && !hem){
        ans = r.arg(m_bluetoothController->temperature());
    }
    if(!tem && hem){
        ans = r.arg(m_bluetoothController->humidity());
    }

    // 播报回答
    saying(ans);
}
// 语音播报
void Call_AI::saying(QString param){
    if (isTtsReady) {
        qDebug() << "TTS播放: " << param;
        speech->say(param);
    } else {
        qDebug() << "TTS 引擎未就绪，请稍后重试";
        // 可以在此处重试或提示用户
    }
}
