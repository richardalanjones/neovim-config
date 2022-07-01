vim.api.nvim_create_autocmd('User', {
  pattern = 'LspAttached',
  desc = 'LSP actions',
  callback = function()
      local bufmap = function(mode, lhs, rhs)
      local opts = {buffer = true}
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
  capabilities = require('cmp_nvim_lsp').update_capabilities(
    vim.lsp.protocol.make_client_capabilities()
  ),
  on_attach = function(client, bufnr)
--    print('default on attach')
	vim.api.nvim_exec_autocmds('User', {pattern = 'LspAttached'})
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
        globals = {'vim'},
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


local servers = { emmet_ls=true, eslint=true, julials=true, pyright=true, tsserver=true, sumneko_lua=lua_config, html=true }
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



--null_ls.setup {
--    sources = {
--        null_ls.builtins.formatting.prettierd,
--        null_ls.builtins.formatting.stylua,
--        null_ls.builtins.diagnostics.shellcheck,
--    },
--    on_attach = common_on_attach,
--}









--local ok, util = pcall(require, "lspconfig.util")
--if not ok then
--    return
--end
--
----local ts_utils = require "nvim-treesitter.ts_utils"
--local lsp_signature = require "lsp_signature"
--local null_ls = require "null-ls"
--
--local telescope_lsp = require "config.telescope.lsp"
--
----vim.api.nvim_create_user_command("LspLog", [[exe 'tabnew ' .. luaeval("vim.lsp.get_log_path()")]], {})
--
----require("nvim-lsp-installer").setup {
----    automatic_installation = vim.fn.hostname() == "Williams-MacBook-Air.local",
-- --   log_level = vim.log.levels.DEBUG,
----    ui = {
----        check_outdated_servers_on_open = false,
----        icons = {
----            server_installed = "",
----            server_pending = "",
----            server_uninstalled = "",
----        },
----    },
----}
--
--local cmp_lsp = require "cmp_nvim_lsp"
--
-----@param opts table|nil
--local function create_capabilities(opts)
--    local default_opts = {
--        with_snippet_support = true,
--    }
--    opts = opts or default_opts
--    local capabilities = vim.lsp.protocol.make_client_capabilities()
--    capabilities.textDocument.completion.completionItem.snippetSupport = opts.with_snippet_support
--    if opts.with_snippet_support then
--        capabilities.textDocument.completion.completionItem.resolveSupport = {
--            properties = {
--                "documentation",
--                "detail",
--                "additionalTextEdits",
--            },
--        }
--    end
--    return cmp_lsp.update_capabilities(capabilities)
--end
--
----local function highlight_references()
----    local node = ts_utils.get_node_at_cursor()
----    while node ~= nil do
----        local node_type = node:type()
----        if
----            node_type == "string"
----            or node_type == "string_fragment"
----            or node_type == "template_string"
----            or node_type == "document" -- for inline gql`` strings
----        then
----            -- who wants to highlight a string? i don't. yuck
----            return
----        end
----        node = node:parent()
----    end
----    vim.lsp.buf.document_highlight()
----end
--
----- @return fun() @function that calls the provided fn, but with no args
--local function w(fn)
--    return function()
--        return fn()
--    end
--end
--
-----@param bufnr number
--local function buf_autocmd_document_highlight(bufnr)
--    local group = vim.api.nvim_create_augroup("lsp_document_highlight", {})
--    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
--        buffer = bufnr,
--        group = group,
--        callback = highlight_references,
--    })
--    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
--        buffer = bufnr,
--        group = group,
--        callback = w(vim.lsp.buf.clear_references),
--    })
--end
--
-----@param bufnr number
--local function buf_autocmd_codelens(bufnr)
--    local group = vim.api.nvim_create_augroup("lsp_document_codelens", {})
--    vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "BufWritePost", "CursorHold" }, {
--        buffer = bufnr,
--        group = group,
--        callback = w(vim.lsp.codelens.refresh),
--    })
--end
--
---- Finds and runs the closest codelens (searches upwards only)
--local function find_and_run_codelens()
--    local bufnr = vim.api.nvim_get_current_buf()
--    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
--    local lenses = vim.lsp.codelens.get(bufnr)
--
--    lenses = vim.tbl_filter(function(lense)
--        return lense.range.start.line < row
--    end, lenses)
--
--    if #lenses == 0 then
--        return vim.notify "Could not find codelens to run."
--    end
--
--    table.sort(lenses, function(a, b)
--        return a.range.start.line > b.range.start.line
--    end)
--
--    vim.api.nvim_win_set_cursor(0, { lenses[1].range.start.line + 1, lenses[1].range.start.character })
--    vim.lsp.codelens.run()
--    vim.api.nvim_win_set_cursor(0, { row, col }) -- restore cursor, TODO: also restore position
--end
--
--local function get_preview_window()
--    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(vim.api.nvim_get_current_tabpage())) do
--        if vim.api.nvim_win_get_option(win, "previewwindow") then
--            return win
--        end
--    end
--    vim.cmd [[new]]
--    local pwin = vim.api.nvim_get_current_win()
--    vim.api.nvim_win_set_option(pwin, "previewwindow", true)
--    vim.api.nvim_win_set_height(pwin, vim.api.nvim_get_option "previewheight")
--    return pwin
--end
--
--local function hover()
--    local existing_float_win = vim.b.lsp_floating_preview
--    if existing_float_win and vim.api.nvim_win_is_valid(existing_float_win) then
--        vim.b.lsp_floating_preview = nil
--        local preview_buffer = vim.api.nvim_win_get_buf(existing_float_win)
--        local pwin = get_preview_window()
--        vim.api.nvim_win_set_buf(pwin, preview_buffer)
--        vim.api.nvim_win_close(existing_float_win, true)
--    else
--        vim.lsp.buf.hover()
--    end
--end
--
-----@param bufnr number
--local function buf_set_keymaps(bufnr)
--    local function buf_set_keymap(mode, lhs, rhs)
--        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true })
--    end
--
--    buf_set_keymap("n", "<leader>p", vim.lsp.buf.formatting)
--
--    -- Code actions
--    buf_set_keymap("n", "<leader>r", vim.lsp.buf.rename)
--    buf_set_keymap("n", "<space>f", vim.lsp.buf.code_action)
--    buf_set_keymap("v", "<space>f", vim.lsp.buf.range_code_action)
--    buf_set_keymap("n", "<leader>l", find_and_run_codelens)
--
--    -- Movement
--    buf_set_keymap("n", "gD", vim.lsp.buf.declaration)
--    buf_set_keymap("n", "gd", telescope_lsp.definitions)
--    buf_set_keymap("n", "gr", telescope_lsp.references)
--    buf_set_keymap("n", "gbr", telescope_lsp.buffer_references)
--    buf_set_keymap("n", "gI", telescope_lsp.implementations)
--    buf_set_keymap("n", "<space>s", telescope_lsp.document_symbols)
--
--    -- Docs
--    buf_set_keymap("n", "K", hover)
--    buf_set_keymap("n", "<M-p>", vim.lsp.buf.signature_help)
--    buf_set_keymap("i", "<M-p>", vim.lsp.buf.signature_help)
--
--
--    buf_set_keymap("n", "<C-p>ws", telescope_lsp.workspace_symbols)
--    buf_set_keymap("n", "<C-p>wd", telescope_lsp.workspace_diagnostics)
--end
--
--local function common_on_attach(client, bufnr)
--    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
--
--    buf_set_keymaps(bufnr)
--
--    if client.config.flags then
--        client.config.flags.allow_incremental_sync = true
--    end
--
--    if client.supports_method "textDocument/documentHighlight" then
--        buf_autocmd_document_highlight(bufnr)
--    end
--
--    if client.supports_method "textDocument/codeLens" then
--        buf_autocmd_codelens(bufnr)
--        vim.schedule(vim.lsp.codelens.refresh)
--    end
--
--    lsp_signature.on_attach({
--        bind = true,
--        floating_window = false,
--        hint_prefix = "",
--        hint_scheme = "Comment",
--    }, bufnr)
--end
--
--util.on_setup = util.add_hook_after(util.on_setup, function(config)
--    if config.on_attach then
--        config.on_attach = util.add_hook_after(config.on_attach, common_on_attach)
--    else
--        config.on_attach = common_on_attach
--    end
--    config.capabilities = create_capabilities()
--end)






































