import QtQuick
import QtQuick.Window

import "game"

Window {
    id: viewer
    width: 800
    height: 800
    visible: true
    title: qsTr("swproject")

    Component {
        id: startPage
        StartPage {
            onClicked: { loader.sourceComponent = searchPage }
        }
    }

    Component {
        id: searchPage
        SearchPage{
            onEnterRoom: function(idx) {
                console.log(idx)
                loader.sourceComponent = gamePage
            }
        }
    }

    Component {
        id: gamePage
        GamePage{

        }
    }

    Loader {
        id: loader
        anchors.fill: parent
        sourceComponent: startPage
    }
}
