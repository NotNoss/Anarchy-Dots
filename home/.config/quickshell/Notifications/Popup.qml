import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import qs.Theme

Scope {
    PanelWindow {
        anchors { top: true; right: true }
        margins { top: 12; right: 12 }

        implicitWidth: 380
        implicitHeight: Math.max(1, column.implicitHeight)
        WlrLayershell.namespace: "quickshell-blur"
        color: "transparent"

        exclusionMode: ExclusionMode.Ignore

        ColumnLayout {
            id: column
            width: parent.width
            spacing: 10

            // Spacer item to drop notifications down a bit
            Item {
                id: spacer
                implicitHeight: 25
            }

            Repeater {
                model: NotificationHistory.trackedNotifications

                Rectangle {
                    id: card
                    required property var modelData
                    readonly property bool critical: modelData.urgency === NotificationUrgency.Critical

                    Timer {
                        running: true
                        interval: 10000
                        onTriggered: card.modelData.dismiss()
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: card.modelData.dismiss()
                    }

                    Layout.fillWidth: true
                    Layout.preferredHeight: layout.implicitHeight + 20
                    radius: 8
                    color: Qt.rgba(Theme.background.r, Theme.background.g, Theme.background.b, 0.72)
                    border.width: card.critical ? 3 : 2
                    border.color: card.critical ? Theme.error_container : Theme.primary

                    RowLayout {
                        id: layout
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 10

                        Image {
                            Layout.preferredHeight: 36
                            Layout.preferredWidth: 36
                            Layout.alignment: Qt.AlignTop
                            fillMode: Image.PreserveAspectFit
                            visible: source.toString() !== ""
                            source: card.modelData.image || card.modelData.appIcon || ""
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2

                            Text {
                                Layout.fillWidth: true
                                text: card.modelData.summary
                                color: Theme.primary
                                font.family: Theme.fontFamily
                                font.pixelSize: 16
                                font.bold: true
                                elide: Text.ElideRight
                            }

                            Text {
                                Layout.fillWidth: true
                                visible: text !== ""
                                text: card.modelData.body
                                color: Theme.primary
                                font.family: Theme.fontFamily
                                font.pixelSize: 15
                                elide: Text.WordWrap
                            }
                        }
                    }
                }
            }
        }
    }
}
