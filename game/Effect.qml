import QtQuick


Rectangle{
    id: effect

    width: 40
    height: 40
    radius: width/3

    anchors.centerIn: parent

    color: "#000000"

    signal start()
    onStart: function() { effectAnim.start() }

    visible: false

    ParallelAnimation  {
        id: effectAnim
        PropertyAnimation {
            target: effect
            property: "width"
            from: 40
            to: 45
            duration: 200
        }
        PropertyAnimation {
            target: effect
            property: "height"
            from: 40
            to: 45
            duration: 200
        }
        OpacityAnimator{
            target: effect
            from: 1.0
            to: 0.2
            duration: 200
        }

        onStarted: effect.visible = true
        onFinished: effect.visible = false
    }

}
