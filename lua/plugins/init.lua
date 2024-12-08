return {
	"eandrju/cellular-automaton.nvim",
	"folke/neodev.nvim",
	"folke/tokyonight.nvim",
	"folke/which-key.nvim",
	"folke/zen-mode.nvim",
	{ "folke/neoconf.nvim", cmd="Neoconf" },

	{ "folke/trouble.nvim", config = function() 
			require("trouble").setup { icons = false, } 
		end 
	},

	"github/copilot.vim",
	"laytan/cloak.nvim",
	"mbbill/undotree",
	"nvim-lua/plenary.nvim",
	{ "nvim-telescope/telescope.nvim", tag = '0.1.8', dependencies = { "nvim-lua/plenary.nvim" } },
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
	"tpope/vim-fugitive",
}
