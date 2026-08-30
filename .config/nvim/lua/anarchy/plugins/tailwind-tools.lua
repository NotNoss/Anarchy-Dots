return {
	"luckasRanarison/tailwind-tools.nvim",
	dependencies = { "echasnovski/mini.nvim" },
	opts = {
		-- disable tailwind-tools' own server setup: it still calls the
		-- deprecated `require('lspconfig').tailwindcss.setup()` API, which
		-- prints a stack traceback on every startup. We configure
		-- tailwindcss ourselves in lsp/lspconfig.lua and let mason-lspconfig
		-- enable it instead (see lsp/mason.lua).
		server = {
			override = false,
		},
		document_color = {
			enabled = true, -- can be toggled by commands
			kind = "inline", -- "inline" | "foreground" | "background"
			inline_symbol = "󰝤 ", -- only used in inline mode
			debounce = 200, -- in milliseconds, only applied in insert mode
		},
		conceal = {
			enabled = false, -- can be toggled by commands
			min_length = nil, -- only conceal classes exceeding the provided length
			symbol = "󱏿", -- only a single character is allowed
			highlight = { -- extmark highlight options, see :h 'highlight'
				fg = "#38BDF8",
			},
		},
		custom_filetypes = {}, -- see the extension section to learn how it works
	},
}
