-- NVIDIA
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("NVD_BACKEND", "direct")

-- Monitors: DP-2 center, HDMI-A-1 left, both enabled
hl.monitor({ output = "DP-2", mode = "1920x1080@144", position = "0x0", scale = 1, disabled = false })
hl.monitor({ output = "DP-1", mode = "1920x1080@60", position = "1920x0", scale = 1, disabled = false })
hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@60", position = "-1920x0", scale = 1, disabled = false })

-- Workspaces: 1-5 center, 6-10 left
hl.workspace_rule({ workspace = "1", monitor = "DP-2", default = true })
hl.workspace_rule({ workspace = "2", monitor = "DP-2" })
hl.workspace_rule({ workspace = "3", monitor = "DP-2" })
hl.workspace_rule({ workspace = "4", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "5", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "6", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "7", monitor = "DP-1" })
hl.workspace_rule({ workspace = "8", monitor = "DP-1" })
hl.workspace_rule({ workspace = "9", monitor = "DP-1" })

-- Focus center at login
hl.exec_cmd("hyprctl dispatch focusmonitor DP-2")

-- Start on startup
hl.on("hyprland.start", function()
	hl.dispatch(hl.dsp.exec_cmd("goxlr-daemon"))
	hl.dispatch(hl.dsp.exec_cmd("protonmail-bridge"))
end)

-- Setup additional scratchpads
hl.workspace_rule({
	workspace = "special:term",
	on_created_empty = "[float; size 60% 60%; center] kitty --class kitty-scratch",
})

hl.workspace_rule({
	workspace = "special:music",
	on_created_empty = "[float; size 900 800; center] kitty --class spotatui-scratch spotatui",
})

-- Fix heroic launcher launching games floating
hl.window_rule({ match = { class = [[^(steam_app_\d+)$]] }, fullscreen = true })
