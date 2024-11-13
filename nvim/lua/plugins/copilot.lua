return {
	"zbirenbaum/copilot.lua",
	event = { "InsertEnter" },
	cmd = "Copilot",
	build = ":Copilot auth",
	opts = {
		suggestion = {
			enabled = true,
			auto_trigger = true,
			-- M key doesn't work through iTerm2 so let's specify different mappings
			-- assuming iTerm2 is configured to translate left option key into Esc+
			keymap = {
				accept = "<Tab>",
				accept_word = "<Esc>w",
				accept_line = false,
				next = "<Esc>]",
				prev = "<Esc>[",
				dismiss = "<C-]>",
			},
		},
		panel = { enabled = false },
		filetypes = {
			markdown = true,
			help = true,
			gitcommit = true,
		},
	},
}
