#include "error.h"
#include "ui_error.h"

void requestPermissions();
error::error(QWidget *parent)
    : QWidget(parent)
    , ui(new Ui::error)
{
    ui->setupUi(this); // 初始化 UI
    message = ui->message;
    retry = ui->retry;
}

error::~error()
{
    delete ui;
}
QLabel* error::getMessageLabel(){
    return message;
}
QPushButton* error::getButtonRetry(){
    return retry;
}


