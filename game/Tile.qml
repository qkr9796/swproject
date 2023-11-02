import QtQuick


Rectangle {
    //required property Item dragParent

    //required property int sourceParent
    required property int visualIndex

    required property int type
    required property int tileIndex

    property int targetx
    property int targety

    id: tile
    width: 40
    height: 40

    signal start()
    onStart: function() { moveAnim.stop(); moveAnim.start() }
    //x:5
    //y:5

    //anchors.centerIn: parent

    border.width: 0

    radius: width/3


    Drag.active: dragArea.drag.active
    Drag.source: tile
    Drag.hotSpot.x: width / 2
    Drag.hotSpot.y: height / 2
/*
    Text {
        text: tile.tileIndex
        color: "#000000"
        anchors.bottom: parent.bottom
    }*/

    ParallelAnimation{
        id:moveAnim
        PropertyAnimation{
            id: moveAnimx
            target: tile
            property: "x"
            to: tile.targetx
            duration: 50
        }
        PropertyAnimation{
            id: moveAnimy
            target: tile
            property: "y"
            to: tile.targety
            duration: 50
        }
    }

    MouseArea {
        id: dragArea
        anchors.fill: parent
        drag.target: parent

        enabled: !gameView.updating

        drag.minimumX: 5
        drag.maximumX: tile.parent.width - tile.width - 5
        drag.minimumY: 5
        drag.maximumY: tile.parent.height - tile.height - 5

        onPressed: function(){
            if (moveAnim.running){
                moveAnim.stop()
            }
            //gameView.currIndex = tile.sourceParent
            tile.border.width = 2
            //tile.anchors.centerIn = undefined
            //tile.parent.z = 99
            tile.z = 99
            dragTimer.tile = tile
            dragTimer.num = 4
            dragTimer.start()

            //dragArea.drag.minimumX = tile.mapFromItem(tile.dragParent, 0, 0).x + 5
            //dragArea.drag.maximumX = tile.mapFromItem(tile.dragParent, 0, 0).x + tile.dragParent.width - tile.width + 5
            //dragArea.drag.minimumY = tile.mapFromItem(tile.dragParent, 0, 0).y + 5
            //dragArea.drag.maximumY = tile.mapFromItem(tile.dragParent, 0, 0).y + tile.dragParent.height - tile.height + 5
        }

        onReleased: function() {

            //tile.sourceParent = gameView.currIndex
            //tile.parent = tileRoot.itemAt(sourceParent)
            //tile.anchors.centerIn = tile.parent
            dragTimer.stop();

            tile.x = gameView.xs[visualIndex]
            tile.y = gameView.ys[visualIndex]
            tile.border.width = 0
            //tile.parent.z = 0
            tile.z = 0

            gameView.process()
        }

    }

}

