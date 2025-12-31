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
		local ft = vim.bo.filetype

		-- Go: use gopls for formatting (respects project settings)
		if ft == "go" then
			vim.lsp.buf.format({ async = false })
			vim.lsp.buf.code_action({
				context = { only = { 'source.organizeImports' } },
				apply = true,
			})
			return
		end

		-- JS/TS: only use ESLint for formatting/fixing (not ts_ls which ignores project style)
		local eslint_filetypes = {
			typescript = true,
			typescriptreact = true,
			javascript = true,
			javascriptreact = true,
		}
		if eslint_filetypes[ft] then
			local clients = vim.lsp.get_clients({ bufnr = e.buf, name = "eslint" })
			if #clients > 0 then
				-- Use synchronous request to apply ESLint fixes before save completes
				local client = clients[1]
				client.request_sync('workspace/executeCommand', {
					command = 'eslint.applyAllFixes',
					arguments = {
						{
							uri = vim.uri_from_bufnr(e.buf),
							version = vim.lsp.util.buf_versions[e.buf],
						},
					},
				}, 3000, e.buf)
			end
		end
	end
})
