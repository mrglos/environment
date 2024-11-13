return {
	"nvim-tree/nvim-tree.lua",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		local nvimtree = require("nvim-tree")

		-- Recommended settings from nvim-tree documentation.
		-- Disable netrw entirely.
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugins = 1

		nvimtree.setup({
			git = {
				timeout = 5000, -- set git timeout to 5s, default 400ms timeuts too often on Samsara's huge monrepo
			},
			view = {
				width = 55,
				relativenumber = true,
			},
			-- Change folder arrow icons.
			renderer = {
				group_empty = true,
				-- highlight_opened_files = "all",
				indent_markers = {
					enable = true,
					inline_arrows = false,
					icons = {
						corner = "╰",
						edge = "│",
						item = "├",
						bottom = "─",
					},
				},
				icons = {
					show = {
						folder_arrow = false,
					},
					glyphs = {
						folder = {
							arrow_closed = "",
							arrow_open = "",
						},
					},
				},
			},
			actions = {
				open_file = {
					window_picker = {
						enable = false,
					},
				},
			},
		})

		-- Set kaymaps.
		local km = vim.keymap

		km.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
		km.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer on current file" })
		km.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" })
		km.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })
	end,
}
