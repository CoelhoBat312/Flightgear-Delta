import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs

Rectangle {
    id: root
    color: "#1a1a1a"
    signal pathSelected(string path)

    Column {
        anchors.centerIn: parent
        spacing: 20
        Text {
            text: qsTr("Set path to FlightGear")
            color: "#ffffff"
            font.pixelSize: 18
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Button {
            text: qsTr("Set path")
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: folderDialog.open()
        }
        Text {
            id: errorText
            visible: false
            text: qsTr("Folder does not seem to have FlightGear's structure")
            color: "#ff5555"
            font.pixelSize: 12
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    FolderDialog {
        id: folderDialog
        title: qsTr("Choose a FlightGear folder")
        onAccepted: {
            const path = folderDialog.fileUrl.toString().replace("file:///", "")
            if (!launcher.setFgRoot(path)) {
                errorText.visible = true
            } else {
                root.pathSelected(path)
            }
        }
    }
}
