import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import Qt.labs.folderlistmodel
import qs.Theme

Scope {
    PanelWindow {
        id: root
        implicitWidth: 750
        implicitHeight: 500
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.namespace: "quickshell-blur"
        color: "transparent"
        visible: SelectorState.selectorOpen
        focusable: true
        onVisibleChanged: if (visible) wallGrid.forceActiveFocus()

        property string imageDir: WallpaperConfig.wallpaperDir

        FolderListModel {
            id: dirModel
            folder: "file://" + root.imageDir
            nameFilters: ["*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp"]
            showDirs: false
        }

        IpcHandler {
            target: "wallpaper"
            function toggle(): void { SelectorState.selectorOpen = !SelectorState.selectorOpen }
            function show() : void { SelectorState.selectorOpen = true }
            function hide() : void { SelectorState.selectorOpen = false }
        }

        Rectangle {
            anchors.fill: parent
            radius: 10
            color: Qt.rgba(Theme.background.r, Theme.background.g, Theme.background.b, 0.72)
            border.width: 2
            border.color: Theme.primary
        }

        ColumnLayout {
            id: topBar
            anchors.fill: parent
            anchors.margins: 10
            spacing: 5
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "Wallpapers"
                font.family: Theme.fontFamily
                font.bold: true
                font.pixelSize: 18
                color: Theme.primary
            }
            Rectangle {
                Layout.preferredWidth: 500
                Layout.preferredHeight: 32
                Layout.alignment: Qt.AlignHCenter
                color: Theme.background
                radius: 6
                anchors.margins: 3
                border.width: 2
                border.color: Theme.primary

                TextInput {
                    id: pathInput
                    anchors.fill: parent
                    clip: true
                    text: root.imageDir
                    color: Theme.primary
                    horizontalAlignment: TextInput.AlignHCenter
                    verticalAlignment: TextInput.AlignVCenter
                    selectByMouse: true

                    onAccepted: {
                        let path = text.trim()
                        if (path.startsWith("~")) path = Quickshell.env("HOME") + path.slice(1)
                        WallpaperConfig.setWallpaperDir(path)
                        wallGrid.currentIndex = 0
                        wallGrid.forceActiveFocus()
                    }
                }
            }
            GridView {
                id: wallGrid
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                focus: true

                property int columns: 3

                cellWidth: width / columns
                cellHeight: cellWidth * 0.6

                model: dirModel
                onCountChanged: if (currentIndex < 0 && count > 0) currentIndex = 0
                keyNavigationWraps: false
                highlightFollowsCurrentItem: true

                highlight: Rectangle {
                    z: 10
                    color: "transparent"
                    radius: 4
                    border.width: 2
                    border.color: Theme.primary
                }

                delegate: Image {
                    id: thumb
                    required property url fileUrl
                    required property int index
                    width: wallGrid.cellWidth - 5
                    height: wallGrid.cellHeight - 5
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                    clip: true
                    source: fileUrl
                    sourceSize.width: width
                    sourceSize.height: height

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            wallGrid.currentIndex = thumb.index
                            wallGrid.applyWallpaper(thumb.fileUrl.toString().replace("file://", ""))
                        }
                    }
                }

                Process {
                    id: changeWall
                }

                function applyWallpaper(path) {
                    changeWall.command = [Quickshell.env("HOME") + "/.config/quickshell/scripts/change-wallpaper.sh", path];
                    changeWall.running = true;
                }

                Keys.onPressed: (event) => {
                    if (event.key === Qt.Key_H) { moveCurrentIndexLeft(); event.accepted = true; }
                    else if (event.key === Qt.Key_L) { moveCurrentIndexRight(); event.accepted = true; }
                    else if (event.key === Qt.Key_K) { moveCurrentIndexUp(); event.accepted = true; }
                    else if (event.key === Qt.Key_J) { moveCurrentIndexDown(); event.accepted = true; }
                    else if (event.key === Qt.Key_Return) {
                        wallGrid.applyWallpaper(wallGrid.currentItem.fileUrl.toString().replace("file://", ""));
                        event.accepted = true;
                    }
                    else if (event.key === Qt.Key_Slash) {
                        pathInput.forceActiveFocus();
                        pathInput.selectAll();
                        event.accepted = true;
                    }
                }
            }
        }

        

        
    }
}
