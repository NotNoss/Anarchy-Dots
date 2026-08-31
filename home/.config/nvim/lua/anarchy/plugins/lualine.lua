return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "echasnovski/mini.nvim" },
	config = function()
		local lualine = require("lualine")
		local lazy_status = require("lazy.status") -- to configure lazy pending updates count

		-- Read a color from a highlight group, resolving links.
		-- Falls back to the given hex if the group/attr isn't set.
		local function hl(group, attr, fallback)
			local ok, h = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
			if ok and h and h[attr] then
				return string.format("#%06x", h[attr])
			end
			return fallback
		end

		-- Pull colors from groups your matugen colorscheme sets.
		-- The group -> color mappings are just picks of distinct accents;
		-- adjust them to taste (or to whatever your matugen plugin exposes).
		local function make_colors()
			return {
				bg = hl("Normal", "bg", "#112638"),
				fg = hl("Normal", "fg", "#c3ccdc"),
				blue = hl("Function", "fg", "#65D1FF"),
				green = hl("String", "fg", "#3EFFDC"),
				violet = hl("Keyword", "fg", "#FF61EF"),
				yellow = hl("Type", "fg", "#FFDA7B"),
				red = hl("DiagnosticError", "fg", "#FF4A4A"),
				inactive_bg = hl("StatusLineNC", "bg", "#2c3043"),
			}
		end

		local function make_theme()
			local c = make_colors()
			local dim = { bg = c.bg, fg = c.fg }
			return {
				normal = {
					a = { bg = c.blue, fg = c.bg, gui = "bold" },
					b = dim,
					c = dim,
				},
				insert = {
					a = { bg = c.green, fg = c.bg, gui = "bold" },
					b = dim,
					c = dim,
				},
				visual = {
					a = { bg = c.violet, fg = c.bg, gui = "bold" },
					b = dim,
					c = dim,
				},
				command = {
					a = { bg = c.yellow, fg = c.bg, gui = "bold" },
					b = dim,
					c = dim,
				},
				replace = {
					a = { bg = c.red, fg = c.bg, gui = "bold" },
					b = dim,
					c = dim,
				},
				inactive = {
					a = { bg = c.inactive_bg, fg = c.fg, gui = "bold" },
					b = { bg = c.inactive_bg, fg = c.fg },
					c = { bg = c.inactive_bg, fg = c.fg },
				},
			}
		end

		local function setup()
			lualine.setup({
				options = {
					theme = make_theme(),
				},
				sections = {
					lualine_x = {
						{
							lazy_status.updates,
							cond = lazy_status.has_updates,
							color = { fg = "#ff9e64" },
						},
						{ "encoding" },
						{ "fileformat" },
						{ "filetype" },
					},
				},
			})
		end

		setup()

		-- Rebuild the theme whenever the colorscheme changes.
		-- If your matugen plugin re-runs `:colorscheme` on reload, this fires
		-- automatically and the statusline updates with your wallpaper.
		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = setup,
		})
	end,
}
