import QtQuick
import QtQuick3D
import QtQuick3D.AssetUtils

Item {
    id: root
    property string modelPath: "file:///home/andrew/Flightgear/FlightGearData/fgdata_2024_1/Aircraft/A320-family/Models/Fuselage/res/A320-216.ac"

    anchors.fill: parent

    View3D {
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }
        width: parent.width / 2

        environment: SceneEnvironment {
            clearColor: "#1a1a1a"
            backgroundMode: SceneEnvironment.Color
        }

        PerspectiveCamera {
            id: camera
            position: Qt.vector3d(-55, 15, 25)
            eulerRotation.x: -20
            eulerRotation.y: -65
            fieldOfView: 30
        }

        DirectionalLight {
            eulerRotation.x: -30
            eulerRotation.y: -70
        }



        RuntimeLoader {
            id: aircraftModel
            source: root.modelPath
            onStatusChanged: {
                if (status === RuntimeLoader.Success) {
                    applyTexture(aircraftModel, "file:///home/andrew/Flightgear/FlightGearData/fgdata_2024_1/Aircraft/A320-family/Models/Liveries/CFM-NEO/4k/SAS-fuselage.png")
                } else if (status === RuntimeLoader.Error) {
                    console.log("Model load ERROR:", errorString)
                }
            }
            Texture {
                id: hardcodedTexture
                source: "file:///home/andrew/Flightgear/FlightGearData/fgdata_2024_1/Aircraft/A320-family/Models/Liveries/CFM-NEO/4k/SAS-fuselage.png"
            }

            PrincipledMaterial {
                id: hardcodedMaterial
                baseColorMap: hardcodedTexture
            }

            function applyTexture(node, texturePath) {
                for (var i = 0; i < node.children.length; i++) {
                    var child = node.children[i]
                    if (child instanceof Model) {
                        child.materials = [hardcodedMaterial]
                    }
                    applyTexture(child, texturePath)  // рекурсивно идём глубже
                }
            }

            NumberAnimation on eulerRotation.y {
                from: 0
                to: 360
                duration: 12000
                loops: Animation.Infinite
                running: true
            }
        }
    }
}