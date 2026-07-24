import QtQuick 2.15
import "../../components"

Item {
    anchors.fill: parent

    GridView {
        id: grid
        anchors {
            fill: parent
            margins: 24
            centerIn: parent
        }
        cellWidth: 196
        cellHeight: 236
        model: launcher.aircraftList

        delegate: AircraftCard {
            aircraftName: modelData
            thumbnailSource: launcher.aircraftThumbnail(modelData)
            onClicked: {
                detailPanel.aircraftName = modelData
                detailPanel.opened = true
            }
        }
    }

    AircraftDetailPanel {
        id: detailPanel
        anchors.fill: parent
    }
}
