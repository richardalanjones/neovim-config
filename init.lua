local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('lazy').setup('plugins')
require('options')
require('mappings')


-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

--[[Diagnostics]]
-- this was from older config -- not sure if i need it???
--local sign = function(opts)
--	vim.fn.sign_define(opts.name, {
--		texthl = opts.name,
--		text = opts.text,
--		numhl = ''
--	})
--end
--
--sign({ name = 'DiagnosticSignError', text = '✘' })
--sign({ name = 'DiagnosticSignWarn', text = '▲' })
--sign({ name = 'DiagnosticSignHint', text = '⚑' })
--sign({ name = 'DiagnosticSignInfo', text = '' })
--
--
--vim.diagnostic.config({
--	virtual_text = false,
--	signs = true,
--	update_in_insert = true,
--	severity_sort = false,
--	underline = true,
--	float = {
--		border = 'rounded',
--		source = 'always',
--		header = '',
--		prefix = '',
--	},
--})
-------------------------------------------------------

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
