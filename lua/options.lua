local options = {
	-- global options
	mouse = 'a',
	-- window-local options
	cursorline = true,
	number = true,
	relativenumber = true,
	-- buffer-local options
	shiftwidth = 4,
	softtabstop = 4,
	swapfile = false,
	tabstop = 4,
	hlsearch = false,
}

-- not sure what this does yet
vim.opt.shortmess:append 'c'

for k, v in pairs(options) do
	vim.opt[k] = v
end
