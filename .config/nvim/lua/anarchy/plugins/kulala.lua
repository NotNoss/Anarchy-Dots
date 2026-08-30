return {
	"mistweaverco/kulala.nvim",
	config = function()
		require("kulala").setup({
			default_view = "body",
			default_env = "dev",
			debug = false,
		})
	end,
}
