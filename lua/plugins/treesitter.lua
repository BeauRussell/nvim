return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		-- Note: ensure_installed and auto_install were removed in the new API
		-- Parsers must be installed manually with :TSInstall <parser>
		require("nvim-treesitter").setup({
			highlight = { enable = true },
			indent = { enable = true },
		})

		-- List of parsers you want installed
		-- Run :TSInstallAll to install these, or :TSInstall <parser> individually
		local wanted_parsers = {
			"jsdoc", "vimdoc", "javascript", "typescript", "lua",
			"go", "java", "odin", "templ", "markdown", "markdown_inline",
			"html", "css", "json", "yaml", "bash", "c",
		}

		-- Custom command to install all wanted parsers
		vim.api.nvim_create_user_command("TSInstallAll", function()
			for _, parser in ipairs(wanted_parsers) do
				vim.cmd("TSInstall " .. parser)
			end
		end, { desc = "Install all configured treesitter parsers" })

		-- Enable treesitter-based highlighting for all buffers
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "*",
			callback = function()
				pcall(vim.treesitter.start)
			end,
		})

		-- Additional vim regex highlighting for markdown
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "markdown",
			callback = function()
				vim.opt_local.syntax = "on"
			end,
		})

		-- Register templ filetype
		vim.treesitter.language.register('templ', 'templ')
	end
}
