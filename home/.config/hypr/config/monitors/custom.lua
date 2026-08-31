-- Monitors: DP-2 center, HDMI-A-1 left, both enabled
hl.monitor({ output = "DP-2", mode = "1920x1080@144", position = "0x0", scale = 1, disabled = false })
hl.monitor({ output = "DP-1", mode = "1920x1080@60", position = "1920x0", scale = 1, disabled = false })
hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@60", position = "-1920x0", scale = 1, disabled = false })
