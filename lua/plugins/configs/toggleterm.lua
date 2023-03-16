local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
	print('status not ok')
	return
end

toggleterm.setup {
	size = 20,
	--size = 80,
	open_mapping = [[<c-\>]],
	hide_numbers = true,
	shade_filetypes = {},
	shade_terminals = true,
	shading_factor = 2,
	start_in_insert = true,
	--insert_mappings = true,
	persist_size = true,
	--direction = "vertical",
	direction = "horizontal",
	close_on_exit = true,
	shell = vim.o.shell,
	float_opts = {
		border = "curved",
		winblend = 0,
		highlights = {
			border = "Normal",
			background = "Normal",
		},
	},
}

--function _G.set_terminal_keymaps()
--	local opts = { buffer = 0 }
--	vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
--	vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
--	vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
--	vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
--	vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
--	vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
--	vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
--end
--
---- if you only want these mappings for toggle term use term://*toggleterm#* instead
--vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

-- General Mappings
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
map('n', '<leader>zz', ':ToggleTermSendCurrentLine <cr>', opts)
map('n', '<leader>vv', ':ToggleTermSendVisualSelection <cr>', opts)

local Terminal = require('toggleterm.terminal').Terminal

--Julia REPL
local julia = Terminal:new({ cmd = "julia", hidden = false })

function _julia_repl()
	julia:toggle()
end

map("n", "<leader>jr", [[<cmd>lua _julia_repl()<CR> using Pkg<CR> Pkg.activate(".")<CR>]], opts)

--Python REPL
local python_env = Terminal:new({ cmd = "pipenv shell", hidden = false })

function Wait(seconds)
	local start = os.time()
	repeat
	until os.time() > start + seconds
end

function _python_repl()
	python_env:toggle()
	Wait(0.5)
	vim.cmd("TermExec cmd=python")
end

map("n", "<leader>pr", [[<cmd>lua _python_repl()<CR>]], opts)

local lazygit = Terminal:new({
	cmd = "lazygit",
	hidden = true,
	direction = "float",
	float_opts = {
		border = "double",
	},
	-- -- function to run on opening the terminal
	-- on_open = function(term)
	--   vim.cmd("startinsert!")
	--   vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
	-- end,
	-- -- function to run on closing the terminal
	-- on_close = function(term)
	--   vim.cmd("startinsert!")
	-- end,
})

function _lazygit_toggle()
	lazygit:toggle()
end

map("n", "<leader>g", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })
