return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	dependencies = {
		{ "windwp/nvim-ts-autotag", branch = "main" },
	},
	config = function()
		-- parsers/queries to keep installed (installed asynchronously, no-op if present)
		local ensure_installed = {
			"json",
			"javascript",
			"typescript",
			"tsx",
			"yaml",
			"html",
			"css",
			"prisma",
			"markdown",
			"markdown_inline",
			"svelte",
			"graphql",
			"bash",
			"lua",
			"vim",
			"dockerfile",
			"gitignore",
			"query",
			"vimdoc",
			"c",
			"go",
		}
		require("nvim-treesitter").install(ensure_installed)

		-- enable treesitter features for any buffer whose language has a parser
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("anarchy_treesitter", { clear = true }),
			callback = function(args)
				local buf = args.buf

				-- skip noice/nui popups, terminals, and other non-file UI buffers
				if vim.bo[buf].buftype ~= "" then
					return
				end

				local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype) or vim.bo[buf].filetype

				-- language.add returns `nil, err` (does not raise) when no parser exists,
				-- so its return value is the real gate
				local ok, added = pcall(vim.treesitter.language.add, lang)
				if not (ok and added) then
					return
				end

				-- syntax highlighting (provided by Neovim)
				vim.treesitter.start(buf, lang)

				-- folds (provided by Neovim); start with everything unfolded
				vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
				vim.wo.foldmethod = "expr"
				vim.wo.foldlevel = 99

				-- indentation (provided by nvim-treesitter, experimental)
				vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})

		-- autotagging: on the `main` branch this is a standalone plugin, not a
		-- nvim-treesitter module, so it needs its own setup call
		require("nvim-ts-autotag").setup()
	end,
}
