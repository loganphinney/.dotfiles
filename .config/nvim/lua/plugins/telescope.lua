vim.pack.add({
    'https://github.com/nvim-telescope/telescope.nvim',
    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/nvim-telescope/telescope-fzf-native.nvim',
})
vim.system({ 'make' }, { cwd = vim.fn.stdpath('data') .. '/site/pack/core/opt/telescope-fzf-native.nvim' })
local telescope = require('telescope')
telescope.setup({
    defaults = {
        mappings = {
            i = { ['<C-h>'] = 'which_key' }
        }
    }
})
pcall(function() telescope.load_extension('fzf') end)
