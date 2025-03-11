#include "MusicPlayer.h"
#include "error.h"

// 初始化蓝牙连接
void init_BlueTooth_Connect();

MusicPlayer::MusicPlayer(Ui::MainWindow* ui)
    : ui(ui)
{
    bluetoothManager = new BluetoothManager();
    //
    pages = ui->stackedWidget;
    back_musicPlayer = ui->back_musicPlayer;
    //
    connect(back_musicPlayer, &QPushButton::clicked, this, &MusicPlayer::on_Back_musicPlayer_clicked);
    // 连接蓝牙
    init_BlueTooth_Connect();
}

MusicPlayer::~MusicPlayer()
{

}
void MusicPlayer::on_Back_musicPlayer_clicked(){
    if (pages != nullptr) {
        pages->setCurrentIndex(0);    //切换页面
    }
    else qDebug() << "页面为空";
}

void MusicPlayer::init_BlueTooth_Connect(){
    error *e = new error;
    QLabel* message = e->getMessageLabel();
    message->setText("正在连接蓝牙");
    e->show();

    message->setText(bluetoothManager->connectToDevice());

}
