import QtQuick
import QtQuick.Controls
import QtMultimedia

// Root window — fullscreen on iOS via visibility flag
ApplicationWindow {
    id: root
    visible: true
    visibility: Window.FullScreen
    title: "SenseCapture"
    // Fallback background color shown when camera is unavailable or denied
    color: "#1a1a1a"

    // Camera backend — Qt selects the default device (back camera on iPhone)
    Camera {
        id: camera
        objectName: "camera"   // required for findChild() in Qt Quick Test
        active: true
    }

    // Connects the camera pipeline to the VideoOutput render surface
    CaptureSession {
        camera: camera
        videoOutput: videoOutput
    }

    // Fullscreen camera preview — rendered below the UI overlay
    VideoOutput {
        id: videoOutput
        objectName: "videoOutput"
        anchors.fill: parent
    }

    // Transparent overlay — preserves layout context for title and button
    // while allowing the camera preview to show through
    Rectangle {
        objectName: "overlay"   // required for findChild() in Qt Quick Test
        anchors.fill: parent
        color: "transparent"

        // Centered app title
        Text {
            id: titleText
            objectName: "titleText"   // required for findChild() in Qt Quick Test
            anchors.centerIn: parent
            text: "SenseCapture"
            color: "#ffffff"
            font.pixelSize: 32
            font.weight: Font.Medium
        }

        // Placeholder record button — no logic attached yet
        Button {
            id: recordButton
            objectName: "recordButton"   // required for findChild() in Qt Quick Test
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: titleText.bottom
                topMargin: 40
            }
            text: "Record"
            // Styled to stand out; logic will be wired in a later phase
            background: Rectangle {
                implicitWidth: 120
                implicitHeight: 48
                radius: 24
                color: recordButton.pressed ? "#cc0000" : "#ff3b30"
            }
            contentItem: Text {
                text: recordButton.text
                color: "#ffffff"
                font.pixelSize: 18
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
    }
}
