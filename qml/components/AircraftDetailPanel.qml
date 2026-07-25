import QtQuick 2.15

import "qrc:/qml/"

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
        width: parent.width *0.4
        height: Math.min(parent.height *0.8, (content.height + 50))
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
                    visible: content.metadata.previews.length === 0
                    height: 220
                    source: launcher.aircraftThumbnail(root.aircraftName)
                    fillMode: Image.PreserveAspectFit
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                }

                ImagesCarousel {
                    visible: content.metadata.previews.length !== 0
                    images: content.metadata.previews
                }

                Text {
                    text: content.metadata.description
                    color: "#ffffff"
                    font.pixelSize: 20
                    font.weight: Font.Medium
                }
                Text {
                    visible: content.metadata.author !== ""
                    text: qsTr("Author: ") + content.metadata.author
                    color: "#888888"
                    font.pixelSize: 12
                    wrapMode: Text.WordWrap
                    width: parent.width
                }
                Text {
                    visible: content.metadata.long_description !== ""
                    text: content.metadata.long_description
                    color: "#cccccc"
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
                    text: qsTr("Set file location: ") + launcher.fgRoot + "/Aircraft/" + root.aircraftName + "/" + content.metadata.source
                    color: "#666666"
                    font.pixelSize: 10
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
                cursorShape: Qt.PointingHandCursor
                onClicked: root.opened = false
            }
        }

        Rectangle {
            anchors { bottom: parent.bottom; right: parent.right; margins: 16 }

            width: 50
            height: 20

            color: "#555555"
            radius: 5

            Text {
                text: qsTr("Select")
                color: "#cccccc"
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: { AppState.launchStack.push("qrc:/qml/pages/LaunchSubPages/AircraftTypes.qml") }
            }
        }
    }
}
