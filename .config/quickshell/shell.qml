import Quickshell
import Quickshell.Io
import qs.PillBar
import "PillBar"
import "Notifications"
import "WallpaperSelector"
import "PowerMenu"
import "AppLauncher"
import "Keybinds"
import "CalendarApp"
import "Theme"

ShellRoot {
    IpcHandler {
        target: "theme-manager"
        function reload(): void {
            Theme.reloadTheme()
        }
    }

    Variants {
        model: {
            const mons = BarConfig.monitors
            return (mons && mons.length > 0)
                ? Quickshell.screens.filter(s => mons.includes(s.name))
                : Quickshell.screens
        }

        Bar {
            required property var modelData
            screen: modelData
        }
    }

    Notification {}
    WallpaperSelector {}
    PowerMenu {}
    AppLauncher {}
    Keybinds {}
    CalendarWindow {}
}
