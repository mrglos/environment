return {
	-- folke colorscheme configuration
	{
		"0xstepit/flow.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("flow").setup({
				dark_theme = true,
				transparent = true, -- Set transparent background.
				high_contrast = false, -- Make the dark background darker or light background lighter.
				fluo_color = "pink", --  Color used as fluo: pink, yellow, orange or green.
				mode = "base", -- Intensity of the palette: dark, bright, desaturate or base.
				aggressive_spell = false, -- Use colors for spell check.
			})

			vim.opt.fillchars = "eob:⋅" -- my mod: do not display tildas at the end of the buffer
			vim.cmd("colorscheme flow")

			-- "fix" visual settings for todo-comments
			local todoHlGroups = {
				"todoBgTODO",
				"todoBgWARN",
				"todoBgFIX",
				"todoBgNOTE",
			}
			for _, hlGroupName in ipairs(todoHlGroups) do
				local hlDefinition = vim.api.nvim_get_hl(0, { name = hlGroupName })
				hlDefinition.bold = true
				vim.api.nvim_set_hl(0, hlGroupName, hlDefinition)
			end
		end,
	},
}
