return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = {
		-- auto-closing for TS
		"windwp/nvim-ts-autotag",
	},
	config = function()
		local treesitter = require("nvim-treesitter.configs")

		treesitter.setup({
			-- enable syntax highlighting
			highlight = { enable = true },
			-- enable indentation
			indent = { enable = true },
			-- enable autotagging with nvim-ts-autotag plugin
			autotag = { enable = true },
			-- ensure these languages parsers are installed
			ensure_installed = {
				"json",
				"yaml",

				"javascript",
				"typescript",
				"tsx",
				"html",
				"css",

				"markdown",
				"markdown_inline",

				"graphql",
				"regex",

				"bash",
				"lua",
				"vim",
				"vimdoc",

				"go",
				"python",

				"dockerfile",
				"gitcommit",
				"gitignore",
				"proto",
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
		})
	end,
}
