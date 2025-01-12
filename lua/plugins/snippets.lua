return {
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		build = "make install_jsregexp",
		dependencies = { "rafamadriz/friendly-snippets" },

		config = function()
			local ls = require("luasnip")
			local s = ls.snippet
			local t = ls.text_node

			ls.filetype_extend("javascript", { "jsdoc" })
			ls.filetype_extend("typescript", { "tsdoc" })

			ls.add_snippets("go", {
				s("errno", {
					t({
						"if err != nil {",
						"	log.Printf(\"Failed to do something: %v\", err)",
						"	return err",
						"}",
					}),
				}),
			}, {
				key = "go",
			})

			vim.keymap.set({"i"}, "<C-K>", function() ls.expand() end, {silent = true})
			vim.keymap.set({"i", "s"}, "<leader>;", function() ls.jump(1) end, {silent = true})
			vim.keymap.set({"i", "s"}, "<leader>,", function() ls.jump(-1) end, {silent = true})

			vim.keymap.set({"i", "s"}, "<C-E>", function()
				if ls.choice_active() then
					ls.change_choice(1)
				end
			end, {silent = true})
		end
	}
}
