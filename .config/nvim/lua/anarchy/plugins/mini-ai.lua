local ai = require("mini.ai")

return {
	"echasnovski/mini.nvim",
	version = "*",
	ai.setup({
		custom_textobjects = {
			s = { "%[%[().-()%]%]" },
			F = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
		},
	}),
}
