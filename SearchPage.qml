import QtQuick

Rectangle {
    id: searchPage
    anchors.fill: parent

    signal enterRoom(int idx)

    Rectangle{
        anchors.centerIn: parent
        border.color: "#000000"

        width: parent.width*0.8
        height: parent.height*0.8

        ListModel{
            id:listModel
            ListElement {
                name: "first"
            }
            ListElement {
                name: "second"
            }
            ListElement{
                name: "third"
            }
        }

        Component {
            id:listDelegate
            Item{
                width: parent.width
                height: 40

                Text {
                    anchors.fill: parent
                    text: 'name: ' + name + ', index: ' + index
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: { searchPage.enterRoom(index);
                        listView.currentIndex = index;
                    }
                }

            }
        }

        Component {
            id: listHighlight
            Rectangle{
                color: "#808080"
            }
        }

        ListView{
            id: listView
            anchors.fill: parent
            anchors.margins: 10

            model: listModel
            delegate: listDelegate
            highlight: listHighlight
            focus: true
        }
    }
}
