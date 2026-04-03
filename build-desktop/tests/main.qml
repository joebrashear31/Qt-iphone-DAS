import QtQuick
import QtQuick.Controls

// Root window — fullscreen on iOS via visibility flag
ApplicationWindow {
    id: root
    visible: true
    visibility: Window.FullScreen
    title: "SenseCapture"

    // Dark background to suit a capture/sensor app aesthetic
    Rectangle {
        anchors.fill: parent
        color: "#1a1a1a"

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
