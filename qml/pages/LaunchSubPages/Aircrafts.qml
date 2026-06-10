import QtQuick 2.15
import "../components"

Item {
    anchors.fill: parent

    GridView {
        id: grid
        anchors {
            fill: parent
            margins: 24
        }
        cellWidth: 196
        cellHeight: 236
        model: launcher.aircraftList

        delegate: AircraftCard {
            aircraftName: modelData
            thumbnailSource: launcher.aircraftThumbnail(modelData)
            onClicked: {
                detailPanel.aircraftName = modelData
                detailPanel.visible = true
            }
        }
    }

    // панель с описанием поверх
    AircraftDetailPanel {
        id: detailPanel
        anchors.fill: parent
        visible: false
    }
}
