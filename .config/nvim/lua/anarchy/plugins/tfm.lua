return {
	"rolv-apneseth/tfm.nvim",
	lazy = false,
	opts = {
		file_manager = "yazi",
		replace_netrw = true,
		-- Enable creation of commands
		-- Default: false
		-- Commands:
		--   Tfm: selected file(s) will be opened in the current window
		--   TfmSplit: selected file(s) will be opened in a horizontal split
		--   TfmVsplit: selected file(s) will be opened in a vertical split
		--   TfmTabedit: selected file(s) will be opened in a new tab page
		enable_cmds = true,
		-- Custom keybindings only applied within the TFM buffer
		-- Default: {}
		keybindings = {
			["<ESC>"] = "q",
			-- Override the open mode (i.e. vertical/horizontal split, new tab)
			-- Tip: you can add an extra `<CR>` to the end of these to immediately open the selected file(s) (assuming the TFM uses `enter` to finalise selection)
			["<C-v>"] = "<C-\\><C-O>:lua require('tfm').set_next_open_mode(require('tfm').OPEN_MODE.vsplit)<CR>",
			["<C-x>"] = "<C-\\><C-O>:lua require('tfm').set_next_open_mode(require('tfm').OPEN_MODE.split)<CR>",
			["<C-t>"] = "<C-\\><C-O>:lua require('tfm').set_next_open_mode(require('tfm').OPEN_MODE.tabedit)<CR>",
		},
		ui = {
			border = "rounded",
			height = 1,
			width = 1,
			x = 0.5,
			y = 0.5,
		},
	},
	-- keybindings live in lua/anarchy/core/keymaps.lua (they route through a
	-- helper that always passes a real path to the file manager)
}
