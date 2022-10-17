local null_ls = require("null-ls")

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

	on_attach = function(client)
		if client.server_capabilities.document_formatting then
			vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()")
		end
		vim.cmd [[
				    augroup document_highlight
        autocmd! * <buffer>
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]]
	end
})



--		vim.cmd [[
--				    augroup document_highlight
--        autocmd! * <buffer>
--        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
--        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
--      augroup END
--    ]]
