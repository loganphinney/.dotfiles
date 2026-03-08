return {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = { use_default_keymaps = false, },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    lazy = false,
    config = function()
        require('oil').setup({})
    end,
    vim.keymap.set('n', '<leader>qq', ':Oil<CR>', { desc = 'Open Oil' }),
}
