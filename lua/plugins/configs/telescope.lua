local is_win = vim.fn.has "win32" == 1
if not is_win then
  pcall(require('telescope').load_extension, 'fzf')
end

local actions = require "telescope.actions"
local layout_actions = require "telescope.actions.layout"

require("telescope").setup {
  defaults = {
    file_sorter = require("telescope.sorters").get_fzy_sorter,
    generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
    prompt_prefix = "  ",
    selection_caret = "  ",
    selection_strategy = "reset",
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden",
      "--glob=!.git/",
    },
    sorting_strategy = "descending",
    layout_strategy = "flex",
    layout_config = {
      flex = {
        flip_columns = 161, -- half 27" monitor, scientifically calculated
      },
      horizontal = {
        preview_cutoff = 0,
        preview_width = 0.6,
      },
      vertical = {
        preview_cutoff = 0,
        preview_height = 0.65,
      },
    },
    path_display = { truncate = 3 },
    color_devicons = true,
    --winblend = 5,
    set_env = { ["COLORTERM"] = "truecolor" },
    border = {},
    borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
    file_ignore_patterns = { "node_modules" },
    --borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
    mappings = {
      i = {
            ["<C-w>"] = function()
          vim.api.nvim_input "<c-s-w>"
        end,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-p>"] = actions.cycle_history_prev,
            ["<C-n>"] = actions.cycle_history_next,
            ["<C-l>"] = layout_actions.toggle_preview,
            ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
            ["<Esc>"] = actions.close,
            ['<C-u>'] = false,
            ['<C-d>'] = false,
        --["<Tab>"] = actions.toggle_selection + actions.move_selection_next,
        --["<S-Tab>"] = actions.toggle_selection + actions.move_selection_previous,
      },
    },
  },
  extensions = {
    project = {
      hidden_files = false,
    },
    fzf = is_win and {} or {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  },
}


-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
