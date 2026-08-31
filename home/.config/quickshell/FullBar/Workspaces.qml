import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import qs.Theme

Rectangle {
    id: ws
    implicitWidth: row.implicitWidth + 22
    implicitHeight: 30
    radius: height / 2
    color: "transparent"

    Component.onCompleted: Hyprland.refreshWorkspaces()

    Timer {
        interval: 1500
        running: true
        repeat: false
        onTriggered: Hyprland.refreshWorkspaces()
    }

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            switch (event.name) {
            case "openwindow":
            case "closewindow":
            case "movewindow":
            case "movewindowv2":
            case "changefloatingmode":
            case "createworkspace":
            case "createworkspacev2":
            case "destroyworkspace":
            case "destroyworkspacev2":
            case "moveworkspace":
            case "moveworkspacev2":
            case "workspace":
            case "workspacev2":
            case "focusedmon":
            case "monitoraddedv2":
            case "monitorremoved":
                Hyprland.refreshWorkspaces()
                break
            }
        }
    }

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 10

        Repeater {
            model: Hyprland.workspaces.values.filter(w => w.id > 0)

            Text {
                required property var modelData
                readonly property bool hasWindows: (modelData.lastIpcObject?.windows ?? 0) > 0

                text: (modelData.focused || hasWindows) ? " " : " "

                color: {
                    if (modelData.focused) return Theme.primary
                    if (modelData.urgent) return Theme.error
                    if (hasWindows) return Theme.inverse_primary
                    return Theme.outline
                }

                font { pixelSize: 14; bold: true; family: Theme.fontFamily }
            }
        }
    }
}