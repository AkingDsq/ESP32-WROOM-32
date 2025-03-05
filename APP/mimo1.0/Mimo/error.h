#ifndef ERROR_H
#define ERROR_H

#include <QWidget>
#include <qlabel.h>
#include <QPushButton.h>

namespace Ui {
class error;
}

class error : public QWidget
{
    Q_OBJECT

public:
    explicit error(QWidget *parent = nullptr);
    ~error();



    QLabel* getMessageLabel();
    QPushButton* getButtonRetry();

private:
    Ui::error *ui;
    QLabel* message;
    QPushButton* retry;

public slots:

};

#endif // ERROR_H
