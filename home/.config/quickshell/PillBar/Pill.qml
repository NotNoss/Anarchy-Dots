import QtQuick
import QtQuick.Layouts
import qs.Theme

Rectangle {
    id: root

    property string icon: ""
    property string label: ""
    property color iconColor: Theme.primary
    property int maxLabelWidth: 400
    property bool interactive: false
    signal clicked()

    implicitWidth: row.implicitWidth + 22
    implicitHeight: 30
    radius: height / 2
    color: Qt.rgba(Theme.background.r, Theme.background.g, Theme.background.b, 0.72)

    MouseArea {
        anchors.fill: parent
        enabled: root.interactive
        cursorShape: root.interactive ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: root.clicked()
    }

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 7

        Text {
            text: root.icon
            color: root.iconColor
            font.family: Theme.iconFontFamily
            font.pixelSize: 16
        }

        Text {
            text: root.label
            color: Theme.primary
            font.family: Theme.fontFamily
            font.pixelSize: 16
            elide: Text.ElideRight
            Layout.maximumWidth: root.maxLabelWidth
            visible: root.label !== ""
        }
    }
}