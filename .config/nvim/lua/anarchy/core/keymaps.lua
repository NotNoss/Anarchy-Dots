local map = vim.keymap.set

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- General
map("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
map("i", "<C-e>", "<End>", { desc = "move end of line" })
map("i", "<C-h>", "<Left>", { desc = "move left" })
map("i", "<C-l>", "<Right>", { desc = "move right" })
map("i", "<C-j>", "<Down>", { desc = "move down" })
map("i", "<C-k>", "<Up>", { desc = "move up" })

map("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })

map("n", "<C-h>", "<C-w>h", { desc = "switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "switch window up" })

map("n", "<C-s>", "<cmd>w<CR>", { desc = "file save" })
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "file copy whole" })
map("v", "<C-c>", '"+y', { desc = "copy selection to clipboard" })
map("n", "<C-v>", '"+p', { desc = "paste from clipboard" })

map("n", "<leader>sv", "<C-w>v", { desc = "split window vertically" })
map("n", "<leader>sh", "<C-w>s", { desc = "split window horizontally" })
map("n", "<leader>se", "<C-w>=", { desc = "make splits equal size" })
map("n", "<leader>sx", "<cmd>close<CR>", { desc = "close current split" })

-- Comment
map("n", "<C-/>", "gcc", { desc = "comment toggle", remap = true })
map("v", "<C-/>", "gc", { desc = "comment toggle", remap = true })

-- Buffers
map("n", "<tab>", "<cmd>bnext<CR>", { desc = "buffer next" })
map("n", "<S-tab>", "<cmd>bprev<CR>", { desc = "buffer previous" })
map("n", "<S-q>", "<cmd>bdelete!<CR>", { desc = "close buffer" })

-- Lazygit
map("n", "<leader>lg", "<cmd>LazyGit<CR>", { desc = "open lazy git" })

-- Whichkey
map("n", "<leader>wK", "<cmd>WhichKey <CR>", { desc = "whichkey all maps" })

map("n", "<leader>wk", function()
	vim.cmd("WhichKey " .. vim.fn.input("WhichKey: "))
end, { desc = "whichkey query lookup" })

-- TFM
-- Always hand the file manager a real path: the current file when it is a
-- readable file, otherwise the cwd. Passing a non-file buffer name (e.g. the
-- mini.starter dashboard's "ministarter://1/welcome") makes newer yazi abort
-- with "unknown VFS authority".
local function tfm_open(mode)
	local file = vim.fn.expand("%:p")
	local path = vim.fn.filereadable(file) == 1 and file or vim.fn.getcwd()
	require("tfm").open(path, mode)
end

map("n", "<leader>e", function() tfm_open() end, { desc = "tfm open" })
map("n", "<leader>ee", function() tfm_open() end, { desc = "tfm open" })
map("n", "<leader>mh", function() tfm_open("split") end, { desc = "tfm horizontal split" })
map("n", "<leader>mv", function() tfm_open("vsplit") end, { desc = "tfm vertical split" })
map("n", "<leader>mt", function() tfm_open("tabedit") end, { desc = "tfm new tab" })

-- Code Companion
map("n", "<leader>cc", "<cmd>CodeCompanionChat Toggle<CR>", { desc = "Code Companion Chat Toggle" })
map("n", "<leader>ca", "<cmd>CodeCompanionActions<CR>", { desc = "Code Companion Actions Open" })

-- Indent
map("v", "<", "<gv", { desc = "indent left" })
map("v", ">", ">gv", { desc = "indent right" })

-- Toggle Term
map("n", "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", { desc = "toggle floating terminal" })
map("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "toggle horizontal terminal" })
map("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", { desc = "toggle vertical terminal" })
map("n", "<leader>tt", "<cmd>ToggleTerm direction=tab<CR>", { desc = "toggle tab terminal" })
map("n", "<leader>ts", "<cmd>TermSelect<CR>", { desc = "select open terminal" })

-- Kulala
map("n", "<leader>ktv", "<cmd>lua require('kulala').toggle_view()<CR>", { desc = "kulala toggle view" })
map("n", "<leader>kr", "<cmd>lua require('kulala').run()<CR>", { desc = "kulala run" })
map("n", "<leader>kjn", "<cmd>lua require('kulala').jump_next()<CR>", { desc = "kulala jump next" })
map("n", "<leader>kjn", "<cmd>lua require('kulala').jump_previous()<CR>", { desc = "kulala jump previous" })

-- Namu
map("n", "<leader>nm", "<cmd>Namu symbols<CR>", { desc = "Open symbols picker" })

-- Obsidian
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		map("n", "<leader>nn", "<cmd>ObsidianToday<CR>", { desc = "Open daily note for today", buffer = true })
		map("n", "<leader>nnt", "<cmd>ObsidianTomorrow<CR>", { desc = "Open daily note for tomorrow", buffer = true })
		map("n", "<leader>nny", "<cmd>ObsidianYesterday<CR>", { desc = "Open daily note for yesterday", buffer = true })
		map(
			"n",
			"<leader>tc",
			"<cmd>ObsidianToggleCheckbox<CR>",
			{ desc = "Cycle through checkbox options", buffer = true }
		)
		map(
			"n",
			"<leader>bl",
			"<cmd>ObsidianBacklinks<CR>",
			{ desc = "Get a list of links to this file", buffer = true }
		)
		map("n", "<leader>fl", "<cmd>ObsidianFolllowLink<CR>", { desc = "Follow Obsidian Link", buffer = true })
		map(
			"n",
			"<leader>flv",
			"<cmd>ObsidianFolllowLink vsplit<CR>",
			{ desc = "Follow Obsidian Link Vertical Split", buffer = true }
		)
		map(
			"n",
			"<leader>flh",
			"<cmd>ObsidianFolllowLink hsplit<CR>",
			{ desc = "Follow Obsidian Link Horizontal Split", buffer = true }
		)
		map("n", "<leader>toc", "<cmd>ObsidianTOC<CR>", { desc = "Obsidian Table of Contents", buffer = true })
	end,
})
