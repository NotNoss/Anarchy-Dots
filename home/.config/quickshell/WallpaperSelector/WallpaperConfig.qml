pragma Singleton
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    // Points at the old persistence file only after the new one is found missing,
    // which triggers the one-time migration read below.
    property string legacyPath: ""

    readonly property string wallpaperDir: adapter.wallpaperDir.startsWith("~")
        ? Quickshell.env("HOME") + adapter.wallpaperDir.slice(1)
        : adapter.wallpaperDir

    function setWallpaperDir(path) {
        const home = Quickshell.env("HOME")
        adapter.wallpaperDir = path.startsWith(home) ? "~" + path.slice(home.length) : path
    }

    FileView {
        id: view
        path: Quickshell.env("HOME") + "/.config/anarchy/cache/wallpaper-selector.json"
        watchChanges: true
        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()
        onLoadFailed: (error) => {
            if (error === FileViewError.FileNotFound)
                root.legacyPath = Quickshell.env("HOME") + "/.config/quickshell/wallpaper-selector.json"
        }

        JsonAdapter {
            id: adapter
            property string wallpaperDir: "~/.config/anarchy/Wallpapers"
        }
    }

    // One-time migration from the old location. Loads only once legacyPath is set
    // (i.e. the new file was absent), so it can never overwrite a value already
    // read from the new location. Assigning the adapter fires onAdapterUpdated
    // above, persisting the value to the new path.
    FileView {
        id: legacyView
        path: root.legacyPath
        printErrors: false
        onLoaded: {
            try {
                const data = JSON.parse(legacyView.text())
                if (data && data.wallpaperDir)
                    adapter.wallpaperDir = data.wallpaperDir
            } catch (e) {}
        }
    }
}
