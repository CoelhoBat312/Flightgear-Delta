import QtQuick 2.15
import QtQuick.Controls 2.15

import "./LaunchSubPages"
import "qrc:/qml/"

Rectangle {
    property real topOffset: 0
    color: "transparent"

    Text {
        anchors.centerIn: parent
        text: "Launch"
        color: "#ffffff"
        font.pixelSize: 14
    }

    StackView {
        id: stackView
        anchors {
            top: parent.top
            topMargin: topOffset + 12
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        initialItem: "qrc:/qml/pages/LaunchSubPages/Aircrafts.qml"
        Component.onCompleted: AppState.launchStack = stackView
    }
}
