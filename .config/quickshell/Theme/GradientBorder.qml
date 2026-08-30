import QtQuick
import QtQuick.Shapes
import qs.Theme

// Rounded-rect gradient outline matching Hyprland general:col.active_border
// (on_primary_container -> on_primary at 45deg, border_size 2). Drop it inside
// any Rectangle as a child, after removing that Rectangle's border.* group.
Shape {
    id: root
    anchors.fill: parent
    preferredRendererType: Shape.CurveRenderer

    property real radius: 10
    property real borderWidth: 2
    property color startColor: Theme.on_primary_container
    property color endColor: Theme.on_primary

    ShapePath {
        strokeWidth: 0
        fillRule: ShapePath.OddEvenFill
        fillGradient: LinearGradient {
            x1: 0; y1: 0
            x2: root.width; y2: root.height          // panel diagonal ~= Hyprland's 45deg
            GradientStop { position: 0.0; color: root.startColor }
            GradientStop { position: 1.0; color: root.endColor }
        }
        PathRectangle {                              // outer edge
            x: 0; y: 0
            width: root.width; height: root.height
            radius: root.radius
        }
        PathRectangle {                              // inner edge -> ring via OddEvenFill
            x: root.borderWidth; y: root.borderWidth
            width: root.width - root.borderWidth * 2
            height: root.height - root.borderWidth * 2
            radius: Math.max(0, root.radius - root.borderWidth)
        }
    }
}