--local lsp_installer = require("nvim-lsp-installer")
 ---- Mappings.
 ---- See `:help vim.diagnostic.*` for documentation on any of the below functions
 --local opts = { noremap=true, silent=true }
 --vim.api.nvim_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
 --vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
 --vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
 --vim.api.nvim_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
 --
 ---- Use an on_attach function to only map the following keys
 ---- after the language server attaches to the current buffer
 --local on_attach = function(client, bufnr)
 --  -- Enable completion triggered by <c-x><c-o>
 --  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
 --
 --  -- Mappings.
 --  -- See `:help vim.lsp.*` for documentation on any of the below functions
 --  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
 --  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
 --  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
 --  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
 --  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
 --  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
 --  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
 --  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
 --  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
 --  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
 --  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
 --  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
 --  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
 --
 --end
 --
 ---- Use a loop to conveniently call 'setup' on multiple servers and
 ---- map buffer local keybindings when the language server attaches
 --
 --local capabilities = vim.lsp.protocol.make_client_capabilities()
 --	  capabilities.textDocument.completion.completionItem.snippetSupport = true
 --      capabilities.textDocument.completion.completionItem.preselectSupport = true
 --      capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
 --      capabilities.textDocument.completion.completionItem.deprecatedSupport = true
 --      capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
 --      capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
 --      capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
 --      capabilities.textDocument.completion.completionItem.resolveSupport = {
 --        properties = { "documentation", "detail", "additionalTextEdits" },
 --      }
 --      capabilities.textDocument.completion.completionItem.documentationFormat = { "markdown" }
 --      capabilities.textDocument.codeAction = {
 --        dynamicRegistration = true,
 --        codeActionLiteralSupport = {
 --          codeActionKind = {
 --            valueSet = (function()
 --              local res = vim.tbl_values(vim.lsp.protocol.CodeActionKind)
 --              table.sort(res)
 --              return res
 --            end)(),
 --          },
 --        },
 --      }
 --
 --
 --capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
 --
 --local servers = { 'emmet_ls', 'eslint', 'pyright', 'sumneko_lua', 'tsserver', 'julials' }
 --
 --for _, name in pairs(servers) do
 --	local server_is_found, server = lsp_installer.get_server(name)
 --	if server_is_found then
 --		if not server:is_installed() then
 --			print("Installing " .. name)
 --			server:install()
 --		end
 --	end
 --end
 --
 --lsp_installer.on_server_ready(function(server)
 --	-- Specify the default options which we'll use to setup all servers
 --	local default_opts = {
 --		on_attach = on_attach,
 --		capabilities = capabilities,
 --	}
 --
 --	server:setup(default_opts)
 --end)

--for _, lsp in pairs(servers) do
--  require('lspconfig')[lsp].setup {
--    on_attach = on_attach,
--	capabilities = capabilities,
--    flags = {
--      -- This will be the default in neovim 0.7+
--      debounce_text_changes = 150,
--    }
--}
--end

--require"lsp_signature".setup({
--        bind = true, -- This is mandatory, otherwise border config won't get registered.
--        floating_window = true, -- show hint in a floating window, set to false for virtual text only mode
--        doc_lines = 2, -- Set to 0 for not showing doc
--        hint_prefix = "🐼 ",
--        -- use_lspsaga = false,  -- set to true if you want to use lspsaga popup
--        handler_opts = {
--            border = "shadow" -- double, single, shadow, none
--        }
--    })
