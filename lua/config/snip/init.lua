local M = {}
local snippets_folder = vim.fn.stdpath "config" .. "/lua/config/snip/snippets/"
local ls = require "luasnip"
local types = require "luasnip.util.types"

local f = ls.function_node

function _G.edit_ft()
	-- returns table like {"lua", "all"}
	local fts = require("luasnip.util.util").get_snippet_filetypes()
	vim.ui.select(fts, {
		prompt = "Select which filetype to edit:",
	}, function(item, idx)
		-- selection aborted -> idx == nil
		if idx then
			vim.cmd("edit " .. snippets_folder .. item .. ".lua")
		end
	end)
end

function _G.snippets_clear()
	if ls.snippets == nil then
		return
	end
	for m, _ in pairs(ls.snippets) do
		package.loaded["config.snip.snippets." .. m] = nil
	end
	ls.snippets = setmetatable({}, {
		__index = function(t, k)
			local ok, m = pcall(require, "config.snip.snippets." .. k)
			if not ok and not string.match(m, "^module.*not found:") then
				error(m)
			end
			t[k] = ok and m or {}

			-- optionally load snippets from vscode- or snipmate-library:
			--
			-- require("luasnip.loaders.from_vscode").load({include={k}})
			-- require("luasnip.loaders.from_snipmate").load({include={k}})
			return t[k]
		end,
	})
end

function M.setup()
	ls.config.set_config {
		history = true,
		updateevents = "TextChanged,TextChangedI",
		enable_autosnippets = false,

		delete_check_events = "TextChanged",
		-- ext_opts = {
		--   [types.choiceNode] = {
		--     active = {
		--       virt_text = { { "<-", "Error" } },
		--     },
		--   },
		-- },
		store_selection_keys = "<C-q>",
		ext_opts = {
			[types.choiceNode] = {
				active = {
					virt_text = { { "●", "GruvboxOrange" } },
				},
			},
			[types.insertNode] = {
				active = {
					virt_text = { { "●", "GruvboxBlue" } },
				},
			},
		},
	}

	--	ext_opts = {
	--		[types.choiceNode] = {
	--			active = {
	--				virt_text = { { " <- Current Choice", "NonTest" } },
	--			},
	--		},
	--	},

	_G.snippets_clear()

	local snip_cmd = string.format(
		[[
	   augroup snippets_clear
	   au!
	   au BufWritePost %s lua _G.snippets_clear()
	   augroup END
	 ]],
		snippets_folder .. "*.lua"
	)

	vim.cmd(snip_cmd)
	vim.cmd [[command! LuaSnipEdit :lua _G.edit_ft()]]

	-- Lazy load snippets
	require("luasnip.loaders.from_vscode").lazy_load()
	require("luasnip.loaders.from_snipmate").lazy_load()
	require("luasnip.loaders.from_lua").lazy_load { paths = snippets_folder }
	vim.cmd [[command! LuaSnipEdit :lua require("luasnip.loaders.from_lua").edit_snippet_files()]]

	-- Load custom typescript snippets
	require("luasnip.loaders.from_vscode").lazy_load { paths = { "./snippets/typescript" } }
	-- require("luasnip.loaders.from_vscode").lazy_load { paths = { "./snippets/python" } }
	-- require("luasnip.loaders.from_vscode").lazy_load { paths = { "./snippets/rust" } }

	ls.filetype_extend("all", { "_" })
end

-- function M.same(index)
--   return f(function(args)
--     return args[1]
--   end, { index })
-- end
--
-- local function create_snippets()
--   ls.snippets = {
--     all = {
--       s("ttt", t "Testing Luasnip"),
--     },
--     lua = require("config.snip.snippets.lua").setup(),
--     python = require("config.snip.snippets.python").setup(),
--   }
-- end







-- <c-k> is my expansion key
-- this will expand the current item or jump to the next item within the snippet.
vim.keymap.set({ "i", "s" }, "<c-k>", function()
	if ls.expand_or_jumpable() then
		ls.expand_or_jump()
	end
end)

-- <c-j> is my jump backwards key.
-- this always moves to the previous item within the snippet
vim.keymap.set({ "i", "s" }, "<c-j>", function()
	if ls.jumpable(-1) then
		ls.jump(-1)
	end
end)

-- <c-l> is selecting within a list of options.
-- This is useful for choice nodes (introduced in the forthcoming episode 2)
vim.keymap.set("i", "<c-l>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end)

vim.keymap.set("i", "<c-u>", require "luasnip.extras.select_choice")



return M
