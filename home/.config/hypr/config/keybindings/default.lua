local mainMod = "SUPER"
local launchPrefix = "" -- if you are not using UWSM, make this empty (e.g. "")

---------------------------
---- WINDOW MANAGEMENT ----
---------------------------

-- Window manipulation
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd("hyprctl kill"), { description = "Close Hyprland" })
hl.bind(mainMod .. " + Q", hl.dsp.window.close(), { description = "Close active window" })
hl.bind(mainMod .. " + ALT + Space", hl.dsp.window.float({ action = "toggle" }), { description = "Toggle floating" })
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen(), { description = "Toggle fullscreen" })
hl.bind(mainMod .. " + Y", hl.dsp.layout("togglesplit"), { description = "Toggle split" })

-- Screenshot
hl.bind(
	mainMod .. " + S",
	hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot.sh region"),
	{ description = "Take region screenshot" }
)
hl.bind(
	mainMod .. " + CONTROL + S",
	hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot.sh monitor"),
	{ description = "Take a screenshot of focused monitor" }
)
hl.bind(
	mainMod .. " + SHIFT + S",
	hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot.sh window"),
	{ description = "Take a screenshot of focused window" }
)

-- Window resize
local left = { x = -20, y = 0, relative = true }
local right = { x = 20, y = 0, relative = true }
local up = { x = 0, y = -20, relative = true }
local down = { x = 0, y = 20, relative = true }

hl.bind(mainMod .. " + ALT + H", hl.dsp.window.resize(left), { description = "Resize left", repeating = true })
hl.bind(mainMod .. " + ALT + L", hl.dsp.window.resize(right), { description = "Resize right", repeating = true })
hl.bind(mainMod .. " + ALT + K", hl.dsp.window.resize(up), { description = "Resize up", repeating = true })
hl.bind(mainMod .. " + ALT + J", hl.dsp.window.resize(down), { description = "Resize down", repeating = true })

-- Change focus
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }), { description = "Change focus left" })
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }), { description = "Change focus right" })
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }), { description = "Change focus up" })
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }), { description = "Change focus down" })
hl.bind("ALT + Tab", hl.dsp.window.cycle_next(), { description = "Cycle through windows" })

-- Move active window around workspaces & monitors
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "u" }), { description = "Move window up" })
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "r" }), { description = "Move window right" })
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "l" }), { description = "Move window left" })
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "d" }), { description = "Move window down" })

for i = 1, 10 do
	local key = i % 10
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }), { description = "Focus on workspace" })
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }), "Move window to workspace")
end

-- Zoom
local function zoomfunction(value)
	local zoomvalue = hl.get_config("cursor:zoom_factor")
	if (zoomvalue + value) > 3.0 then
		hl.config({ cursor = { zoom_factor = 3.0 } })
	elseif (zoomvalue + value) < 1.0 then
		hl.config({ cursor = { zoom_factor = 1.0 } })
	else
		hl.config({ cursor = { zoom_factor = zoomvalue + value } })
	end
end
hl.bind(mainMod .. " + SHIFT + M", function()
	zoomfunction(-0.3)
end, { repeating = true }, { description = "Zoom out" })
hl.bind(mainMod .. " + SHIFT + P", function()
	zoomfunction(0.3)
end, { repeating = true }, { description = "Zoom in" })

------------------
---- LAUNCHER ----
------------------

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(launchPrefix .. TERMINAL), { description = "Launch terminal" })
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(launchPrefix .. FILE_MANAGER), { description = "Launch file explorer" })
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd(launchPrefix .. EDITOR), { description = "Open text editor" })
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(launchPrefix .. CALCULATOR), { description = "Launch Calculator" })
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(launchPrefix .. BROWSER), { description = "Launch browser" })
hl.bind(
	mainMod .. " + N",
	hl.dsp.exec_cmd("qs ipc call notifications toggle"),
	{ description = "Launch notification center" }
)
hl.bind(
	mainMod .. " + W",
	hl.dsp.exec_cmd("qs ipc call wallpaper toggle"),
	{ description = "Launch wallpaper selecton" }
)
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("qs ipc call power toggle"), { description = "Launch power menu" })
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("qs ipc call launcher toggle"), { description = "Launch app launcher" })
hl.bind(
	mainMod .. " + ALT + K",
	hl.dsp.exec_cmd("qs ipc call keybinds toggle"),
	{ description = "Launch keybind cheatsheet" }
)
hl.bind(
	mainMod .. " + SHIFT + C",
	hl.dsp.exec_cmd("qs ipc call calendar toggle"),
	{ description = "Launch calendar app" }
)

-------------------------------
---- WORKSPACES & MONITORS ----
-------------------------------

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.window.move({ workspace = "special" }))
hl.bind(mainMod .. " + CONTROL + P", hl.dsp.workspace.toggle_special())
