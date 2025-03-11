#ifndef MUSICPLAYER_H
#define MUSICPLAYER_H

#include "mainwindow.h"
#include "bluetoothmanager.h"

class BluetoothManager;

class MusicPlayer : public QMainWindow
{
    Q_OBJECT

public:
    explicit MusicPlayer(Ui::MainWindow* ui);
    ~MusicPlayer();

    void init_BlueTooth_Connect();

private:
    Ui::MainWindow *ui;
    BluetoothManager* bluetoothManager;

    //切换页面
    QStackedWidget* pages;
    QPushButton* back_musicPlayer;

public slots:
    void on_Back_musicPlayer_clicked();

};

#endif // MUSICPLAYER_H
