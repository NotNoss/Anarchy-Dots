import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import qs.CalendarApp

PanelWindow {
    id: bar

    anchors { top: true; left: true; right: true }
    implicitHeight: 40
    color: "transparent"
    WlrLayershell.namespace: "quickshell-blur"

    // Get current date/time
    Poller {
        id: clock
        command: "date +\"%I:%M %P | %a, %b %d\""
        interval: 60000
    }

    // Get volume levels
    Poller {
        id: vol
        command: "wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{printf\"%d\", $2*100}'"
    }

    // Get battery level
    // Poller {
    //     id: bat
    //     command: "cat /sys/class/power_supply/BAT0/capacity"
    //     interval: 30000
    // }

    // Get bluetooth state
    // Poller {
    //     id: bt
    //     command: "bluetoothctl show | grep -q 'Powered: yes' && echo on || echo off"
    //     interval: 5000
    // }

    // Get internal IP
    Poller {
        id: ip
        command: "ip route get 1 | awk '{print $7}'"
        interval: 60000
    }

    // Get connected wifi network
    // Poller {
    //     id: net
    //     command: "nmcli -t -f NAME connection show --active | head -n1"
    //     interval: 5000
    // }

    // Get currently playing
    readonly property var player: Mpris.players.values.find(p => p.isPlaying) ?? Mpris.players.values[0] ?? null

    RowLayout {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 15
        spacing: 8

        // Show Hyprland workspaces
        Workspaces { screen: bar.screen }

        // Show cuurrently playing
        Pill {
            icon: "music_note_2";
            maxLabelWidth: 200
            label: bar.player ? `${bar.player.trackArtist} || "Unknown"} - ${bar.player.trackTitle || ""}` : "Nothing playing"
        }
    }

    RowLayout {
        id: centerGroup
        anchors.centerIn: parent
        spacing: 8

        // Show current date/time
        Pill {
            icon: "schedule"
            label: clock.value
            interactive: true
            onClicked: CalendarState.isOpen = !CalendarState.isOpen
        }
    }

    RowLayout {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: 15
        spacing: 8

        // Show connected wifi network
        // Pill {
        //     icon: "network_wifi"
        //     label: net.value
        //     iconColor: Theme.primary
        // }

        // Show internal IP
        Pill {
            icon: "settings_ethernet"
            label: ip.value
        }

        // Show bluetooth state
        // Pill {
        //     icon: "bluetooth"
        //     label: bt.value
        // }

        // Show battery level
        // Pill {
        //     icon: "battery_android_6"
        //     label: bat.value
        // }

        // Show volume levels
        Pill {
            icon: "volume_up";
            label: vol.value + "%"
        }
    }
}