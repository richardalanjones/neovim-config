-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
	-- In this case, we create a function that lets us more easily define mappings specific
	-- for LSP related items. It sets the mode, buffer and description for us each time.
	local nmap = function(keys, func, desc)
		if desc then
			desc = 'LSP: ' .. desc
		end

		vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
	end

	nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
	nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

	nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
	nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
	nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
	nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
	nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
	nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

	-- See `:help K` for why this keymap
	nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
	nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

	-- Lesser used LSP functionality
	nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
	nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
	nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
	nmap('<leader>wl', function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, '[W]orkspace [L]ist Folders')

	-- Create a command `:Format` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
		vim.lsp.buf.format()
	end, { desc = 'Format current buffer with LSP' })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
	-- clangd = {},
	-- gopls = {},
	pyright = {},
	rust_analyzer = {},
	tsserver = {},
	lua_ls = {
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
			diagnostics = {
				globals = { 'vim' },
			},
		},
	},
}

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require('mason').setup()

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
	ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
	function(server_name)
		require('lspconfig')[server_name].setup {
			capabilities = capabilities,
			on_attach = on_attach,
			settings = servers[server_name],
		}
	end,
}





--vim.api.nvim_create_autocmd('User', {
--	pattern = 'LspAttached',
--	desc = 'LSP actions',
--	callback = function()
--		local bufmap = function(mode, lhs, rhs)
--			local opts = { buffer = true }
--			vim.keymap.set(mode, lhs, rhs, opts)
--		end
--		-- Displays hover information about the symbol under the cursor
--		bufmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')
--		-- Jump to the definition
--		bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
--		-- Jump to declaration
--		bufmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')
--		-- Lists all the implementations for the symbol under the cursor
--		bufmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')
--		-- Jumps to the definition of the type symbol
--		bufmap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')
--		-- Lists all the references
--		bufmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')
--		-- Displays a function's signature information
--		bufmap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
--		-- Renames all references to the symbol under the cursor
--		bufmap('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>')
--		-- Selects a code action available at the current cursor position
--		bufmap('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>')
--		bufmap('x', '<F4>', '<cmd>lua vim.lsp.buf.range_code_action()<cr>')
--		-- Show diagnostics in a floating window
--		bufmap('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')
--		-- Move to the previous diagnostic
--		bufmap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
--		-- Move to the next diagnostic
--		bufmap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')
--	end
--})
--
--local has_lsp, lspconfig = pcall(require, "lspconfig")
--if not has_lsp then
--	return
--end
--
-----
---- Global Config
-----
--
--local lsp_defaults = {
--	flags = {
--		debounce_text_changes = 150,
--	},
--	capabilities = require('cmp_nvim_lsp').default_capabilities(
--		vim.lsp.protocol.make_client_capabilities()
--	),
--	on_attach = function(client, bufnr)
--		--    print('default on attach')
--		vim.api.nvim_exec_autocmds('User', { pattern = 'LspAttached' })
--	end
--}
--
---- set updated default config
--lspconfig.util.default_config = vim.tbl_deep_extend(
--	'force',
--	lspconfig.util.default_config,
--	lsp_defaults
--)
--
-----
---- LSP Servers
-----
--
--local lua_config = {
--	settings = {
--		Lua = {
--			runtime = {
--				version = 'LuaJIT',
--			},
--			diagnostics = {
--				globals = { 'vim' },
--			},
--			workspace = {
--				library = vim.api.nvim_get_runtime_file("", true),
--			},
--			telemetry = {
--				enable = false,
--			},
--		},
--	},
--	on_attach = function(client, bufnr)
--		lspconfig.util.default_config.on_attach(client, bufnr)
--	end
--}
--
----local rust_config = {
----	 settings = {
----      ["rust-analyzer"] = {
----        assist = {
----          importEnforceGranularity = true,
----          importPrefix = "crate"
----          },
----        cargo = {
----          allFeatures = true
----          },
----        checkOnSave = {
----          -- default: `cargo check`
----          command = "clippy"
----          },
----        },
----        inlayHints = {
----          lifetimeElisionHints = {
----            enable = true,
----            useParameterNames = true
----          },
----        },
----      }
----    }
--
---- NOTE RUST-ANALYZER is setup through rust-tools seperately
--local servers = {
--	emmet_ls = true,
--	julials = true,
--	pyright = true,
--	lua_ls = lua_config,
--	html = true,
--	tsserver = true,
--	sqlls = true,
--}
----local servers = { emmet_ls=true, eslint=true, pyright=true, sumneko_lua=lua_config, tsserver=true, julials=true, html=true }
--
--local setup_server = function(server, config)
--	if not config then
--		return
--	end
--
--	if type(config) ~= "table" then
--		config = {}
--	end
--
--	lspconfig[server].setup(config)
--end
--
--for server, config in pairs(servers) do
--	setup_server(server, config)
--end
--
--local rt = require("rust-tools")
--
--rt.setup({
--	server = {
--		on_attach = function(client, bufnr)
--			lspconfig.util.default_config.on_attach(client, bufnr)
--		end,
--		--on_attach = function(_, bufnr)
--		--  -- Hover actions
--		--  vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
--		--  -- Code action groups
--		--  vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
--		--end,
--			["rust-analyzer"] = {
--			checkOnSave = {
--				command = "clippy"
--			},
--		},
--	},
--})
