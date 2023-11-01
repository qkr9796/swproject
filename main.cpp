#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQMlContext>

#include "game/tilecontrol.h"
#include "connection/client.h"


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    //tileControl tilecontrol;
    //engine.rootContext()->setContextProperty("tileControl", &tilecontrol);
    qmlRegisterType<TileControl>("TileControl",1,0,"TileControl");
    qmlRegisterType<Client>("Client", 1, 0, "Client");


    const QUrl url(u"qrc:/swproject/Main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
