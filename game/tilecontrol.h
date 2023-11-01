#ifndef TILECONTROL_H
#define TILECONTROL_H

#include <QObject>
#include <QColor>
#include <QVariantMap>


using namespace std;

struct tileStruct {
    Q_GADGET
public:
    int visualIndex;
    int type;
    QColor color;
    Q_PROPERTY(int visualIndex MEMBER visualIndex)
    Q_PROPERTY(int type MEMBER type)
    Q_PROPERTY(QColor color MEMBER color)
};

class TileControl : public QObject
{
    Q_OBJECT

public:
    Q_PROPERTY(QList<int> scores MEMBER scores)

private:
    QColor colors[4] = {QColor("blue"), QColor("green"), QColor("yellow"), QColor("red")};
    QList<tileStruct> tiles;
    int tileVisualIndex[6][8];
    int tileVisualType[7][9];
    int removeTable[6][8];

    QList<int> scores;


public:
    explicit TileControl(QObject *parent = nullptr);
    ~TileControl();

    Q_INVOKABLE QList<tileStruct> tileProcess(QVariantMap param);
    Q_INVOKABLE QList<tileStruct> tileCreate();

private:
    QList<tileStruct> tileShuffle();
    void calcRemoveTable();




signals:
    void changedTiles();

};

#endif // TILECONTROL_H
