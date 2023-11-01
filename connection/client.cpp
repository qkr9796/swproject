#include "client.h"

#include <iostream>

Client::Client(QObject *parent)
    : QObject{parent}

{

    tcpSocket = new QTcpSocket(this);

    connect(tcpSocket, &QIODevice::readyRead, this, &Client::readLine);
    connect(tcpSocket, &QAbstractSocket::errorOccurred, this, &Client::logError);

}

Client::~Client(){

}

void Client::connectServer(){
    in.setDevice(tcpSocket);

    tcpSocket->connectToHost(serverAddr, serverPort);
}

void Client::readLine(){

    std::cout << "readyRead" << std::endl;

    in.startTransaction();

    QString dataIn;
    QString dataIn2;
    //dataIn = tcpSocket->readAll();
    //QByteArray dataIn;
    in >> dataIn >> dataIn2;

    if (!in.commitTransaction())
        return;

    currentData = dataIn2;
    std::cout << currentData.toStdString() << std::endl;

}

void Client::logError(QAbstractSocket::SocketError socketError){
    {
        switch (socketError) {
        case QAbstractSocket::RemoteHostClosedError:
            std::cout << "Remot host closed" << std::endl;
            break;
        case QAbstractSocket::HostNotFoundError:
            std::cout << "host not found" << std::endl;
            break;
        case QAbstractSocket::ConnectionRefusedError:
            std::cout << "Connection Refused" << std::endl;
            break;
        default:
            std::cout << tcpSocket->errorString().toStdString() <<std::endl;
        }
    }
}
