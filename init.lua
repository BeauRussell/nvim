vim.cmd("set relativenumber")
vim.cmd("set number")
vim.cmd("set shiftwidth=4")
vim.cmd("set tabstop=4")
vim.g.mapleader = " "
require("config.lazy")

vim.api.nvim_create_augroup('Beau', {})

vim.api.nvim_create_autocmd('LspAttach', {
	group = Beau,
	callback = function(e)
		local opts = { buffer = e.buf }
		vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
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
		local extensions = { go=true, ts=true, tsx=true, js=true, jsx=true, }
		if extensions[vim.bo.filetype] then
			-- Format/organize imports before saving
			vim.lsp.buf.format()
			vim.lsp.buf.code_action { context = { only = { 'source.organizeImports' } }, apply = true }
			vim.lsp.buf.code_action { context = { only = { 'source.fixAll' } }, apply = true }
		end
	end
})
