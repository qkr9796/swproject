#ifndef CLIENT_H
#define CLIENT_H

#include <QObject>
#include <QTcpSocket>

class Client : public QObject
{
    Q_OBJECT

public:
    explicit Client(QObject *parent = nullptr);
    ~Client();

    Q_INVOKABLE void connectServer();
    void readLine();
    void logError(QAbstractSocket::SocketError socketError);


private:
    const QString serverAddr = "127.0.0.1";
    const int serverPort = 7777 ;
    QTcpSocket *tcpSocket = nullptr;
    QDataStream in;
    QString currentData;
};

#endif // CLIENT_H
