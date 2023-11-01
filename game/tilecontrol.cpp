#include "tilecontrol.h"
#include <iostream>

using namespace std;


TileControl::TileControl(QObject *parent)
    : QObject{parent}
{
    tileStruct tilestruct;

    for (int i = 0; i < 48; i++){
        tilestruct.visualIndex = i;
        tilestruct.type = i % 4;
        tilestruct.color = colors[tilestruct.type];
        tiles.append(tilestruct);

        tileVisualIndex[i/8][i%8] = i;
    }

    for (int i = 0; i < 6; i++){
        for (int j = 0 ; j < 8; j++){
            removeTable[i][j] = 0;
            tileVisualIndex[i][j] = 0;
        }
    }
    for (int i = 0; i < 7; i++){
        for (int j = 0 ; j < 9; j++){
            tileVisualType[i][j] = -1;
        }
    }

    for (int i = 0; i < 4; i ++){
        scores.append(0);
    }

    //removeTable[0][1] = 1;
    //removeTable[0][2] = 1;
    //removeTable[1][1] = 1;
    //removeTable[4][2] = 1;
    //removeTable[3][3] = 1;

}

TileControl::~TileControl(){

}

QList<tileStruct> TileControl::tileCreate(){
    tileShuffle();
    return tiles;
}

QList<tileStruct> TileControl::tileProcess(QVariantMap param){
    for(int i = 0; i < tiles.length(); i++){
        tiles[i].visualIndex = param[QString::number(i)].toMap()["visualIndex"].toInt();
        tileVisualIndex[tiles[i].visualIndex/8][tiles[i].visualIndex%8] = i;
        tileVisualType[tiles[i].visualIndex/8][tiles[i].visualIndex%8] = tiles[i].type;
    }
/*
    for(int i = 0; i < 7; i++){
        for (int j = 0; j < 9; j++){
            cout<< tileVisualType[i][j]<<" ";
        }
        cout<<endl;
    }
    cout <<"-----visual------"<<endl;*/


    calcRemoveTable();

/*
    for(int i = 0; i < 6; i++){
        for (int j = 0; j < 8; j++){
            cout<< removeTable[i][j]<<" ";
        }
        cout<<endl;
    }
    cout <<"------remove------"<<endl << endl;*/


    int countColumn[8] = {0,};

    for(int i = 0; i < 6; i++){
        for (int j = 0 ; j < 8; j++){
            if(removeTable[i][j]){
                removeTable[i][j] = 0;
                countColumn[j] += 1;
                tiles[tileVisualIndex[i][j]].visualIndex = - 8 * countColumn[j] + j;
                tiles[tileVisualIndex[i][j]].type = rand() % 4;
                tiles[tileVisualIndex[i][j]].color = colors[tiles[tileVisualIndex[i][j]].type];

            }
        }
    }


    return tiles;
}

QList<tileStruct> TileControl::tileShuffle(){
    tiles.clear();
    tileStruct tilestruct;
    QColor colors[4] = {QColor("blue"), QColor("green"), QColor("yellow"), QColor("red")};
    for (int i = 0; i < 48; i++){
        tilestruct.visualIndex = i;
        tilestruct.type = rand() % 4;
        tilestruct.color = colors[tilestruct.type];
        tiles.append(tilestruct);
    }

    return tiles;
}

void TileControl::calcRemoveTable(){

    //cout<<"calcremovetable"<<endl;

    int count = 0;
    int value = -1;

    //horizontal
    for(int i = 0; i < 6; i++){
        count = 1;
        value = -1;
        for (int j = 0 ; j < 9; j++){
            if (value == tileVisualType[i][j]){
                count += 1;
            } else if(count >= 3){
                scores[value] += count;
                for(int k = 1 ; k <= count; k++){
                    removeTable[i][j-k] = 1;
                }
                count = 1;
            } else {
                count = 1;
            }
            value = tileVisualType[i][j];
        }
    }

    //vertical
    for(int j = 0; j < 8; j++){
        count = 1;
        value = -1;
        for (int i = 0 ; i < 7; i++){
            if (value == tileVisualType[i][j]){
                count += 1;
            } else if(count >= 3){
                scores[value] += count;
                for(int k = 1 ; k <= count; k++){
                    removeTable[i-k][j] = 1;
                }
                count = 1;
            } else {
                count = 1;
            }
            value = tileVisualType[i][j];
        }
    }
}




