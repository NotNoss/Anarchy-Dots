import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import qs.Theme

Rectangle {
    id: tray

    implicitWidth: row.implicitWidth + 22
    implicitHeight: 30
    radius: height / 2
    color: Qt.rgba(Theme.background.r, Theme.background.g, Theme.background.b, 0.72)

    // Hide the whole capsule when there is nothing in the tray.
    visible: SystemTray.items.values.length > 0

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 8

        Repeater {
            model: SystemTray.items

            MouseArea {
                id: entry
                required property var modelData

                implicitWidth: 18
                implicitHeight: 18
                cursorShape: Qt.PointingHandCursor
                onClicked: entry.modelData.activate()

                IconImage {
                    anchors.fill: parent
                    source: entry.modelData.icon
                }
            }
        }
    }
}
