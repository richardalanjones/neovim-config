local ls = require("luasnip")
local s = ls.s --> snippet
local i = ls.i --> insert node
local t = ls.t --> text node

local f = ls.function_node

local fmt = require("luasnip.extras.fmt").fmt


local snippets = {
	ls.parser.parse_snippet("lm", "local M = {}\n\nfunction M.setup()\n  $1 \nend\n\nreturn M"),
	-- s("lm", { t { "local M = {}", "", "function M.setup()", "" }, i(1, ""), t { "", "end", "", "return M" } }),

	ls.parser.parse_snippet("for", "for ${1:i} = ${2:1}, ${3:n} do\n\t$0\nend"),
	ls.parser.parse_snippet("fun", "local function ${1:name}($2)\n\t$0\nend"),
	ls.parser.parse_snippet("while", "while ${1:cond} do\n\t$0\nend"),
	ls.parser.parse_snippet("mfun", "function M.${1:name}($2)\n\t$0\nend"),
	ls.parser.parse_snippet("pairs", "for ${1:key}, ${2:value} in pairs($3) do\n\t$0\nend"),
	ls.parser.parse_snippet("ipairs", "for ${1:i}, ${2:value} in ipairs($3) do\n\t$0\nend"),
	ls.parser.parse_snippet("if", "if ${1:cond} then\n\t$0\nend"),
	ls.parser.parse_snippet("ifn", "if not ${1:cond} then\n\t$0\nend"),

	s("todo", t 'print("TODO")'),

	-- s("req", fmt("local {} = require('{}')", { i(1, "default"), rep(1) })),
	s(
		"localreq",
		fmt('local {} = require("{}")', {
			l(l._1:match("[^.]*$"):gsub("[^%a]+", "_"), 1),
			i(1, "module"),
		})
	),
	s(
		"localreq2",
		fmt([[local {} = require "{}"]], {
			f(function(import_name)
				local parts = vim.split(import_name[1][1], ".", true)
				return parts[#parts] or ""
			end, {
				1,
			}),
			i(1),
		})
	),

	s(
		"preq",
		fmt('local {1}_ok, {1} = pcall(require, "{}")\nif not {1}_ok then return end', {
			l(l._1:match("[^.]*$"):gsub("[^%a]+", "_"), 1),
			i(1, "module"),
		})
	),

	-- s("doc", {
	--   t "--- ",
	--   i(1, "Function description."),
	--   d(2, function(_, snip)
	--     local parms, ret = next_fun_parms(tonumber(snip.env.TM_LINE_NUMBER))
	--     assert(parms, "Did not find a function!")
	--
	--     local parm_nodes = {}
	--     for j, parm in ipairs(parms) do
	--       table.insert(parm_nodes, t { "", "-- @param " .. parm .. " " })
	--       table.insert(parm_nodes, i(j, "Parameter description."))
	--     end
	--
	--     if ret then
	--       table.insert(parm_nodes, t { "", "-- @return " })
	--       table.insert(parm_nodes, i(#parms + 1, "Return description."))
	--     end
	--
	--     return s(1, parm_nodes)
	--   end),
	-- }),


	s("myFirstSnip", {
		t("My First Snip!!!"),
		i(1, " placeholder_text "),
		t({ "", "some more text" })
	}),
}

return snippets

--local snippets, autosnippets = {}, {} --}}}
--
--local group = vim.api.nvim_create_augroup("Lua Snippets", { clear = true })
--return snippets, autosnippets
