/********************************************************************************
** Form generated from reading UI file 'error.ui'
**
** Created by: Qt User Interface Compiler version 6.8.0
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_ERROR_H
#define UI_ERROR_H

#include <QtCore/QVariant>
#include <QtWidgets/QApplication>
#include <QtWidgets/QGridLayout>
#include <QtWidgets/QLabel>
#include <QtWidgets/QPushButton>
#include <QtWidgets/QSpacerItem>
#include <QtWidgets/QVBoxLayout>
#include <QtWidgets/QWidget>

QT_BEGIN_NAMESPACE

class Ui_error
{
public:
    QGridLayout *gridLayout;
    QVBoxLayout *verticalLayout;
    QLabel *message;
    QPushButton *retry;
    QSpacerItem *horizontalSpacer_2;
    QSpacerItem *horizontalSpacer;
    QSpacerItem *verticalSpacer;
    QSpacerItem *verticalSpacer_2;

    void setupUi(QWidget *error)
    {
        if (error->objectName().isEmpty())
            error->setObjectName("error");
        error->resize(360, 480);
        gridLayout = new QGridLayout(error);
        gridLayout->setSpacing(0);
        gridLayout->setObjectName("gridLayout");
        gridLayout->setContentsMargins(0, 0, 0, 0);
        verticalLayout = new QVBoxLayout();
        verticalLayout->setObjectName("verticalLayout");
        message = new QLabel(error);
        message->setObjectName("message");
        QFont font;
        font.setPointSize(15);
        message->setFont(font);
        message->setAlignment(Qt::AlignmentFlag::AlignCenter);

        verticalLayout->addWidget(message);

        retry = new QPushButton(error);
        retry->setObjectName("retry");
        retry->setEnabled(true);
        retry->setFont(font);

        verticalLayout->addWidget(retry);


        gridLayout->addLayout(verticalLayout, 1, 1, 1, 1);

        horizontalSpacer_2 = new QSpacerItem(40, 20, QSizePolicy::Policy::Expanding, QSizePolicy::Policy::Minimum);

        gridLayout->addItem(horizontalSpacer_2, 1, 2, 1, 1);

        horizontalSpacer = new QSpacerItem(40, 20, QSizePolicy::Policy::Expanding, QSizePolicy::Policy::Minimum);

        gridLayout->addItem(horizontalSpacer, 1, 0, 1, 1);

        verticalSpacer = new QSpacerItem(20, 40, QSizePolicy::Policy::Minimum, QSizePolicy::Policy::Expanding);

        gridLayout->addItem(verticalSpacer, 2, 1, 1, 1);

        verticalSpacer_2 = new QSpacerItem(20, 40, QSizePolicy::Policy::Minimum, QSizePolicy::Policy::Expanding);

        gridLayout->addItem(verticalSpacer_2, 0, 1, 1, 1);

        gridLayout->setRowStretch(0, 1);
        gridLayout->setRowStretch(1, 2);
        gridLayout->setRowStretch(2, 1);
        gridLayout->setColumnStretch(0, 1);
        gridLayout->setColumnStretch(1, 2);
        gridLayout->setColumnStretch(2, 1);

        retranslateUi(error);

        QMetaObject::connectSlotsByName(error);
    } // setupUi

    void retranslateUi(QWidget *error)
    {
        error->setWindowTitle(QCoreApplication::translate("error", "Form", nullptr));
        message->setText(QCoreApplication::translate("error", "TextLabel", nullptr));
        retry->setText(QCoreApplication::translate("error", "retry", nullptr));
    } // retranslateUi

};

namespace Ui {
    class error: public Ui_error {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_ERROR_H
