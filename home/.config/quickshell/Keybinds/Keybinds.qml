import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.Theme

Scope {
    PanelWindow {
        id: root
        implicitWidth: 750
        implicitHeight: 500
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.namespace: "quickshell-blur"
        color: "transparent"
        visible: KeybindsState.keybindsOpen
        focusable: true
        onVisibleChanged: if (visible) {
            bindsProc.running = true
            list.currentIndex = 0
            list.forceActiveFocus()
        }

        property var allBinds: []

        function modmaskToString(mask) {
            const parts = []
            if (mask & 64) parts.push("SUPER")
            if (mask & 4) parts.push("CTRL")
            if (mask & 8) parts.push("ALT")
            if (mask & 1) parts.push("SHIFT")
            if (mask & 2) parts.push("CAPS")
            if (mask & 16) parts.push("MOD2")
            if (mask & 32) parts.push("MOD3")
            if (mask & 128) parts.push("MOD5")
            return parts.join("+")
        }

        Process {
            id: bindsProc
            command: ["hyprctl", "binds", "-j"]
            stdout: StdioCollector {
                onStreamFinished: {
                    const parsed = JSON.parse(text)
                    root.allBinds = parsed
                        .filter(b => !b.mouse)
                        .map(b => ({
                            combo: root.modmaskToString(b.modmask) + (b.modmask ? "+" : "") + b.key,
                            description: b.description || ""
                        }))
                }
            }
        }

        IpcHandler {
            target: "keybinds"
            function toggle(): void { KeybindsState.keybindsOpen = !KeybindsState.keybindsOpen }
            function show(): void { KeybindsState.keybindsOpen = true }
            function hide(): void { KeybindsState.keybindsOpen = false }
        }

        ScriptModel {
            id: results

            values: {
                const query = appSearch.text.trim().toLowerCase()
                if (query === "")
                    return root.allBinds

                return root.allBinds.filter(b =>
                    b.combo.toLowerCase().includes(query)
                        || b.description.toLowerCase().includes(query)
                )
            }
        }

        Rectangle {
            anchors.fill: parent
            radius: 10
            color: Qt.rgba(Theme.background.r, Theme.background.g, Theme.background.b, 0.72)

            GradientBorder {
                radius: parent.radius
                borderWidth: 2
            }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 5
            Rectangle {
                Layout.preferredWidth: 500
                Layout.preferredHeight: 32
                Layout.alignment: Qt.AlignHCenter
                color: Theme.background
                radius: 6
                anchors.margins: 3

                GradientBorder {
                    radius: parent.radius
                    borderWidth: 3
                }

                TextInput {
                    id: appSearch
                    anchors.fill: parent
                    clip: true
                    color: Theme.primary
                    horizontalAlignment: TextInput.AlignHCenter
                    verticalAlignment: TextInput.AlignVCenter
                    selectByMouse: true

                    onAccepted: {
                        list.currentIndex = 0
                        list.forceActiveFocus()
                    }
                }
            }

            ListView {
                id: list
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                focus: true
                keyNavigationWraps: false
                model: results.values

                onCountChanged: if (currentIndex >= count) currentIndex = count - 1

                Keys.onPressed: (event) => {
                    if (event.key === Qt.Key_J) { list.incrementCurrentIndex(); event.accepted = true; }
                    else if (event.key === Qt.Key_K) { list.decrementCurrentIndex(); event.accepted = true; }
                    else if (event.key === Qt.Key_Slash) {
                        appSearch.forceActiveFocus();
                        appSearch.selectAll();
                        event.accepted = true;
                    }
                }

                delegate: ItemDelegate {
                    id: entry
                    required property var modelData
                    required property int index
                    width: list.width
                    height: 52
                    highlighted: ListView.isCurrentItem

                    background: Rectangle {
                        radius: 6
                        color: entry.highlighted
                            ? Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.22)
                            : entry.hovered
                                ? Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.10)
                                : "transparent"
                    }

                    Row {
                        anchors.fill: parent
                        anchors.leftMargin: 10
                        spacing: 14

                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            Text {
                                text: modelData.combo
                                color: Theme.primary
                                font.pixelSize: 15
                            }
                            Text {
                                text: modelData.description
                                color: Theme.primary
                                font.pixelSize: 11
                                visible: text !== ""
                            }
                        }
                    }
                }
            }
        }
    }
}