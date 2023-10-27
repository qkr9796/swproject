#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQMlContext>

#include "game/tilecontrol.h"


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    tileControl tilecontrol;
    engine.rootContext()->setContextProperty("tileControl", &tilecontrol);


    const QUrl url(u"qrc:/swproject/Main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
