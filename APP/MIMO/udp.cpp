#include "udp.h"
#include <QNetworkDatagram>

UDP::UDP(QObject *parent)
    : QObject{parent}
{
    startListening(12345);
}
UDP::~UDP(){
    stopListening();
}
bool UDP::startListening(int port)
{
    if (m_isListening) {
        return true;
    }

    m_socket = new QUdpSocket(this);

    // 监听端口
    if (!m_socket->bind(QHostAddress::Any, port)) {
        emit errorOccurred("监听端口失败 " + QString::number(port) + ": " + m_socket->errorString());
        delete m_socket;
        m_socket = nullptr;
        return false;
    }

    // 连接信号
    connect(m_socket, &QUdpSocket::readyRead, this, &UDP::onReadyRead);

    m_isListening = true;
    qDebug() << "UDP端口：" << port;
    return true;
}

void UDP::stopListening()
{
    if (m_socket) {
        m_socket->close();
        delete m_socket;
        m_socket = nullptr;
    }
    m_isListening = false;
}

void UDP::onReadyRead()
{
    while (m_socket && m_socket->hasPendingDatagrams()) {
        QNetworkDatagram datagram = m_socket->receiveDatagram();
        if (datagram.isValid()) {
            QByteArray data = datagram.data();
            if (!data.isEmpty()) {
                emit audioDataReceived(data);
                qDebug() << "接收到了UDP传输的数据, 大小:" << data.size();
            }
        }
    }
}
