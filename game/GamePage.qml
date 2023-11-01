import QtQuick
import QtQuick.Layouts

import TileControl 1.0

Rectangle {
    id: gamePage
    anchors.fill: parent

    signal gameEnd()

    TileControl{
        id: tileControl
    }

    Rectangle{
        id: upperArea
        width: 500
        height: 400

        anchors.bottom: gameView.top
        anchors.horizontalCenter: gameView.horizontalCenter
        color: "#FFFFFF"

        visible: true

        function setScores(){
            var scoretypes = ["blue", "green", "yellow", "red"]
            for(var i = 0; i < 4; i++){
                scores.itemAt(i).text = scoretypes[i] + ": " + tileControl.scores[i]
            }
        }

        z:1

        Column {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10

            Repeater {
                id: scores
                model: 4
                Text {
                    color: "#000000"
                    text: "0"
                }
            }
        }
    }

    Rectangle{
        id: gameView

        property list<Tile> tiles
        //property list<int> tileRoots
        //property list<int> tileTypes
        //property list<color> tileColors

        property list<Effect> effects

        property list<int> xs
        property list<int> ys
        property list<int> hidden_xs
        property list<int> hidden_ys

        property bool updating: false
        property bool repositioning: false

        property int currIndex: 0     

        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 50

        width: 420
        height: 320

        border.color: "#000000"
        color: "#d0d0d0"

        GridLayout {
            id: dropAreaRoot
            anchors.margins: 10
            anchors.fill: parent

            columns: 8
            rows: 6
            columnSpacing: 0
            rowSpacing: 0

            Repeater {
                id: tileRoot
                model: 48
                delegate: DropArea {
                    required property int index
                    property int tileIndex

                    width: 50
                    height: 50
/*
                    Text {
                        color: "#000000"
                        anchors.top: parent.top
                        text: tileIndex
                    }*/

                    onEntered: function(drag){
                        if(index === drag.source.visualIndex) return
                        //console.log(index)
                        gameView.tiles[tileIndex].targetx = gameView.xs[drag.source.visualIndex]
                        gameView.tiles[tileIndex].targety = gameView.ys[drag.source.visualIndex]
                        gameView.tiles[tileIndex].start()
                        gameView.tiles[tileIndex].visualIndex = drag.source.visualIndex
                        tileRoot.itemAt(drag.source.visualIndex).tileIndex = tileIndex
                        tileIndex = drag.source.tileIndex
                        drag.source.visualIndex = index
                    }
                }
            }
        }

        GridLayout {
            id: hiddenTileArea
            anchors.bottom: dropAreaRoot.top
            anchors.bottomMargin: 10
            anchors.horizontalCenter: dropAreaRoot.horizontalCenter
            visible: false

            columns: 8
            rows: 6
            columnSpacing: 0
            rowSpacing: 0

            Repeater {
                id: hiddenTileRoot
                model: 48
                Item {
                    required property int index
                    property int tileIndex
                    width: 50
                    height: 50
                    Rectangle {
                        anchors.fill:parent
                        color: "#50000000"
                    }
                }
            }

        }

        function delay(time, func){
            var timer = Qt.createQmlObject("import QtQuick ; Timer {}", gameView)
            timer.interval = time
            timer.repeat = false
            timer.triggered.connect(() => { func(); timer.destroy() })
            timer.start()
        }

        Component.onCompleted: function(){
            var list = tileControl.tileCreate()

            for(var i = 0; i<list.length; i++){
                gameView.xs[i] = tileRoot.itemAt(i).mapToItem(gameView, 0, 0).x + 5
                gameView.ys[i] = tileRoot.itemAt(i).mapToItem(gameView, 0, 0).y + 5
                gameView.hidden_xs[i] = hiddenTileRoot.itemAt(i).mapToItem(gameView, 0, 0).x + 5
                gameView.hidden_ys[i] = hiddenTileRoot.itemAt(i).mapToItem(gameView, 0, 0).y + 5
            }

            var component = Qt.createComponent("Effect.qml")
            var temp = []
            var effects = []

            for (i = 0; i<list.length; i++){
                temp[i] = component.createObject(tileRoot.itemAt(i))
            }
            gameView.effects = temp

            component = Qt.createComponent("Tile.qml")

            for (i = 0; i<list.length; i++){
                //gameView.tileRoots[i] = list[i].root
                //gameView.tileTypes[i] = list[i].type
                //gameView.tileColors[i] = list[i].color
                temp[i] = component.createObject(gameView, {type: list[i].type,
                                                    color: list[i].color,
                                                    tileIndex: i,
                                                    visualIndex: i,
                                                    x: xs[i],
                                                    y: ys[i]})
                tileRoot.itemAt(i).tileIndex = i
            }
            gameView.tiles = temp
        }

        function process(){
            //console.log("processCall")
            gameView.updating = true
            var param = []
            for (var i = 0; i < gameView.tiles.length; i++){
                param[i] = { visualIndex: gameView.tiles[i].visualIndex,
                    type: gameView.tiles[i].type,
                    color: gameView.tiles[i].color
                }
                gameView.effects[param[i].visualIndex].color = param[i].color
            }

            var list = tileControl.tileProcess(param)
            for (i = 0; i < gameView.tiles.length; i++){
                //gameView.tileRoots[i] = list[i].root
                gameView.tiles[i].visualIndex = list[i].visualIndex
                gameView.tiles[i].type = list[i].type
                gameView.tiles[i].color = list[i].color
                //gameView.tileTypes[i] = list[i].type
                //gameView.tileColors[i] = list[i].color
            }

            gameView.update()
        }

        function update(){
            //console.log("updateCall")
            for (var i = 0; i < gameView.tiles.length; i++){
                tileRoot.itemAt(i).tileIndex = -1
                hiddenTileRoot.itemAt(i).tileIndex = -1

            }

            var repositionflag = false
            for (i = 0; i < gameView.tiles.length; i++){
                //if(gameView.tileRoots[i] >= 0){
                if(gameView.tiles[i].visualIndex >= 0) {
                    gameView.tiles[i].targetx = gameView.xs[gameView.tiles[i].visualIndex];
                    gameView.tiles[i].targety = gameView.ys[gameView.tiles[i].visualIndex];
                    gameView.tiles[i].start()
                    tileRoot.itemAt(gameView.tiles[i].visualIndex).tileIndex = i

                } else {
                    repositionflag = true
                    gameView.tiles[i].x = gameView.hidden_xs[gameView.tiles[i].visualIndex + 48];
                    gameView.tiles[i].y = gameView.hidden_ys[gameView.tiles[i].visualIndex + 48];
                    hiddenTileRoot.itemAt(gameView.tiles[i].visualIndex + 48).tileIndex = i
                }
                //gameView.tiles[i].visualIndex = gameView.tileRoots[i]
                //gameView.tiles[i].type = gameView.tileTypes[i]
               // gameView.tiles[i].color = gameView.tileColors[i]
            }

            for (i = 0; i < gameView.tiles.length; i++){
                if(tileRoot.itemAt(i).tileIndex === -1)
                    gameView.effects[i].start()
            }
            upperArea.setScores()

            if(repositionflag){
                gameView.repositioning = true
                delay(250, gameView.reposition)
            } else {
                if(!gameView.repositioning)
                    gameView.updating = false
                gameView.repositioning = false
            }
        }

        function reposition(){
            //console.log("reposition")
            for (var i = 47; i >=0; i--){
                var container = tileRoot.itemAt(i)
                if(container.tileIndex === -1){
                    for(var j = i; j >= -48; j-=8){
                        if(j >= 0 && tileRoot.itemAt(j).tileIndex !== -1){
                            gameView.tiles[tileRoot.itemAt(j).tileIndex].visualIndex += 8
                        }else if (j < 0 && hiddenTileRoot.itemAt(j+48).tileIndex !== -1){
                            gameView.tiles[hiddenTileRoot.itemAt(j+48).tileIndex].visualIndex += 8
                        }
                    }
                }
            }
            gameView.update()
            delay(60, gameView.process)
        }
    }
}
