import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

import "./components"
import "./pages"

Window {
    width: 1000
    height: 600
    minimumWidth: 900
    minimumHeight: 600
    visible: true
    title: "Flightgear δ"

    Component.onCompleted: {
        launcher.fgRoot = "/home/andrew/.fgfs"
    }

    Rectangle {
        anchors.fill: parent
        color: "#1a1a1a"

        Rectangle {
            id: topbar

            height: 48
            implicitWidth: topbarRow.implicitWidth + 16
            radius: 8
            color: "#141414"

            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                topMargin: 12
            }

            Row {
                id: topbarRow
                anchors {
                    verticalCenter: parent.verticalCenter
                    horizontalCenter: parent.horizontalCenter
                }
                spacing: 4

                TopBarButton {
                    label: qsTr("Launch")
                    onClicked: stack.replace("qrc:/qml/pages/LaunchPage.qml")
                }
                TopBarButton {
                    label: qsTr("Aircraft's preview")
                    onClicked: stack.replace("qrc:/qml/pages/PreviewPage.qml")
                }
                TopBarButton {
                    label: qsTr("Launcher setting")
                    onClicked: stack.replace("qrc:/qml/pages/SettingsPage.qml")
                }
            }
        }

        StackView {
            id: stack
            anchors {
                top: topbar.bottom
                bottom: parent.bottom
                left: parent.left
                right: parent.right
                topMargin: 12
            }
            initialItem: "qrc:/qml/pages/LaunchPage.qml"
        }
    }
}
