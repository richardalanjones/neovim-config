-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

local execute = vim.api.nvim_command
local fn      = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"

-- returns the require for use in `config` parameter of packer's use
-- expects the name of the config file
-- function get_config(name)
--	return string.format("require(\"config/%s\")", name)
-- end

if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system {
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	}
	print "Installing packer close and reopen Neovim..."
	execute "packeradd packer.nvim"
end

-- initialize and configure packer
local packer = require("packer")

packer.init {
	enable = true, -- enable profiling via :PackerCompile profile=true
	threshold = 0, -- the amount in ms that a plugins load time must be over for it to be included in the profil
	display = {
		open_fn = function()
			return require("packer.util").float { border = "rounded" }
		end,
	},
}

local use = packer.use
packer.reset()

-- actual plugins list
use "wbthomason/packer.nvim"

-- color themes
use { "dracula/vim", config = [[require('config.colorschemes.dracula')]] }

--LSP
use { "williamboman/nvim-lsp-installer",
	config = function() require('nvim-lsp-installer').setup {
    ui = {
        check_outdated_servers_on_open = false,
        icons = {
            server_installed = "",
            server_pending = "",
            server_uninstalled = "",
        },
		},
	}
	end }

use { "neovim/nvim-lspconfig",  config = [[require('config.lsp-setup')]]}

use {"ray-x/lsp_signature.nvim", requires = "neovim/nvim-lspconfig"}

use "tami5/lspsaga.nvim" -- lsp icons

-- CMP
use { 'hrsh7th/nvim-cmp',
	requires = {
		'L3MON4D3/LuaSnip',
		{ 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
		'hrsh7th/cmp-nvim-lsp',
		'hrsh7th/cmp-nvim-lsp-signature-help',
		{ 'hrsh7th/cmp-path', after = 'nvim-cmp' },
		{ 'hrsh7th/cmp-nvim-lua', after = 'nvim-cmp' },
		{ 'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp' },
		'lukas-reineke/cmp-under-comparator',
		{ 'hrsh7th/cmp-nvim-lsp-document-symbol', after = 'nvim-cmp' },
	},
	config = [[require('config.cmp-setup')]],
}

-- snippets
use "onsails/lspkind-nvim"

-- icons
use "kyazdani42/nvim-web-devicons" --> enable icons

-- Telescope
    use {
        "nvim-telescope/telescope.nvim",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-project.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
        },
        config = function()
            require("config.telescope").setup()
        end,
    }
--use { 'nvim-telescope/telescope.nvim', requires = "nvim-lua/plenary.nvim" }

use { 'nvim-lualine/lualine.nvim', config = [[require('config.lualine-setup')]] }

use { "jose-elias-alvarez/null-ls.nvim", requires = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' } }
--use { "jose-elias-alvarez/null-ls.nvim", requires = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' }, config = [[require('config.null-ls-setup')]] }

--> treesitter & treesitter modules/plugins
use { "nvim-treesitter/nvim-treesitter", config = [[require('config.treesitter-setup')]], run = ":TSUpdate" } --> treesitter
use 'romgrk/barbar.nvim'

use { 'akinsho/toggleterm.nvim', config = [[require('config.toggleterm-setup')]] }

