
vim.lsp.config('goplos', {
	cmd = {'gopls'},
	-- for postfix snippets and analyzers
	capabilities = capabilities,
	settings = {
		gopls = {
			experimentalPostfixCompletions = true,
			analyses = {
				unusedparams = true,
				shadow = true,
			},
			staticcheck = true,
		},
	},
})
vim.lsp.enable('gopls')

