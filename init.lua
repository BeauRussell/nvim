vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.g.mapleader = " "
require("config.lazy")

local Beau = vim.api.nvim_create_augroup('Beau', {})

vim.api.nvim_create_autocmd('LspAttach', {
	group = Beau,
	callback = function(e)
		local opts = { buffer = e.buf }
		vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
		vim.keymap.set("n", "gt", function() vim.lsp.buf.type_definition() end, opts)
		vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
		vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
		vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
		vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
		vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
		vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
		vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
	end
})

vim.api.nvim_create_autocmd('BufWritePre', {
	group = Beau,
	callback = function(e)
		-- Map filetypes to whether they should be formatted
		local format_filetypes = {
			go = true,
			typescript = true,
			typescriptreact = true,
			javascript = true,
			javascriptreact = true,
		}
		local ft = vim.bo.filetype
		if format_filetypes[ft] then
			-- Format before saving
			vim.lsp.buf.format({ async = false })

			-- Organize imports (synchronous)
			vim.lsp.buf.code_action({
				context = { only = { 'source.organizeImports' } },
				apply = true,
			})
		end

		-- Only run EslintFixAll for JS/TS files when eslint is attached
		local eslint_filetypes = {
			typescript = true,
			typescriptreact = true,
			javascript = true,
			javascriptreact = true,
		}
		if eslint_filetypes[ft] then
			-- Check if eslint is actually attached before running
			local clients = vim.lsp.get_clients({ bufnr = e.buf, name = "eslint" })
			if #clients > 0 then
				pcall(vim.cmd, 'EslintFixAll')
			end
		end
	end
})
