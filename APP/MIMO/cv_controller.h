// #ifndef CV_CONTROLLER_H
// #define CV_CONTROLLER_H

// #include <QObject>

// #include "opencv2/opencv.hpp"
// #include "opencv2/core/core.hpp"
// #include "opencv2/highgui/highgui.hpp"
// #include <QTimer>
// #include <QQuickImageProvider>

// using namespace cv;
// using namespace std;

// class cv_controller : public QObject
// {
//     Q_OBJECT
// public:
//     explicit cv_controller(QObject *parent = nullptr);

//     QImage MatImageToQt(const Mat& src);

// private:

//     VideoCapture cap;
//     Mat src_image;
//     QTimer* timer;
//     QImage* image;

// signals:
//     void closeOk(QString clocam);
//     void openOk(QString clocam);
//     void currentImage(QImage imag);

// public slots:
//     void readFarme();
//     void OpenCamera();
//     void CloseCamera();
// };

// #endif // CV_CONTROLLER_H
