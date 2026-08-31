return {
	"akinsho/toggleterm.nvim",
	opts = {
		highlights = {
			Normal = { link = "Normal" },
			NormalNC = { link = "NormalNC" },
			NormalFloat = { link = "NormalFloat" },
			FloatBorder = { link = "FloatBorder" },
			StatusLine = { link = "StatusLine" },
			StatusLineNC = { link = "StatusLineNC" },
			WinBar = { link = "WinBar" },
			WinBarNC = { link = "WinBarNC" },
		},
		size = 10,
		---@param t Terminal
		on_create = function(t)
			vim.opt_local.foldcolumn = "0"
			vim.opt_local.signcolumn = "no"
			if t.hidden then
				local toggle = function()
					t:toggle()
				end
			end
		end,
		shading_factor = 2,
		direction = "float",
		float_opts = { border = "rounded" },
	},
	config = function(_, opts)
		require("toggleterm").setup(opts)

		local Terminal = require("toggleterm.terminal").Terminal

		local serpl = Terminal:new({
			cmd = "serpl",
			hidden = true,
			direction = "float",
			float_opts = {
				border = "rounded",
			},
		})

		vim.keymap.set("n", "<leader>tr", function()
			serpl:toggle()
		end, { desc = "toggle serpl (search & replace) terminal" })

		local function set_terminal_keymaps()
			local map_opts = { buffer = 0 }
			local ft = vim.bo.filetype
			local is_lazygit = ft == "lazygit"
			local is_tfm = ft == "tfm"

			if not (is_lazygit or is_tfm) then
				vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], map_opts)
				vim.keymap.set("t", "jk", [[<C-\><C-n>]], map_opts)
				vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], map_opts)
			end

			if not is_tfm then
				vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], map_opts)
			end

			vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], map_opts)
			vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], map_opts)
			vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], map_opts)
		end

		vim.api.nvim_create_autocmd("TermOpen", {
			pattern = "term://*",
			callback = set_terminal_keymaps,
		})
	end,
}
