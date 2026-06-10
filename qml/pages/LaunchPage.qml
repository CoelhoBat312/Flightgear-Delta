import QtQuick 2.15
import QtQuick.Controls 2.15

import "./LaunchSubPages"

Rectangle {
    anchors.fill: parent
    color: "transparent"

    Text {
        anchors.centerIn: parent
        text: "Launch"
        color: "#ffffff"
        font.pixelSize: 14
    }

    StackView {
        id: stack_launch
        anchors {
            top: topbar.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            topMargin: 12
        }
        initialItem: "qrc:/qml/pages/LaunchSubPages/Aircrafts.qml"
    }
}
