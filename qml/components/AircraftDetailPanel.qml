import QtQuick 2.15

Rectangle {
    property string aircraftName: ""

    color: "#ee1a1a1a"

    // закрыть по клику на фон
    MouseArea {
        anchors.fill: parent
        onClicked: parent.visible = false
    }

    Rectangle {
        width: 500
        height: 400
        radius: 12
        color: "#242424"
        anchors.centerIn: parent

        // чтобы клик по панели не закрывал её
        MouseArea { anchors.fill: parent }

        Column {
            anchors {
                fill: parent
                margins: 24
            }
            spacing: 16

            Image {
                width: parent.width
                height: 220
                source: launcher.aircraftThumbnail(aircraftName)
                fillMode: Image.PreserveAspectCrop
            }

            Text {
                text: aircraftName
                color: "#ffffff"
                font.pixelSize: 20
                font.weight: Font.Medium
            }

            Text {
                text: "fg_root: " + launcher.fgRoot + "/Aircraft/" + aircraftName
                color: "#888888"
                font.pixelSize: 12
            }
        }

        // кнопка закрыть
        Text {
            anchors {
                top: parent.top
                right: parent.right
                margins: 16
            }
            text: "✕"
            color: "#888888"
            font.pixelSize: 16

            MouseArea {
                anchors.fill: parent
                onClicked: detailPanel.visible = false
            }
        }
    }
}
