#ifndef MUSICPLAYER_H
#define MUSICPLAYER_H

#include "mainwindow.h"

class MusicPlayer : public QMainWindow
{
    Q_OBJECT

public:
    explicit MusicPlayer(Ui::MainWindow* ui);
    ~MusicPlayer();

private:
    Ui::MainWindow *ui;

    //切换页面
    QStackedWidget* pages;
    QPushButton* back_musicPlayer;

public slots:
    void on_Back_musicPlayer_clicked();
};

#endif // MUSICPLAYER_H
