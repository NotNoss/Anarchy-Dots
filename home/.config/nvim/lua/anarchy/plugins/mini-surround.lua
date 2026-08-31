return {
	"echasnovski/mini.nvim",
	version = "*",
	require("mini.surround").setup({
		custom_surroundings = {
			s = { input = { "%[%[().-()%]%]" }, output = { left = "[[", right = "]]" } },
			c = { input = { "%[%[().-()%]%]" }, output = { left = "{{", right = "}}" } },
			p = { input = { "%[%[().-()%]%]" }, output = { left = "((", right = "))" } },
			a = { input = { "%[%[().-()%]%]" }, output = { left = "<<", right = ">>" } },
		},
	}),
}
