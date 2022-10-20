vim.api.nvim_create_autocmd('User', {
	pattern = 'LspAttached',
	desc = 'LSP actions',
	callback = function()
		local bufmap = function(mode, lhs, rhs)
			local opts = { buffer = true }
			vim.keymap.set(mode, lhs, rhs, opts)
		end
		-- Displays hover information about the symbol under the cursor
		bufmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')
		-- Jump to the definition
		bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
		-- Jump to declaration
		bufmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')
		-- Lists all the implementations for the symbol under the cursor
		bufmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')
		-- Jumps to the definition of the type symbol
		bufmap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')
		-- Lists all the references
		bufmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')
		-- Displays a function's signature information
		bufmap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
		-- Renames all references to the symbol under the cursor
		bufmap('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>')
		-- Selects a code action available at the current cursor position
		bufmap('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>')
		bufmap('x', '<F4>', '<cmd>lua vim.lsp.buf.range_code_action()<cr>')
		-- Show diagnostics in a floating window
		bufmap('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')
		-- Move to the previous diagnostic
		bufmap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
		-- Move to the next diagnostic
		bufmap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')
	end
})

local has_lsp, lspconfig = pcall(require, "lspconfig")
if not has_lsp then
	return
end

---
-- Global Config
---

local lsp_defaults = {
	flags = {
		debounce_text_changes = 150,
	},
	capabilities = require('cmp_nvim_lsp').default_capabilities(
		vim.lsp.protocol.make_client_capabilities()
	),
	on_attach = function(client, bufnr)
		--    print('default on attach')
		vim.api.nvim_exec_autocmds('User', { pattern = 'LspAttached' })
	end
}

-- set updated default config
lspconfig.util.default_config = vim.tbl_deep_extend(
	'force',
	lspconfig.util.default_config,
	lsp_defaults
)

---
-- LSP Servers
---


local lua_config = {
	settings = {
		Lua = {
			runtime = {
				version = 'LuaJIT',
			},
			diagnostics = {
				globals = { 'vim' },
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
			telemetry = {
				enable = false,
			},
		},
	},
	on_attach = function(client, bufnr)
		lspconfig.util.default_config.on_attach(client, bufnr)
	end
}



--local rust_config = {
--	 settings = {
--      ["rust-analyzer"] = {
--        assist = {
--          importEnforceGranularity = true,
--          importPrefix = "crate"
--          },
--        cargo = {
--          allFeatures = true
--          },
--        checkOnSave = {
--          -- default: `cargo check`
--          command = "clippy"
--          },
--        },
--        inlayHints = {
--          lifetimeElisionHints = {
--            enable = true,
--            useParameterNames = true
--          },
--        },
--      }
--    }

-- NOTE RUST-ANALYZER is setup through rust-tools seperately
local servers = { emmet_ls = true, julials = true, pyright = true, sumneko_lua = lua_config, html = true, tsserver = true }
--local servers = { emmet_ls=true, eslint=true, pyright=true, sumneko_lua=lua_config, tsserver=true, julials=true, html=true }

local setup_server = function(server, config)
	if not config then
		return
	end

	if type(config) ~= "table" then
		config = {}
	end

	lspconfig[server].setup(config)
end

for server, config in pairs(servers) do
	setup_server(server, config)
end

local rt = require("rust-tools")

rt.setup({
	server = {
		on_attach = function(client, bufnr)
			lspconfig.util.default_config.on_attach(client, bufnr)
		end,
		--on_attach = function(_, bufnr)
		--  -- Hover actions
		--  vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
		--  -- Code action groups
		--  vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
		--end,
		["rust-analyzer"] = {
			checkOnSave = {
				command = "clippy"
			},
		},
	},
})
