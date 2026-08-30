import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Polkit
import QtQuick
import QtQuick.Layouts
import qs.Theme

Scope {
    PanelWindow {
        id: root
        implicitWidth: 400
        implicitHeight: 100
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.namespace: "quickshell-blur"
        color: "transparent"
        visible: PowerState.menuOpen
        focusable: true
        onVisibleChanged: if (visible) {
            powerRow.currentIndex = 0;
        }

        IpcHandler {
            target: "power"
            function toggle(): void { PowerState.menuOpen = !PowerState.menuOpen }
            function show() : void { PowerState.menuOpen = true }
            function hide() : void { PowerState.menuOpen = false }
        }

        Rectangle {
            anchors.fill: parent
            radius: root.implicitHeight / 2
            color: Qt.rgba(Theme.background.r, Theme.background.g, Theme.background.b, 0.72)

            GradientBorder {
                radius: parent.radius
                borderWidth: 2
            }
        }

        RowLayout {
            id: powerRow
            anchors.margins: 10
            anchors.centerIn: parent
            spacing: 15
            focus: true

            property int currentIndex: 0

            Process {
                id: polkitProc
            }

            function activate(index) {
                switch (index) {
                    case 0:
                        polkitProc.command = ["hyprlock"];
                        break;
                    case 1:
                        polkitProc.command = ["uwsm", "stop"];
                        break;
                    case 2:
                        polkitProc.command = ["systemctl", "reboot"];
                        break;
                    case 3:
                        polkitProc.command = ["systemctl", "poweroff"];
                        break;
                    default:
                        console.log("Something broke")
                }
                PowerState.menuOpen = false;
                polkitProc.running = true;
            }

            Keys.onPressed: (event) => {
                if (event.key === Qt.Key_H) {
                    powerRow.currentIndex = Math.max(0, powerRow.currentIndex - 1);
                    event.accepted = true;
                }
                else if (event.key === Qt.Key_L) {
                    powerRow.currentIndex = Math.max(0, powerRow.currentIndex + 1);
                    event.accepted = true;
                }
                else if (event.key === Qt.Key_Return) {
                    powerRow.activate(powerRow.currentIndex);
                    event.accepted = true;
                }
            }

            Button {
                id: lock
                text: "lock"
                selected: powerRow.currentIndex === 0
                onClicked: powerRow.activate(0)
            }

            Button {
                id: logout
                text: "logout"
                selected: powerRow.currentIndex === 1
                onClicked: powerRow.activate(1)
            }

            Button {
                id: restart
                text: "refresh"
                selected: powerRow.currentIndex === 2
                onClicked: powerRow.activate(2)
            }

            Button {
                id: power
                text: "power_settings_new"
                selected: powerRow.currentIndex === 3
                onClicked: powerRow.activate(3)
            }
        }
    }
}