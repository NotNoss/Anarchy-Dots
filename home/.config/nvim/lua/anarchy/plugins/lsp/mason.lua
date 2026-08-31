return {
	"mason-org/mason.nvim",
	dependencies = {
		"mason-org/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		-- import mason
		local mason = require("mason")

		-- import mason-lspconfig
		local mason_lspconfig = require("mason-lspconfig")

		local mason_tool_installer = require("mason-tool-installer")

		-- enable mason and configure icons
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_lspconfig.setup({
			-- list of servers for mason to install (lspconfig server names,
			-- not mason package names)
			ensure_installed = {
				"gopls",
				"lua_ls",
				"bashls",
				"ts_ls",
				"html",
				"cssls",
				"tailwindcss",
				"clangd",
				"jsonls",
				"powershell_es",
			},
		})

		mason_tool_installer.setup({
			ensure_installed = {
				"goimports",
				"shfmt",
				"stylua",
				"prettier",
				"jq",
			},
		})
	end,
}
