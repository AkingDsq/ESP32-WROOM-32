// #include "cv_controller.h"
// #include <QImage>
// #include <QDebug>
// #include <opencv2/opencv.hpp>


// cv_controller::cv_controller(QObject *parent)
//     : QObject{parent}
// {

//     timer = new QTimer(this);
//     image = new QImage();
//     connect(timer, SIGNAL(timeout()), this, SLOT(readFarme()));
// }
// void cv_controller::OpenCamera() {
//     cap.open(0); // 打开摄像头
//     if (!cap.isOpened()) {
//         qDebug() << "open camera failed";
//         return;
//     }
//     timer->start(33);
//     emit openOk("open ok");
// }
// void cv_controller::CloseCamera() {
//     // 停止读取数据。
//     timer->stop();
//     if(cap.isOpened())
//     {
//         cap.release();
//     }
//     emit closeOk("close ok");
// }
// void cv_controller::readFarme()
// {
//     cap.read(src_image);
//     cv::Mat gray;
//     cv::cvtColor(src_image, gray, cv::COLOR_BGR2GRAY);

//     // 加载分类器
//     cv::CascadeClassifier faceCascade;
//     faceCascade.load("./opencv4.10/sources/data/haarcascades/haarcascade_frontalface_default.xml");
//     cv::CascadeClassifier smile;
//     smile.load("./opencv4.10/sources/data/haarcascades/haarcascade_smile.xml");

//     std::vector<cv::Rect> faces;
//     faceCascade.detectMultiScale(gray, faces, 1.05, 40, 0, cv::Size(10, 10));
//     qDebug() << "发现"  << faces.size() << "张人脸!";
//     qDebug() << "其位置分别是:", faces;

//     // 绘制人脸矩形框
//     for (auto face : faces) {
//         // face包含(x, y, w, h)信息
//         cv::rectangle(src_image, cv::Point(face.x, face.y), cv::Point(face.x + face.width, face.y + face.height), cv::Scalar(0, 255, 0), 2);

//         cv::Mat roi_gray_face = gray(cv::Rect(face.x, face.y, face.width, face.height));
//         std::vector<cv::Rect> smiles;
//         smile.detectMultiScale(roi_gray_face, smiles, 1.5, 15, 0, cv::Size(50, 50));

//         for (const auto& smile : smiles) {
//             // 使用putText绘制文字，显示文字"smile"表示微笑了
//             cv::putText(src_image, "smile", cv::Point(smile.x, smile.y), cv::FONT_HERSHEY_COMPLEX_SMALL, 1, cv::Scalar(0, 255, 255), 2);
//         }

//         int key = cv::waitKey(5);
//         if (key == 27) {
//             // 退出
//             break;
//         }
//     }
//     QImage imag = MatImageToQt(src_image);
//     if (imag.isNull()) qDebug() << "read frame not ok";

//     //显示图像
//     emit currentImage(imag);
// }

// //Mat转成QImage
// QImage cv_controller::MatImageToQt(const Mat& src)
// {
//     //CV_8UC1 8位无符号的单通道---灰度图片
//     if (src.type() == CV_8UC1)
//     {
//         //使用给定的大小和格式构造图像
//         //QImage(int width, int height, Format format)
//         QImage qImage(src.cols, src.rows, QImage::Format_Indexed8);
//         //扩展颜色表的颜色数目
//         qImage.setColorCount(256);

//         //在给定的索引设置颜色
//         for (int i = 0; i < 256; i++)
//         {
//             //得到一个黑白图
//             qImage.setColor(i, qRgb(i, i, i));
//         }
//         //复制输入图像,data数据段的首地址
//         uchar* pSrc = src.data;
//         //
//         for (int row = 0; row < src.rows; row++)
//         {
//             //遍历像素指针
//             uchar* pDest = qImage.scanLine(row);
//             //从源src所指的内存地址的起始位置开始拷贝n个
//             //字节到目标dest所指的内存地址的起始位置中
//             memcmp(pDest, pSrc, src.cols);
//             //图像层像素地址
//             pSrc += src.step;
//         }
//         return qImage;
//     }
//     //为3通道的彩色图片
//     else if (src.type() == CV_8UC3)
//     {
//         //得到图像的的首地址
//         const uchar* pSrc = (const uchar*)src.data;
//         //以src构造图片
//         QImage qImage(pSrc, src.cols, src.rows, src.step, QImage::Format_RGB888);
//         //在不改变实际图像数据的条件下，交换红蓝通道
//         return qImage.rgbSwapped();
//     }
//     //四通道图片，带Alpha通道的RGB彩色图像
//     else if (src.type() == CV_8UC4)
//     {
//         const uchar* pSrc = (const uchar*)src.data;
//         QImage qImage(pSrc, src.cols, src.rows, src.step, QImage::Format_ARGB32);
//         //返回图像的子区域作为一个新图像
//         return qImage.copy();
//     }
//     else
//     {
//         return QImage();
//     }
// }
