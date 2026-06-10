import QtQuick 2.15

Rectangle {
    property string label: ""

    property bool hovered: false
    signal clicked()

    implicitWidth: btnText.implicitWidth + 24
    height: 32
    radius: 4
    color: hovered ? "#2a2a2a" : "transparent"

    Behavior on color {
        ColorAnimation { duration: 300 }
    }

    Text {
        id: btnText
        anchors.centerIn: parent
        text: label
        color: hovered ? "#ffffff" : "#aaaaaa"
        font.pixelSize: 13

        Behavior on color {
            ColorAnimation { duration: 300 }
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: hovered = true
        onExited:  hovered = false
        onClicked: parent.clicked()
    }
}
