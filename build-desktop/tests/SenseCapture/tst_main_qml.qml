import QtQuick
import QtQuick.Controls
import QtTest

// Qt Quick Test suite for main.qml UI behavior.
// These tests are RED until main.qml exists and passes each assertion.
TestCase {
    id: suite
    name: "MainQmlTests"
    when: windowShown

    // Load the component under test
    Component {
        id: mainComponent
        Loader {
            source: "../main.qml"
        }
    }

    property var loader: null

    // Instantiate before each test
    function init() {
        loader = createTemporaryObject(mainComponent, suite)
        verify(loader !== null, "Loader should be created")
        // Wait for async QML load
        tryVerify(function() { return loader.item !== null }, 2000,
                  "main.qml should load within 2s")
    }

    // ----------------------------------------------------------------
    // Test 1: Window is visible
    // RED: will fail if main.qml is absent or Window.FullScreen is not set
    // ----------------------------------------------------------------
    function test_windowIsVisible() {
        var win = loader.item
        verify(win !== null, "Root item should exist")
        compare(win.visible, true, "Window should be visible")
    }

    // ----------------------------------------------------------------
    // Test 2: "SenseCapture" text is rendered and centered
    // RED: will fail if Text item is missing or text property is wrong
    // ----------------------------------------------------------------
    function test_titleTextContent() {
        var win = loader.item
        // Find the Text child by walking the item tree
        var titleText = findChild(win, "titleText")
        verify(titleText !== null, "titleText item should exist")
        compare(titleText.text, "SenseCapture", "Title should read 'SenseCapture'")
    }

    function test_titleTextIsCentered() {
        var win = loader.item
        var titleText = findChild(win, "titleText")
        verify(titleText !== null, "titleText item should exist")
        // Centered anchors: the item's center should match its parent's center
        // Allow ±1px for rounding
        var parentCenterX = titleText.parent.width / 2
        var itemCenterX = titleText.x + titleText.width / 2
        verify(Math.abs(itemCenterX - parentCenterX) <= 1,
               "titleText should be horizontally centered")
    }

    // ----------------------------------------------------------------
    // Test 3: Record button exists
    // RED: will fail if Button with id recordButton is absent
    // ----------------------------------------------------------------
    function test_recordButtonExists() {
        var win = loader.item
        var btn = findChild(win, "recordButton")
        verify(btn !== null, "recordButton should exist")
        compare(btn.text, "Record", "Button label should be 'Record'")
    }

    // ----------------------------------------------------------------
    // Test 4: Record button background changes color on press
    // RED: will fail if pressed color logic is absent in main.qml
    // ----------------------------------------------------------------
    function test_recordButtonPressedColor() {
        var win = loader.item
        var btn = findChild(win, "recordButton")
        verify(btn !== null, "recordButton should exist")

        // Simulate press — background color should switch to #cc0000
        mousePress(btn)
        tryVerify(function() {
            return btn.background.color.toString() === "#cc0000"
        }, 500, "Button background should be #cc0000 when pressed")
        mouseRelease(btn)

        // Released — background should return to #ff3b30
        tryVerify(function() {
            return btn.background.color.toString() === "#ff3b30"
        }, 500, "Button background should return to #ff3b30 on release")
    }
}
