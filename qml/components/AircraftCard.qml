import QtQuick 2.15

Rectangle {
    property string aircraftName: ""
    property string thumbnailSource: ""
    signal clicked()

    width: 180
    height: 220
    radius: 8
    color: "#242424"
    clip: true

    Image {
        anchors.fill: parent
        source: thumbnailSource
        fillMode: Image.PreserveAspectCrop
    }

    // затемнение снизу
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.4; color: "transparent" }
            GradientStop { position: 1.0; color: "#dd000000" }
        }
    }

    Text {
        anchors {
            bottom: parent.bottom
            left: parent.left
            bottomMargin: 12
            leftMargin: 12
        }
        text: aircraftName
        color: "#ffffff"
        font.pixelSize: 13
        font.weight: Font.Medium
    }

    // hover эффект
    Rectangle {
        anchors.fill: parent
        radius: parent.radius
        color: "#22ffffff"
        opacity: 0
        id: hoverOverlay

        Behavior on opacity {
            NumberAnimation { duration: 150 }
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: hoverOverlay.opacity = 1
        onExited:  hoverOverlay.opacity = 0
        onClicked: parent.clicked()
    }
}
