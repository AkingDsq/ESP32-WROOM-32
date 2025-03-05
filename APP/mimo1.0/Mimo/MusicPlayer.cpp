#include "MusicPlayer.h"

MusicPlayer::MusicPlayer(Ui::MainWindow* ui)
    : ui(ui)
{
    pages = ui->stackedWidget;
    back_musicPlayer = ui->back_musicPlayer;

    connect(back_musicPlayer, &QPushButton::clicked, this, &MusicPlayer::on_Back_musicPlayer_clicked);

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

