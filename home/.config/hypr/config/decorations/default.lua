-- Look and feel configuration

hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 15,
		border_size = 2,
		extend_border_grab_area = 10,
		resize_on_border = true,
		col = {
			active_border = {
				colors = { primary },
				-- colors = { primary },
				-- angle = 45,
			},
			inactive_border = background,
		},
	},
	decoration = {
		dim_special = 0.3,
		rounding = 10,
		active_opacity = 0.95,
		inactive_opacity = 0.85,
		fullscreen_opacity = 1,
		blur = {
			size = 5,
			passes = 4,
			special = false,
		},
	},
})
