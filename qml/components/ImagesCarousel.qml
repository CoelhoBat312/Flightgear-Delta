// ImageCarousel.qml
import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root
    property var images: []
    property int currentIndex: 0
    property bool imageAActive: true

    // --- Settings of animation and autoplay ---
    property int transitionDuration: 400
    property int idleBeforeAutoplay: 20000
    property int autoplayInterval: 5000

    function aspectHeight(img) {
        return root.width * (img.sourceSize.height / img.sourceSize.width)
    }

    height: aspectHeight(imageAActive ? imageA : imageB)
    width: parent.width

    Image {
        id: imageA
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        source: "file:///" + root.images[root.currentIndex]
        asynchronous: true
        cache: true
        opacity: root.imageAActive ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: root.transitionDuration; easing.type: Easing.InOutQuad } }
    }

    Image {
        id: imageB
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        asynchronous: true
        cache: true
        opacity: root.imageAActive ? 0 : 1
        Behavior on opacity { NumberAnimation { duration: root.transitionDuration; easing.type: Easing.InOutQuad } }
    }

    function updateImage() {
        var src = root.images.length > 0
            ? "file:///" + root.images[root.currentIndex]
            : ""
        if (root.imageAActive) {
            imageB.source = src
            imageAActive = false
        } else {
            imageA.source = src
            imageAActive = true
        }
    }


    onCurrentIndexChanged: updateImage()

    onStateChanged: {
        if (images.length > 0) {
            imageA.source = "file:///" + images[currentIndex]
            imageAActive = true
        }
        idleTimer.restart()
    }

    // --- Autoplay ---
    function resetIdle() {
        autoplayTimer.stop()
        idleTimer.restart()
    }

    Timer {
        id: idleTimer
        interval: root.idleBeforeAutoplay
        running: false
        repeat: false
        onTriggered: autoplayTimer.start()
    }

    Timer {
        id: autoplayTimer
        interval: root.autoplayInterval
        running: false
        repeat: true
        onTriggered: {
            root.currentIndex = (root.currentIndex + 1) % root.images.length
        }
    }

    // --- Arrow "backward" ---
    Rectangle {
        visible: root.images.length > 1
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        height: parent.height
        width: 20
        color: "#66000000"

        Text {
            text: "<"
            font.pixelSize: 20
            anchors.fill: parent
            color: "#ffffff"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                root.currentIndex =
                    (root.currentIndex - 1 + root.images.length)
                    % root.images.length
                root.resetIdle()
            }
            onEntered: parent.color = "#66000000"
            onExited: parent.color = "#44000000"
        }

        Behavior on color { ColorAnimation { duration: root.transitionDuration; easing.type: Easing.InOutQuad } }
    }

    // --- Arrow "forward" ---
    Rectangle {
        visible: root.images.length > 1
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        height: parent.height
        width: 20
        color: "#44000000"

        Text {
            text: ">"
            font.pixelSize: 20
            anchors.fill: parent
            color: "#ffffff"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                root.currentIndex =
                    (root.currentIndex + 1)
                    % root.images.length
                root.resetIdle()
            }
            onEntered: parent.color = "#66000000"
            onExited: parent.color = "#44000000"
        }

        Behavior on color { ColorAnimation { duration: root.transitionDuration; easing.type: Easing.InOutQuad } }
    }

    // --- Dots-alike indicators, like in current launcher ---
    Row {
        spacing: 8
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 10

        Repeater {
            model: root.images.length
            Rectangle {
                width: 10
                height: 10
                radius: 5
                color: index === root.currentIndex ? "white" : "#777"
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onClicked: {
                        root.currentIndex = index
                        root.resetIdle()
                    }
                }
            }
        }
    }

    Behavior on height { NumberAnimation { duration: root.transitionDuration; easing.type: Easing.InOutQuad } }
}
