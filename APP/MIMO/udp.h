#ifndef UDP_H
#define UDP_H

#include <QObject>
#include <QUdpSocket>
#include <QByteArray>
#include <QTimer>

/******************************************************************************
 *
 * @file       udp.h
 * @brief      udp网络协议，传输音频数据
 *
 * @author     dsq
 * @date       2025/05/08
 * @history
 *****************************************************************************/

class UDP : public QObject
{
    Q_OBJECT
public:
    explicit UDP(QObject *parent = nullptr);
    ~UDP();

    bool startListening(int port = 12345); // 开始监听
    void stopListening();                  // 停止
    bool isListening() const { return m_isListening; }
private slots:
    void onReadyRead();

private:
    QUdpSocket *m_socket = nullptr;
    bool m_isListening = false;
    QByteArray m_dataBuffer;

public slots:


signals:
    void audioDataReceived(QByteArray data);
    void errorOccurred(QString errorMessage);

};

#endif // UDP_H
