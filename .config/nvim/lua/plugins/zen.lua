return {
    'folke/zen-mode.nvim',
    vim.keymap.set('n', '<leader>zz', ':ZenMode<CR>', { desc = 'Zen Mode' }),
    opts = {
        window = {
            backdrop = 1.0,
            width = 120,
            height = 0.95,
        }
    }
}
