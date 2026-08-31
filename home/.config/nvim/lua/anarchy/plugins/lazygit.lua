return {
	"kdheepak/lazygit.nvim",
	cmd = {
		"LazyGit",
		"LazyGitConfig",
		"LazyGitCurrentFile",
		"LazyGitFilter",
		"LazyGitFilterCurrentFile",
	},
	-- optional for floating window border decoration
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local function close_lazygit_window(bufnr)
			for _, win in ipairs(vim.fn.win_findbuf(bufnr)) do
				if vim.api.nvim_win_is_valid(win) then
					pcall(vim.api.nvim_win_close, win, true)
				end
			end
			if vim.api.nvim_buf_is_valid(bufnr) then
				pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
			end
		end

		vim.api.nvim_create_autocmd("TermOpen", {
			pattern = "term://*",
			callback = function(args)
				if vim.bo[args.buf].filetype ~= "lazygit" then
					return
				end
				vim.keymap.set("t", "<C-q>", function()
					close_lazygit_window(args.buf)
				end, { buffer = args.buf, desc = "force-close lazygit" })
			end,
		})

		vim.api.nvim_create_autocmd("TermClose", {
			pattern = "term://*",
			callback = function(args)
				if vim.bo[args.buf].filetype ~= "lazygit" then
					return
				end
				vim.schedule(function()
					close_lazygit_window(args.buf)
				end)
			end,
		})
	end,
}
