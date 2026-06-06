vim.pack.add({ 'https://github.com/folke/trouble.nvim' })
vim.schedule(function() require('trouble').setup({}) end)
