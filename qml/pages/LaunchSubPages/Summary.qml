// LaunchPage.qml
import QtQuick 2.15

Item {
    anchors.fill: parent


    Image {
        id: bgImage
        anchors.fill: parent
        source: launcher.aircraftThumbnail(currentAircraft)
        fillMode: Image.PreserveAspectCrop

        Behavior on source {
            // плавная смена картинки
            SequentialAnimation {
                NumberAnimation { target: bgImage; property: "opacity"; to: 0; duration: 300 }
                PropertyAction {}
                NumberAnimation { target: bgImage; property: "opacity"; to: 1; duration: 300 }
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 0.6; color: "#aa000000" }
            GradientStop { position: 1.0; color: "#ee000000" }
        }
    }

    Text {
        anchors {
            bottom: parent.bottom
            left: parent.left
            bottomMargin: 24
            leftMargin: 24
        }
        text: "Cessna 172P"
        color: "#ffffff"
        font.pixelSize: 22
        font.weight: Font.Medium
    }
}
