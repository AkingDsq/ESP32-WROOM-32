#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include "ui_mainwindow.h"

QT_BEGIN_NAMESPACE
namespace Ui {
class MainWindow;
}
QT_END_NAMESPACE

class MusicPlayer;

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

    //切换页面
    QStackedWidget* pages;
    //菜单栏
    QPushButton* musicPlayer_page_1;
    QPushButton* musicPlayer_page_2;


private:
    Ui::MainWindow *ui;
    MusicPlayer* musicPlayer;

    void init();

public slots:
    void on_stackedWidget_currentChanged(int index); // //切换页面

};
#endif // MAINWINDOW_H
