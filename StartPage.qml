import QtQuick

Rectangle {
    anchors.fill: parent
    id: startPage
    signal clicked()

    Rectangle{
        id: startButton
        anchors.centerIn: parent

        width: 50
        height: 30

        color: "#808080"

        Text{
            text:qsTr("Start")
            anchors.centerIn: parent
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                startPage.clicked();
            }
        }
    }
}

