pragma Singleton
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    // List of monitor names the pill bar should appear on.
    // Empty -> show on every connected monitor.
    readonly property var monitors: adapter.monitors

    FileView {
        id: view
        path: Quickshell.env("HOME") + "/.config/quickshell/pillbar.json"
        watchChanges: true
        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()

        JsonAdapter {
            id: adapter
            property var monitors: []
        }
    }
}
