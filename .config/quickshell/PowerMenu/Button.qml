import QtQuick
import QtQuick.Controls
import qs.Theme

RoundButton {
    id: button
    text: "question_mark"
    implicitHeight: 75
    implicitWidth: 75
    property bool selected: false

    contentItem: Text {
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: button.selected ? Theme.on_secondary_fixed : Theme.primary
        font.family: Theme.iconFontFamily
        font.pixelSize: 50
        text: button.text
    }

    background: Rectangle {
        radius: button.radius
        color: button.selected ? Theme.primary : Qt.rgba(Theme.background.r, Theme.background.g, Theme.background.b, 0.72)
        border.color: button.selected ? Theme.primary : Theme.on_secondary_fixed
        border.width: button.selected ? 3 : 2
        antialiasing: true
    }
}