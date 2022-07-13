local ls = require("luasnip") --{{{
local s = ls.s --> snippet
local i = ls.i --> insert node
local t = ls.t --> text node

local d = ls.dynamic_node
local c = ls.choice_node
local f = ls.function_node
local sn = ls.snippet_node

local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

local snippets, autosnippets = {}, {} --}}}

local group = vim.api.nvim_create_augroup("Lua Snippets", { clear = true })
local file_pattern = "*.lua"

local myFirstSnip = s("myFirstSnip",{
	t("My First Snip!!!"),
	i(1, " placeholder_text "),
	t({"", "some more text"})
})

table.insert(snippets, myFirstSnip)

local function Blah()
	print('Blah')
end

return snippets, autosnippets




