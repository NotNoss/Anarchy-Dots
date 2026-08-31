pragma Singleton
import QtQuick

QtObject {
    readonly property string fontFamily: "RedHatDisplay Nerd Font"
    readonly property string iconFontFamily: "Material Symbols Rounded"

    <* for name, value in colors *>
        readonly property color {{name}}: "{{value.default.hex}}"
    <* endfor *>
}
