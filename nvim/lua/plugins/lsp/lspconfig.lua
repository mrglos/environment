return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", config = true }, -- this is EOL now, lazydev.nvim is recommended
	},
	config = function()
		-- -- Set different settings for different languages' LSP
		-- -- LSP list: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
		-- -- How to use setup({}): https://github.com/neovim/nvim-lspconfig/wiki/Understanding-setup-%7B%7D
		-- --     - the settings table is sent to the LSP
		-- --     - on_attach: a lua callback function to run after LSP attaches to a given buffer
		--
		-- local lspconfig = require('lspconfig')
		--
		-- -- Customized on_attach function
		-- -- See `:help vim.diagnostic.*` for documentation on any of the below functions
		-- local opts = { noremap = true, silent = true }
		-- vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
		-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
		-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
		-- vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
		--
		-- -- Use an on_attach function to only map the following keys
		-- -- after the language server attaches to the current buffer
		-- local on_attach = function(client, bufnr)
		--     -- Enable completion triggered by <c-x><c-o>
		--     vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
		--
		--     -- See `:help vim.lsp.*` for documentation on any of the below functions
		--     local bufopts = { noremap = true, silent = true, buffer = bufnr }
		--     vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
		--     vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
		--     vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
		--     vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
		--     vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
		--     vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
		--     vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
		--     vim.keymap.set('n', '<space>wl', function()
		--         print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		--     end, bufopts)
		--     vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
		--     vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
		--     vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
		--     vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
		--     vim.keymap.set("n", "<space>f", function()
		--         vim.lsp.buf.format({ async = true })
		--     end, bufopts)
		-- end
		--
		-- -- Configure each language
		-- -- How to add LSP for a specific language?
		-- -- 1. use `:Mason` to install corresponding LSP
		-- -- 2. add configuration below
		--
		-- lspconfig.pylsp.setup({
		--     on_attach = on_attach
		-- })
		local lspconfig = require("lspconfig")
		local mason_lspconfig = require("mason-lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		-- set keymap
		local km = vim.keymap

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- buffer local mappings
				-- see `:help vim.lsp.*` for documentation on any of the below functions
				local opts = { buffer = ev.buf, silent = true }

				-- set keybinds
				opts.desc = "Show LSP references"
				km.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

				opts.desc = "Go to declaration"
				km.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

				opts.desc = "Show LSP definitions"
				km.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

				opts.desc = "Show LSP implementations"
				km.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

				opts.desc = "Show LSP type definitions"
				km.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

				opts.desc = "See available code actions"
				km.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

				opts.desc = "Smart rename"
				km.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

				opts.desc = "Show buffer diagnostics"
				km.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

				opts.desc = "Show line diagnostics"
				km.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

				opts.desc = "Go to previous diagnostic"
				km.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

				opts.desc = "Go to next diagnostic"
				km.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

				opts.desc = "Show documentation for what is under the cursor"
				km.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under the cursor

				opts.desc = "Restart LSP"
				km.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
			end,
		})

		-- override options to display borders around floating window
		-- local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
		-- function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
		-- 	opts = opts or {}
		-- 	opts.border = opts.border or "rounded"
		-- 	return orig_util_open_floating_preview(contents, syntax, opts, ...)
		-- end
		local handler_overrides = {
			["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
		}

		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- change the Diagnostic symbols in the sign column (gutter)
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		mason_lspconfig.setup_handlers({
			-- default handler for installed servers
			function(server_name)
				lspconfig[server_name].setup({
					capabilities = capabilities,
					handlers = handler_overrides,
				})
			end,
			["graphql"] = function()
				-- configure graphql language server
				lspconfig["graphql"].setup({
					capabilities = capabilities,
					handlers = handler_overrides,
					filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
				})
			end,
			["lua_ls"] = function()
				-- configure lua server (with special settings)
				lspconfig["lua_ls"].setup({
					capabilities = capabilities,
					handlers = handler_overrides,
					settings = {
						Lua = {
							-- make the language server recognize "vim" global
							diagnostics = {
								globals = { "vim" },
							},
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				})
			end,
		})
	end,
}
