import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import qs.Theme

Scope {
    PanelWindow {
        id: win
        visible: NotificationCenterState.centerOpen
        anchors { top: true; right: true }
        margins { top: 12; right: 12 }

        implicitWidth: 380
        implicitHeight: centerCol.implicitHeight + 24
        WlrLayershell.namespace: "quickshell-blur"
        color: "transparent"
        focusable: true
        exclusionMode: ExclusionMode.Ignore

        onVisibleChanged: if (visible) centerCol.forceActiveFocus()

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
            id: centerCol
            anchors.fill: parent
            anchors.margins: 12
            spacing: 10
            focus: true

            // Index into NotificationHistory.groups (hover + keyboard both write this).
            property int selectedGroup: 0
            // The single currently-expanded app, keyed by name so it survives rebuilds.
            property string expandedApp: ""
            // Index within the expanded group's items, only meaningful while expanded.
            property int selectedItem: -1

            function toggleExpand(i) {
                const g = NotificationHistory.groups[i]
                if (!g || g.count <= 1)
                    return
                if (centerCol.expandedApp === g.appName) {
                    centerCol.expandedApp = ""
                    centerCol.selectedItem = -1
                } else {
                    centerCol.expandedApp = g.appName
                    centerCol.selectedGroup = i
                    centerCol.selectedItem = 0
                }
            }

            function clampSelection() {
                const groups = NotificationHistory.groups
                if (groups.length === 0) {
                    centerCol.selectedGroup = 0
                    centerCol.expandedApp = ""
                    centerCol.selectedItem = -1
                    return
                }
                centerCol.selectedGroup = Math.max(0, Math.min(centerCol.selectedGroup, groups.length - 1))

                let g = null
                for (let i = 0; i < groups.length; i++)
                    if (groups[i].appName === centerCol.expandedApp)
                        g = groups[i]

                if (!g || g.count <= 1) {
                    centerCol.expandedApp = ""
                    centerCol.selectedItem = -1
                } else {
                    centerCol.selectedItem = Math.max(0, Math.min(centerCol.selectedItem, g.count - 1))
                }
            }

            Connections {
                target: NotificationHistory
                function onGroupsChanged() { centerCol.clampSelection() }
            }

            Keys.onPressed: (event) => {
                const groups = NotificationHistory.groups
                const g = groups[centerCol.selectedGroup]
                const expanded = g && centerCol.expandedApp === g.appName && g.count > 1

                if (event.key === Qt.Key_A) {
                    NotificationHistory.clearAll()
                    centerCol.expandedApp = ""
                    centerCol.selectedItem = -1
                    event.accepted = true
                } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                    centerCol.toggleExpand(centerCol.selectedGroup)
                    event.accepted = true
                } else if (event.key === Qt.Key_Escape) {
                    if (expanded) {
                        centerCol.expandedApp = ""
                        centerCol.selectedItem = -1
                    }
                    event.accepted = true
                } else if (event.key === Qt.Key_J || event.key === Qt.Key_Down) {
                    if (expanded) {
                        if (centerCol.selectedItem < g.items.length - 1)
                            centerCol.selectedItem++
                    } else if (centerCol.selectedGroup < groups.length - 1) {
                        centerCol.selectedGroup++
                    }
                    event.accepted = true
                } else if (event.key === Qt.Key_K || event.key === Qt.Key_Up) {
                    if (expanded) {
                        if (centerCol.selectedItem > 0)
                            centerCol.selectedItem--
                    } else if (centerCol.selectedGroup > 0) {
                        centerCol.selectedGroup--
                    }
                    event.accepted = true
                } else if (event.key === Qt.Key_C) {
                    if (expanded && centerCol.selectedItem >= 0 && centerCol.selectedItem < g.items.length)
                        NotificationHistory.removeByUid(g.items[centerCol.selectedItem].uid)
                    else if (g)
                        NotificationHistory.removeApp(g.appName)
                    event.accepted = true
                }
            }

            RowLayout {
                Layout.fillWidth: true

                Text {
                    Layout.fillWidth: true
                    text: "Notifications"
                    color: Theme.primary
                    font.family: Theme.fontFamily
                    font.pixelSize: 18
                    font.bold: true
                    elide: Text.ElideRight
                }

                Text {
                    text: "Clear all"
                    visible: NotificationHistory.groups.length > 0
                    color: Theme.error_container
                    font.family: Theme.fontFamily
                    font.pixelSize: 15
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            NotificationHistory.clearAll()
                            centerCol.expandedApp = ""
                            centerCol.selectedItem = -1
                        }
                    }
                }
            }

            Text {
                Layout.fillWidth: true
                Layout.topMargin: 8
                visible: NotificationHistory.groups.length === 0
                text: "No notifications"
                horizontalAlignment: Text.AlignHCenter
                color: Theme.on_secondary_fixed_variant
                font.family: Theme.fontFamily
                font.pixelSize: 14
            }

            Repeater {
                model: NotificationHistory.groups

                Item {
                    id: groupDelegate
                    required property var modelData
                    required property int index

                    readonly property bool isSelected: groupDelegate.index === centerCol.selectedGroup
                    readonly property bool isExpanded: centerCol.expandedApp === groupDelegate.modelData.appName
                                                       && groupDelegate.modelData.count > 1
                    readonly property bool multi: groupDelegate.modelData.count > 1
                    readonly property bool critical: groupDelegate.modelData.urgency === NotificationUrgency.Critical

                    Layout.fillWidth: true
                    Layout.preferredHeight: groupCol.implicitHeight

                    ColumnLayout {
                        id: groupCol
                        width: parent.width
                        spacing: 6

                        // ---------- COLLAPSED ----------
                        Item {
                            id: collapsed
                            visible: !groupDelegate.isExpanded
                            Layout.fillWidth: true
                            Layout.preferredHeight: collapsedCard.height + (groupDelegate.multi ? 10 : 0)

                            // Layered card edges peeking behind the newest notification.
                            Rectangle {
                                visible: groupDelegate.modelData.count > 2
                                x: 10
                                y: 10
                                width: parent.width - 10
                                height: collapsedCard.height
                                radius: 8
                                color: Theme.surface_container_high
                                opacity: 0.45
                            }
                            Rectangle {
                                visible: groupDelegate.multi
                                x: 5
                                y: 5
                                width: parent.width - 5
                                height: collapsedCard.height
                                radius: 8
                                color: Theme.surface_container_high
                                opacity: 0.7
                            }

                            Rectangle {
                                id: collapsedCard
                                x: 0
                                y: 0
                                width: parent.width - (groupDelegate.multi ? 10 : 0)
                                height: collapsedLayout.implicitHeight + 20
                                radius: 8
                                color: groupDelegate.isSelected
                                       ? Theme.surface_container_high
                                       : Qt.rgba(Theme.background.r, Theme.background.g, Theme.background.b, 0.72)
                                border.width: groupDelegate.critical ? (groupDelegate.isSelected ? 3 : 2) : 0
                                border.color: Theme.error_container

                                GradientBorder {
                                    visible: !groupDelegate.critical
                                    radius: parent.radius
                                    borderWidth: groupDelegate.isSelected ? 3 : 2
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: groupDelegate.multi ? Qt.PointingHandCursor : Qt.ArrowCursor
                                    onEntered: centerCol.selectedGroup = groupDelegate.index
                                    onClicked: centerCol.toggleExpand(groupDelegate.index)
                                }

                                ColumnLayout {
                                    id: collapsedLayout
                                    anchors.fill: parent
                                    anchors.margins: 10
                                    spacing: 2

                                    RowLayout {
                                        Layout.fillWidth: true

                                        Text {
                                            Layout.fillWidth: true
                                            text: groupDelegate.modelData.appName
                                            color: Theme.on_secondary_fixed_variant
                                            font.family: Theme.fontFamily
                                            font.pixelSize: 13
                                            elide: Text.ElideRight
                                        }

                                        Text {
                                            text: groupDelegate.modelData.latest.time
                                            color: Theme.on_secondary_fixed_variant
                                            font.family: Theme.fontFamily
                                            font.pixelSize: 13
                                        }

                                        // Count badge / single-notification close.
                                        Rectangle {
                                            visible: groupDelegate.multi
                                            implicitWidth: Math.max(18, countText.implicitWidth + 10)
                                            implicitHeight: 18
                                            radius: 9
                                            color: Theme.primary

                                            Text {
                                                id: countText
                                                anchors.centerIn: parent
                                                text: groupDelegate.modelData.count
                                                color: Theme.background
                                                font.family: Theme.fontFamily
                                                font.pixelSize: 12
                                                font.bold: true
                                            }
                                        }

                                        Text {
                                            visible: !groupDelegate.multi
                                            text: "close_small"
                                            color: Theme.on_secondary_fixed_variant
                                            font.family: Theme.iconFontFamily
                                            font.pixelSize: 15
                                            MouseArea {
                                                anchors.fill: parent
                                                onClicked: NotificationHistory.removeByUid(groupDelegate.modelData.latest.uid)
                                            }
                                        }
                                    }

                                    Text {
                                        Layout.fillWidth: true
                                        visible: text !== ""
                                        text: groupDelegate.modelData.latest.summary
                                        color: Theme.primary
                                        font.family: Theme.fontFamily
                                        font.pixelSize: 16
                                        font.bold: true
                                        elide: Text.ElideRight
                                    }

                                    Text {
                                        Layout.fillWidth: true
                                        visible: text !== ""
                                        text: groupDelegate.modelData.latest.body
                                        color: Theme.primary
                                        font.family: Theme.fontFamily
                                        font.pixelSize: 15
                                        wrapMode: Text.WordWrap
                                    }
                                }
                            }
                        }

                        // ---------- EXPANDED ----------
                        ColumnLayout {
                            id: expandedCol
                            visible: groupDelegate.isExpanded
                            Layout.fillWidth: true
                            spacing: 4

                            RowLayout {
                                Layout.fillWidth: true

                                Text {
                                    Layout.fillWidth: true
                                    text: groupDelegate.modelData.appName + "  (" + groupDelegate.modelData.count + ")"
                                    color: groupDelegate.isSelected ? Theme.primary : Theme.on_secondary_fixed_variant
                                    font.family: Theme.fontFamily
                                    font.pixelSize: 13
                                    font.bold: true
                                    elide: Text.ElideRight
                                }

                                Text {
                                    text: "expand_less"
                                    color: Theme.on_secondary_fixed_variant
                                    font.family: Theme.iconFontFamily
                                    font.pixelSize: 16
                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            centerCol.expandedApp = ""
                                            centerCol.selectedItem = -1
                                        }
                                    }
                                }
                            }

                            Repeater {
                                model: groupDelegate.modelData.items

                                Rectangle {
                                    id: itemCard
                                    required property var modelData
                                    required property int index

                                    readonly property bool selected: groupDelegate.isExpanded
                                                                      && groupDelegate.index === centerCol.selectedGroup
                                                                      && itemCard.index === centerCol.selectedItem
                                    readonly property bool itemCritical: itemCard.modelData.urgency === NotificationUrgency.Critical

                                    Layout.fillWidth: true
                                    Layout.leftMargin: 10
                                    Layout.preferredHeight: itemLayout.implicitHeight + 18
                                    radius: 8
                                    color: itemCard.selected
                                           ? Theme.surface_container_high
                                           : Qt.rgba(Theme.background.r, Theme.background.g, Theme.background.b, 0.72)
                                    border.width: itemCard.itemCritical ? (itemCard.selected ? 3 : 2) : 0
                                    border.color: Theme.error_container

                                    GradientBorder {
                                        visible: !itemCard.itemCritical
                                        radius: parent.radius
                                        borderWidth: itemCard.selected ? 3 : 1
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        onEntered: {
                                            centerCol.selectedGroup = groupDelegate.index
                                            centerCol.selectedItem = itemCard.index
                                        }
                                    }

                                    ColumnLayout {
                                        id: itemLayout
                                        anchors.fill: parent
                                        anchors.margins: 9
                                        spacing: 2

                                        RowLayout {
                                            Layout.fillWidth: true

                                            Text {
                                                Layout.fillWidth: true
                                                text: itemCard.modelData.time
                                                color: Theme.on_secondary_fixed_variant
                                                font.family: Theme.fontFamily
                                                font.pixelSize: 12
                                            }

                                            Text {
                                                text: "close_small"
                                                color: Theme.on_secondary_fixed_variant
                                                font.family: Theme.iconFontFamily
                                                font.pixelSize: 15
                                                MouseArea {
                                                    anchors.fill: parent
                                                    onClicked: NotificationHistory.removeByUid(itemCard.modelData.uid)
                                                }
                                            }
                                        }

                                        Text {
                                            Layout.fillWidth: true
                                            visible: text !== ""
                                            text: itemCard.modelData.summary
                                            color: Theme.primary
                                            font.family: Theme.fontFamily
                                            font.pixelSize: 15
                                            font.bold: true
                                            elide: Text.ElideRight
                                        }

                                        Text {
                                            Layout.fillWidth: true
                                            visible: text !== ""
                                            text: itemCard.modelData.body
                                            color: Theme.primary
                                            font.family: Theme.fontFamily
                                            font.pixelSize: 14
                                            wrapMode: Text.WordWrap
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
