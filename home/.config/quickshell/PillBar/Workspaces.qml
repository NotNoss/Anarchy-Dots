import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import qs.Theme

Rectangle {
    id: ws

    // The screen this bar instance lives on; workspaces are filtered to it.
    property var screen: null
    readonly property var monitor: screen ? Hyprland.monitorFor(screen) : null

    implicitWidth: row.implicitWidth + 22
    implicitHeight: 30
    radius: height / 2
    color: Qt.rgba(Theme.background.r, Theme.background.g, Theme.background.b, 0.72)

    Component.onCompleted: Hyprland.refreshWorkspaces()

    // Persistent workspaces created at boot arrive via createworkspacev2 events that
    // carry no monitor field, so w.monitor stays null until a full refresh. Hyprland
    // may also still be creating them when the bar first queries. A delayed one-shot
    // refresh reconciles the workspace->monitor mapping once things have settled.
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
            model: {
                const all = Hyprland.workspaces.values
                const real = all.filter(w => w.id > 0)
                const filtered = ws.monitor
                    ? real.filter(w => !w.monitor || w.monitor.name === ws.monitor.name)
                    : real
                return [...filtered].sort((a, b) => a.id - b.id)
            }

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