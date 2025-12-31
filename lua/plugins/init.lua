return {
	"eandrju/cellular-automaton.nvim",
	"nvim-lua/plenary.nvim",
	"ThePrimeagen/vim-be-good",

	-- Lua development support for Neovim config (replaces deprecated neodev.nvim)
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},

	-- Which-key for keybinding hints
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},

	-- Neoconf for project-local LSP settings
	{ "folke/neoconf.nvim", cmd = "Neoconf" },

	-- Cloak for hiding secrets in .env files
	{
		"laytan/cloak.nvim",
		config = function()
			require("cloak").setup({
				enabled = true,
				cloak_character = "*",
				highlight_group = "Comment",
				patterns = {
					{
						file_pattern = { ".env*", "wrangler.toml", "*.secret*" },
						cloak_pattern = "=.+",
						replace = nil,
					},
				},
			})
			vim.keymap.set("n", "<leader>ct", ":CloakToggle<CR>", { desc = "Toggle Cloak" })
		end,
	},

--	"github/copilot.vim",
}
