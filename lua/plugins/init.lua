return {
  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  'tami5/lspsaga.nvim', -- lsp icons
  --  { -- Theme inspired by Atom
  --    'navarasu/onedark.nvim',
  --    priority = 1000,
  --    config = function()
  --      vim.cmd.colorscheme 'onedark'
  --      vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  --      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
  --    end,
  --  },
  {
    'dracula/vim',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'dracula'
      vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    end,
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = false,
        theme = 'dracula',
        component_separators = '|',
        section_separators = '',
      },
    },
  },

  -- Additional lua configuration, makes nvim stuff amazing!
  { 'folke/neodev.nvim',        opts = {} }, -- black ops table is the same as ---> require('neodev').setup()

  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },
    },
    config = function()
      require 'plugins.configs.lsp'
    end,
  },

  { "ray-x/lsp_signature.nvim", dependencies = { "neovim/nvim-lspconfig" } },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = { 'hrsh7th/cmp-nvim-lsp', 'saadparwaiz1/cmp_luasnip', 'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lua',
      'lukas-reineke/cmp-under-comparator',
      'hrsh7th/cmp-nvim-lsp-document-symbol',
    },
  },

  ---- snippets
  {
    'L3MON4D3/LuaSnip',
    config = function()
      require('plugins.configs.snip').setup()
    end,
  },

  {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup({ check_ts = true })
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({ map_char = { tex = '' } }))
    end,
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim',  opts = {} },
  {
    -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    opts = {
      char = '┊',
      show_trailing_blankline_indent = false,
    },
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    version = '*',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require 'plugins.configs.telescope'
    end,
  },

  {
    'nvim-telescope/telescope-fzf-native.nvim',
    -- NOTE: If you are having trouble with this installation,
    --       refer to the README for telescope-fzf-native for more instructions.
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
      require('plugins.configs.treesitter')
    end,
  },

  {
    "theprimeagen/harpoon",
    config = function()
      local mark = require("harpoon.mark")
      local ui = require("harpoon.ui")

      vim.keymap.set("n", "<leader>a", mark.add_file)
      vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)

      vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end)
      vim.keymap.set("n", "<C-t>", function() ui.nav_file(2) end)
      vim.keymap.set("n", "<C-n>", function() ui.nav_file(3) end)
      vim.keymap.set("n", "<C-s>", function() ui.nav_file(4) end)
    end,
  },



  {
    'akinsho/toggleterm.nvim',
    config = function()
      require 'plugins.configs.toggleterm'
    end,
  },

  -- other plugins
  "onsails/lspkind-nvim",
  "romgrk/barbar.nvim",

  --rust tools
  'simrat39/rust-tools.nvim',
  -- Debugging
  'mfussenegger/nvim-dap',
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    config = function()
      require 'plugins.configs.null-ls'
    end,
  },
}
