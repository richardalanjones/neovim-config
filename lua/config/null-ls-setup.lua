local null_ls = require("null-ls")
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local formatting = null_ls.builtins.formatting

local sources = {
	--diagnostics.eslint,
	--code_actions.eslint,
	--formatting.autopep8,
	formatting.rustfmt.with({ extra_args = { "--edition=2021" } }),
	formatting.prettier,
	formatting.lua_format.with({
		extra_args = {
			'--no-keep-simple-function-one-line', '--no-break-after-operator', '--column-limit=100',
			'--break-after-table-lb', '--indent-width=2'
		}
	}), formatting.isort, }

null_ls.setup({
	sources = sources,
 on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format({ bufnr = bufnr })
                end,
            })
        end
    end,
})

