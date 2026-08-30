import Quickshell
import Quickshell.Io
import Quickshell.Widgets
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
        visible: LauncherState.launcherOpen
        focusable: true
        onVisibleChanged: if (visible) {
            list.currentIndex = 0
            list.forceActiveFocus()
        }

        IpcHandler {
            target: "launcher"
            function toggle(): void { LauncherState.launcherOpen = !LauncherState.launcherOpen }
            function show(): void { LauncherState.launcherOpen = true }
            function hide(): void { LauncherState.launcherOpen = false }
        }

        ScriptModel {
            id: results

            values: {
                const appList = [...DesktopEntries.applications.values]
                    .filter (e => e.name)
                    .sort((a, b) => a.name.localeCompare(b.name))

                const query = appSearch.text.trim().toLowerCase()
                if (query === "")
                    return appList
                
                return appList.filter(e => {
                    const name = (e.name || "").toLowerCase()
                    const generic = (e.genericName || "").toLowerCase()
                    const comment = (e.comment || "").toLowerCase()
                    const keywords = (e.keywords || []).join(" ").toLowerCase()
                    return name.includes(query)
                        || generic.includes(query)
                        || comment.includes(query)
                        || keywords.includes(query)
                })
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
                    else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        if (list.currentItem) list.currentItem.modelData.execute();
                        LauncherState.launcherOpen = false;
                        event.accepted = true;
                    }
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

                    onClicked: {
                        list.currentIndex = index
                        modelData.execute()
                        LauncherState.launcherOpen = false
                    }

                    Row {
                        anchors.fill: parent
                        anchors.leftMargin: 10
                        spacing: 14

                        IconImage {
                            anchors.verticalCenter: parent.verticalCenter
                            implicitSize: 36
                            source: Quickshell.iconPath(
                                modelData.icon, "application-x-executable"
                            )
                        }

                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            Text {
                                text: modelData.name
                                color: Theme.primary
                                font.pixelSize: 15
                            }
                            Text {
                                text: modelData.comment
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