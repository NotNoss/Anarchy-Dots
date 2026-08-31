-- NVIDIA
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("NVD_BACKEND", "direct")

-- Workspaces: 1-3 center (DP-2), 4-6 left (HDMI-A-1), 7-9 right (DP-1)
-- One `default = true` per monitor so each screen lands on its workspace at login.
hl.workspace_rule({ workspace = "1", monitor = "DP-2", default = true, persistent = true })
hl.workspace_rule({ workspace = "2", monitor = "DP-2", persistent = true })
hl.workspace_rule({ workspace = "3", monitor = "DP-2", persistent = true })
hl.workspace_rule({ workspace = "4", monitor = "HDMI-A-1", default = true, persistent = true })
hl.workspace_rule({ workspace = "5", monitor = "HDMI-A-1", persistent = true })
hl.workspace_rule({ workspace = "6", monitor = "HDMI-A-1", persistent = true })
hl.workspace_rule({ workspace = "7", monitor = "DP-1", default = true, persistent = true })
hl.workspace_rule({ workspace = "8", monitor = "DP-1", persistent = true })
hl.workspace_rule({ workspace = "9", monitor = "DP-1", persistent = true })

-- Focus center at login
hl.exec_cmd("hyprctl dispatch focusmonitor DP-2")

-- Start on startup
hl.on("hyprland.start", function()
	hl.dispatch(hl.dsp.exec_cmd("goxlr-daemon"))
	-- hl.dispatch(hl.dsp.exec_cmd("protonmail-bridge"))
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
