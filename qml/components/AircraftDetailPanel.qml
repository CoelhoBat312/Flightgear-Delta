import QtQuick 2.15
Rectangle {
    id: root
    property string aircraftName: ""

    property bool opened: false

    color: "#ee1a1a1a"
    visible: opacity > 0
    opacity: 0

    Behavior on opacity {
        NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
    }

    onOpenedChanged: opacity = opened ? 1 : 0

    MouseArea {
        anchors.fill: parent
        onClicked: root.opened = false
    }

    Rectangle {
        id: panel
        width: 500
        height: 400
        radius: 12
        color: "#242424"
        anchors.centerIn: parent

        scale: root.opened ? 1.0 : 0.9
        Behavior on scale {
            NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
        }

        MouseArea { anchors.fill: parent }

        Flickable {
            anchors { fill: parent; margins: 24 }
            contentHeight: content.height
            clip: true
            boundsBehavior: Flickable.StopAtBounds

            Column {
                id: content
                width: parent.width
                spacing: 16

                property var metadata: launcher.aircraftMetadata(root.aircraftName)

                Image {
                    width: parent.width
                    height: 220
                    source: launcher.aircraftThumbnail(root.aircraftName)
                    fillMode: Image.PreserveAspectFit
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                }
                Text {
                    text: root.aircraftName
                    color: "#ffffff"
                    font.pixelSize: 20
                    font.weight: Font.Medium
                }
                Text {
                    visible: content.metadata.description !== ""
                    text: content.metadata.description
                    color: "#cccccc"
                    font.pixelSize: 13
                    wrapMode: Text.WordWrap
                    width: parent.width
                }
                Text {
                    visible: content.metadata.author !== ""
                    text: qsTr("Author: ") + content.metadata.author
                    color: "#888888"
                    font.pixelSize: 12
                    wrapMode: Text.WordWrap
                    width: parent.width
                }
                Row {
                    spacing: 2
                    Repeater {
                        model: 5
                        Text {
                            text: index < content.metadata.rating ? "★" : "☆"
                            color: "#ffcc00"
                            font.pixelSize: 16
                        }
                    }
                }
                Text {
                    text: "fg_root: " + launcher.fgRoot + "/Aircraft/" + root.aircraftName
                    color: "#666666"
                    font.pixelSize: 11
                    wrapMode: Text.WordWrap
                    width: parent.width
                }
            }
        }

        Text {
            anchors { top: parent.top; right: parent.right; margins: 16 }
            text: "✕"
            color: "#888888"
            font.pixelSize: 16
            MouseArea {
                anchors.fill: parent
                onClicked: root.opened = false
                cursorShape: Qt.PointingHandCursor
            }
        }
    }
}
