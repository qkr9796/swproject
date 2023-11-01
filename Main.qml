import QtQuick
import QtQuick.Window

import "game"
import Client 1.0

Window {
    id: viewer
    width: 800
    height: 800
    visible: true
    title: qsTr("swproject")

    Client {
        id: client
    }

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
                if(idx === 1){
                    client.connectServer()
                    return;
                }

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
