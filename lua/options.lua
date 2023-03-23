local options = {
	cursorline = true,
	hlsearch = false,
	incsearch = true,
	mouse = 'a',
	number = true,
	relativenumber = true,
	scrolloff = 8,
	shiftwidth = 4,
	softtabstop = 4,
	swapfile = false,
	tabstop = 4,
}


for k, v in pairs(options) do
	vim.opt[k] = v
end

-- Make line numbers default
vim.wo.number = true

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true
-- not sure what this does yet
--vim.opt.shortmess:append 'c'
