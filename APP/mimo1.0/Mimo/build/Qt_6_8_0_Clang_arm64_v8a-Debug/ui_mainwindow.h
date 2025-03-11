/********************************************************************************
** Form generated from reading UI file 'mainwindow.ui'
**
** Created by: Qt User Interface Compiler version 6.8.0
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_MAINWINDOW_H
#define UI_MAINWINDOW_H

#include <QtCore/QVariant>
#include <QtWidgets/QApplication>
#include <QtWidgets/QGridLayout>
#include <QtWidgets/QHBoxLayout>
#include <QtWidgets/QLabel>
#include <QtWidgets/QMainWindow>
#include <QtWidgets/QPushButton>
#include <QtWidgets/QSlider>
#include <QtWidgets/QSpacerItem>
#include <QtWidgets/QStackedWidget>
#include <QtWidgets/QTextBrowser>
#include <QtWidgets/QTextEdit>
#include <QtWidgets/QVBoxLayout>
#include <QtWidgets/QWidget>

QT_BEGIN_NAMESPACE

class Ui_MainWindow
{
public:
    QWidget *centralwidget;
    QGridLayout *gridLayout;
    QVBoxLayout *verticalLayout;
    QTextBrowser *textBrowser;
    QStackedWidget *stackedWidget;
    QWidget *page1;
    QGridLayout *gridLayout_3;
    QGridLayout *gridLayout_2;
    QPushButton *pushButton_6;
    QPushButton *musicPlayer_page_2;
    QPushButton *pushButton_7;
    QPushButton *pushButton_9;
    QPushButton *pushButton_8;
    QPushButton *pushButton_3;
    QPushButton *pushButton_4;
    QPushButton *pushButton_5;
    QPushButton *musicPlayer_page_1;
    QWidget *page2;
    QGridLayout *gridLayout_4;
    QVBoxLayout *verticalLayout_2;
    QPushButton *back_musicPlayer;
    QTextEdit *textEdit;
    QSlider *horizontalSlider;
    QHBoxLayout *horizontalLayout_2;
    QLabel *label;
    QSpacerItem *horizontalSpacer;
    QLabel *label_2;
    QHBoxLayout *horizontalLayout;
    QPushButton *mode;
    QPushButton *pre;
    QPushButton *s_or_e;
    QPushButton *next;
    QPushButton *list;
    QSpacerItem *verticalSpacer;
    QWidget *page3;
    QGridLayout *gridLayout_7;
    QGridLayout *gridLayout_6;
    QSpacerItem *horizontalSpacer_2;
    QPushButton *back_musicPlayer_2;
    QSpacerItem *verticalSpacer_3;

    void setupUi(QMainWindow *MainWindow)
    {
        if (MainWindow->objectName().isEmpty())
            MainWindow->setObjectName("MainWindow");
        MainWindow->resize(720, 960);
        centralwidget = new QWidget(MainWindow);
        centralwidget->setObjectName("centralwidget");
        QSizePolicy sizePolicy(QSizePolicy::Policy::Expanding, QSizePolicy::Policy::Expanding);
        sizePolicy.setHorizontalStretch(0);
        sizePolicy.setVerticalStretch(0);
        sizePolicy.setHeightForWidth(centralwidget->sizePolicy().hasHeightForWidth());
        centralwidget->setSizePolicy(sizePolicy);
        gridLayout = new QGridLayout(centralwidget);
        gridLayout->setObjectName("gridLayout");
        verticalLayout = new QVBoxLayout();
        verticalLayout->setSpacing(0);
        verticalLayout->setObjectName("verticalLayout");
        verticalLayout->setContentsMargins(0, 0, 0, 0);
        textBrowser = new QTextBrowser(centralwidget);
        textBrowser->setObjectName("textBrowser");
        textBrowser->setEnabled(true);
        sizePolicy.setHeightForWidth(textBrowser->sizePolicy().hasHeightForWidth());
        textBrowser->setSizePolicy(sizePolicy);
        textBrowser->setReadOnly(true);

        verticalLayout->addWidget(textBrowser);

        stackedWidget = new QStackedWidget(centralwidget);
        stackedWidget->setObjectName("stackedWidget");
        sizePolicy.setHeightForWidth(stackedWidget->sizePolicy().hasHeightForWidth());
        stackedWidget->setSizePolicy(sizePolicy);
        page1 = new QWidget();
        page1->setObjectName("page1");
        sizePolicy.setHeightForWidth(page1->sizePolicy().hasHeightForWidth());
        page1->setSizePolicy(sizePolicy);
        gridLayout_3 = new QGridLayout(page1);
        gridLayout_3->setSpacing(0);
        gridLayout_3->setObjectName("gridLayout_3");
        gridLayout_3->setContentsMargins(0, 0, 0, 0);
        gridLayout_2 = new QGridLayout();
        gridLayout_2->setSpacing(0);
        gridLayout_2->setObjectName("gridLayout_2");
        pushButton_6 = new QPushButton(page1);
        pushButton_6->setObjectName("pushButton_6");
        sizePolicy.setHeightForWidth(pushButton_6->sizePolicy().hasHeightForWidth());
        pushButton_6->setSizePolicy(sizePolicy);

        gridLayout_2->addWidget(pushButton_6, 1, 5, 1, 1);

        musicPlayer_page_2 = new QPushButton(page1);
        musicPlayer_page_2->setObjectName("musicPlayer_page_2");
        sizePolicy.setHeightForWidth(musicPlayer_page_2->sizePolicy().hasHeightForWidth());
        musicPlayer_page_2->setSizePolicy(sizePolicy);

        gridLayout_2->addWidget(musicPlayer_page_2, 0, 3, 1, 1);

        pushButton_7 = new QPushButton(page1);
        pushButton_7->setObjectName("pushButton_7");
        sizePolicy.setHeightForWidth(pushButton_7->sizePolicy().hasHeightForWidth());
        pushButton_7->setSizePolicy(sizePolicy);

        gridLayout_2->addWidget(pushButton_7, 2, 1, 1, 1);

        pushButton_9 = new QPushButton(page1);
        pushButton_9->setObjectName("pushButton_9");
        sizePolicy.setHeightForWidth(pushButton_9->sizePolicy().hasHeightForWidth());
        pushButton_9->setSizePolicy(sizePolicy);

        gridLayout_2->addWidget(pushButton_9, 2, 5, 1, 1);

        pushButton_8 = new QPushButton(page1);
        pushButton_8->setObjectName("pushButton_8");
        sizePolicy.setHeightForWidth(pushButton_8->sizePolicy().hasHeightForWidth());
        pushButton_8->setSizePolicy(sizePolicy);

        gridLayout_2->addWidget(pushButton_8, 2, 3, 1, 1);

        pushButton_3 = new QPushButton(page1);
        pushButton_3->setObjectName("pushButton_3");
        sizePolicy.setHeightForWidth(pushButton_3->sizePolicy().hasHeightForWidth());
        pushButton_3->setSizePolicy(sizePolicy);

        gridLayout_2->addWidget(pushButton_3, 0, 5, 1, 1);

        pushButton_4 = new QPushButton(page1);
        pushButton_4->setObjectName("pushButton_4");
        sizePolicy.setHeightForWidth(pushButton_4->sizePolicy().hasHeightForWidth());
        pushButton_4->setSizePolicy(sizePolicy);

        gridLayout_2->addWidget(pushButton_4, 1, 1, 1, 1);

        pushButton_5 = new QPushButton(page1);
        pushButton_5->setObjectName("pushButton_5");
        sizePolicy.setHeightForWidth(pushButton_5->sizePolicy().hasHeightForWidth());
        pushButton_5->setSizePolicy(sizePolicy);

        gridLayout_2->addWidget(pushButton_5, 1, 3, 1, 1);

        musicPlayer_page_1 = new QPushButton(page1);
        musicPlayer_page_1->setObjectName("musicPlayer_page_1");
        sizePolicy.setHeightForWidth(musicPlayer_page_1->sizePolicy().hasHeightForWidth());
        musicPlayer_page_1->setSizePolicy(sizePolicy);

        gridLayout_2->addWidget(musicPlayer_page_1, 0, 1, 1, 1);


        gridLayout_3->addLayout(gridLayout_2, 0, 0, 1, 1);

        stackedWidget->addWidget(page1);
        page2 = new QWidget();
        page2->setObjectName("page2");
        sizePolicy.setHeightForWidth(page2->sizePolicy().hasHeightForWidth());
        page2->setSizePolicy(sizePolicy);
        gridLayout_4 = new QGridLayout(page2);
        gridLayout_4->setSpacing(0);
        gridLayout_4->setObjectName("gridLayout_4");
        gridLayout_4->setContentsMargins(-1, 0, 0, 0);
        verticalLayout_2 = new QVBoxLayout();
        verticalLayout_2->setSpacing(0);
        verticalLayout_2->setObjectName("verticalLayout_2");
        back_musicPlayer = new QPushButton(page2);
        back_musicPlayer->setObjectName("back_musicPlayer");
        QSizePolicy sizePolicy1(QSizePolicy::Policy::Maximum, QSizePolicy::Policy::Minimum);
        sizePolicy1.setHorizontalStretch(0);
        sizePolicy1.setVerticalStretch(0);
        sizePolicy1.setHeightForWidth(back_musicPlayer->sizePolicy().hasHeightForWidth());
        back_musicPlayer->setSizePolicy(sizePolicy1);
        back_musicPlayer->setMinimumSize(QSize(0, 25));
        back_musicPlayer->setMaximumSize(QSize(75, 16777215));

        verticalLayout_2->addWidget(back_musicPlayer);

        textEdit = new QTextEdit(page2);
        textEdit->setObjectName("textEdit");

        verticalLayout_2->addWidget(textEdit);

        horizontalSlider = new QSlider(page2);
        horizontalSlider->setObjectName("horizontalSlider");
        sizePolicy.setHeightForWidth(horizontalSlider->sizePolicy().hasHeightForWidth());
        horizontalSlider->setSizePolicy(sizePolicy);
        horizontalSlider->setOrientation(Qt::Orientation::Horizontal);
        horizontalSlider->setTickPosition(QSlider::TickPosition::NoTicks);

        verticalLayout_2->addWidget(horizontalSlider);

        horizontalLayout_2 = new QHBoxLayout();
        horizontalLayout_2->setSpacing(0);
        horizontalLayout_2->setObjectName("horizontalLayout_2");
        horizontalLayout_2->setContentsMargins(-1, -1, -1, 35);
        label = new QLabel(page2);
        label->setObjectName("label");
        sizePolicy.setHeightForWidth(label->sizePolicy().hasHeightForWidth());
        label->setSizePolicy(sizePolicy);
        label->setAlignment(Qt::AlignmentFlag::AlignCenter);

        horizontalLayout_2->addWidget(label);

        horizontalSpacer = new QSpacerItem(40, 20, QSizePolicy::Policy::Expanding, QSizePolicy::Policy::Minimum);

        horizontalLayout_2->addItem(horizontalSpacer);

        label_2 = new QLabel(page2);
        label_2->setObjectName("label_2");
        sizePolicy.setHeightForWidth(label_2->sizePolicy().hasHeightForWidth());
        label_2->setSizePolicy(sizePolicy);
        QFont font;
        font.setPointSize(10);
        label_2->setFont(font);
        label_2->setAlignment(Qt::AlignmentFlag::AlignCenter);

        horizontalLayout_2->addWidget(label_2);

        horizontalLayout_2->setStretch(0, 1);
        horizontalLayout_2->setStretch(1, 15);
        horizontalLayout_2->setStretch(2, 1);

        verticalLayout_2->addLayout(horizontalLayout_2);

        horizontalLayout = new QHBoxLayout();
        horizontalLayout->setSpacing(0);
        horizontalLayout->setObjectName("horizontalLayout");
        mode = new QPushButton(page2);
        mode->setObjectName("mode");
        sizePolicy.setHeightForWidth(mode->sizePolicy().hasHeightForWidth());
        mode->setSizePolicy(sizePolicy);
        QFont font1;
        font1.setPointSize(15);
        mode->setFont(font1);

        horizontalLayout->addWidget(mode);

        pre = new QPushButton(page2);
        pre->setObjectName("pre");
        sizePolicy.setHeightForWidth(pre->sizePolicy().hasHeightForWidth());
        pre->setSizePolicy(sizePolicy);
        pre->setFont(font1);

        horizontalLayout->addWidget(pre);

        s_or_e = new QPushButton(page2);
        s_or_e->setObjectName("s_or_e");
        sizePolicy.setHeightForWidth(s_or_e->sizePolicy().hasHeightForWidth());
        s_or_e->setSizePolicy(sizePolicy);
        s_or_e->setFont(font1);

        horizontalLayout->addWidget(s_or_e);

        next = new QPushButton(page2);
        next->setObjectName("next");
        sizePolicy.setHeightForWidth(next->sizePolicy().hasHeightForWidth());
        next->setSizePolicy(sizePolicy);
        next->setFont(font1);

        horizontalLayout->addWidget(next);

        list = new QPushButton(page2);
        list->setObjectName("list");
        sizePolicy.setHeightForWidth(list->sizePolicy().hasHeightForWidth());
        list->setSizePolicy(sizePolicy);
        list->setFont(font1);

        horizontalLayout->addWidget(list);


        verticalLayout_2->addLayout(horizontalLayout);

        verticalSpacer = new QSpacerItem(20, 40, QSizePolicy::Policy::Minimum, QSizePolicy::Policy::Expanding);

        verticalLayout_2->addItem(verticalSpacer);

        verticalLayout_2->setStretch(0, 3);
        verticalLayout_2->setStretch(1, 45);
        verticalLayout_2->setStretch(2, 3);
        verticalLayout_2->setStretch(3, 2);
        verticalLayout_2->setStretch(4, 5);
        verticalLayout_2->setStretch(5, 5);

        gridLayout_4->addLayout(verticalLayout_2, 0, 0, 1, 1);

        stackedWidget->addWidget(page2);
        page3 = new QWidget();
        page3->setObjectName("page3");
        sizePolicy.setHeightForWidth(page3->sizePolicy().hasHeightForWidth());
        page3->setSizePolicy(sizePolicy);
        gridLayout_7 = new QGridLayout(page3);
        gridLayout_7->setSpacing(0);
        gridLayout_7->setObjectName("gridLayout_7");
        gridLayout_7->setContentsMargins(0, 0, 0, 0);
        gridLayout_6 = new QGridLayout();
        gridLayout_6->setSpacing(0);
        gridLayout_6->setObjectName("gridLayout_6");
        horizontalSpacer_2 = new QSpacerItem(40, 20, QSizePolicy::Policy::Expanding, QSizePolicy::Policy::Minimum);

        gridLayout_6->addItem(horizontalSpacer_2, 0, 1, 1, 1);

        back_musicPlayer_2 = new QPushButton(page3);
        back_musicPlayer_2->setObjectName("back_musicPlayer_2");
        sizePolicy.setHeightForWidth(back_musicPlayer_2->sizePolicy().hasHeightForWidth());
        back_musicPlayer_2->setSizePolicy(sizePolicy);

        gridLayout_6->addWidget(back_musicPlayer_2, 0, 0, 1, 1);

        verticalSpacer_3 = new QSpacerItem(20, 40, QSizePolicy::Policy::Minimum, QSizePolicy::Policy::Expanding);

        gridLayout_6->addItem(verticalSpacer_3, 1, 0, 1, 1);

        gridLayout_6->setRowStretch(0, 1);
        gridLayout_6->setRowStretch(1, 20);
        gridLayout_6->setColumnStretch(0, 1);
        gridLayout_6->setColumnStretch(1, 6);

        gridLayout_7->addLayout(gridLayout_6, 0, 0, 1, 1);

        stackedWidget->addWidget(page3);

        verticalLayout->addWidget(stackedWidget);

        verticalLayout->setStretch(0, 1);
        verticalLayout->setStretch(1, 11);

        gridLayout->addLayout(verticalLayout, 0, 0, 1, 1);

        MainWindow->setCentralWidget(centralwidget);

        retranslateUi(MainWindow);

        stackedWidget->setCurrentIndex(0);


        QMetaObject::connectSlotsByName(MainWindow);
    } // setupUi

    void retranslateUi(QMainWindow *MainWindow)
    {
        MainWindow->setWindowTitle(QCoreApplication::translate("MainWindow", "MainWindow", nullptr));
        textBrowser->setHtml(QCoreApplication::translate("MainWindow", "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\" \"http://www.w3.org/TR/REC-html40/strict.dtd\">\n"
"<html><head><meta name=\"qrichtext\" content=\"1\" /><meta charset=\"utf-8\" /><style type=\"text/css\">\n"
"p, li { white-space: pre-wrap; }\n"
"hr { height: 1px; border-width: 0; }\n"
"li.unchecked::marker { content: \"\\2610\"; }\n"
"li.checked::marker { content: \"\\2612\"; }\n"
"</style></head><body style=\" font-family:'Microsoft YaHei UI'; font-size:9pt; font-weight:400; font-style:normal;\">\n"
"<p align=\"center\" style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-size:28pt;\">MyApp</span></p></body></html>", nullptr));
        pushButton_6->setText(QCoreApplication::translate("MainWindow", "PushButton", nullptr));
        musicPlayer_page_2->setText(QCoreApplication::translate("MainWindow", "PushButton", nullptr));
        pushButton_7->setText(QCoreApplication::translate("MainWindow", "PushButton", nullptr));
        pushButton_9->setText(QCoreApplication::translate("MainWindow", "PushButton", nullptr));
        pushButton_8->setText(QCoreApplication::translate("MainWindow", "PushButton", nullptr));
        pushButton_3->setText(QCoreApplication::translate("MainWindow", "PushButton", nullptr));
        pushButton_4->setText(QCoreApplication::translate("MainWindow", "PushButton", nullptr));
        pushButton_5->setText(QCoreApplication::translate("MainWindow", "PushButton", nullptr));
        musicPlayer_page_1->setText(QCoreApplication::translate("MainWindow", "MusicPlayer", nullptr));
        back_musicPlayer->setText(QCoreApplication::translate("MainWindow", "back", nullptr));
        label->setText(QCoreApplication::translate("MainWindow", "0.00", nullptr));
        label_2->setText(QCoreApplication::translate("MainWindow", "0.00", nullptr));
        mode->setText(QCoreApplication::translate("MainWindow", "mode", nullptr));
        pre->setText(QCoreApplication::translate("MainWindow", "pre", nullptr));
        s_or_e->setText(QCoreApplication::translate("MainWindow", "start/end", nullptr));
        next->setText(QCoreApplication::translate("MainWindow", "next", nullptr));
        list->setText(QCoreApplication::translate("MainWindow", "list", nullptr));
        back_musicPlayer_2->setText(QCoreApplication::translate("MainWindow", "back", nullptr));
    } // retranslateUi

};

namespace Ui {
    class MainWindow: public Ui_MainWindow {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_MAINWINDOW_H
