local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
	print('status not ok')
	return
end

toggleterm.setup {
	size = 20,
	open_mapping = [[<c-\>]],
	hide_numbers = true,
	shade_filetypes = {},
	shade_terminals = true,
	shading_factor = 2,
	start_in_insert = true,
	insert_mappings = true,
	persist_size = true,
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
function _G.set_terminal_keymaps()
  local buf_opts = {noremap = true}
  vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], buf_opts)
  vim.api.nvim_buf_set_keymap(0, 't', 'jk', [[<C-\><C-n>]], buf_opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<C-\><C-n><C-W>h]], buf_opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-W>j]], buf_opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-W>k]], buf_opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<C-\><C-n><C-W>l]], buf_opts)
end

vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
-- General Mappings
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
map('n', '<leader>zz', ':ToggleTermSendCurrentLine <cr>', opts)
map('n', '<leader>vv', ':ToggleTermSendVisualSelection <cr>', opts)

local Terminal  = require('toggleterm.terminal').Terminal

--Julia REPL
local julia = Terminal:new({ cmd = "julia", hidden = false})

function julia_repl()
  julia:toggle()
end

map("n", "<leader>jr", [[<cmd>lua julia_repl()<CR> using Pkg<CR> Pkg.activate(".")<CR>]], opts)

--Python REPL
local python_env = Terminal:new({cmd= "pipenv shell", hidden = false})

function python_repl()
	function wait(seconds)
		local start = os.time()
		repeat until os.time() > start + seconds
	end
	python_env:toggle()
	wait(0.5)
	vim.cmd("TermExec cmd=python")
end
map("n", "<leader>pr", [[<cmd>lua python_repl()<CR>]], opts)

