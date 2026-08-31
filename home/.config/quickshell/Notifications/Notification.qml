import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import qs.Theme

Scope {
    id: root

    IpcHandler {
        target: "notifications"
        function toggle(): void { NotificationCenterState.centerOpen = !NotificationCenterState.centerOpen }
        function show() : void { NotificationCenterState.centerOpen = true }
        function hide() : void { NotificationCenterState.centerOpen = false }
    }

    Popup {}
    NotificationCenter {}
    
}