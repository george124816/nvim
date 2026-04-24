vim.api.nvim_create_user_command('Fj', function()
	vim.cmd('%!jq .')
	vim.cmd('setfiletype json')
end, {})
