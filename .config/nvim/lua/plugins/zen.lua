vim.pack.add({ 'https://github.com/folke/zen-mode.nvim' })
require('zen-mode').setup({
    window = {
        backdrop = 1.0,
        width = 120,
        height = 0.90
    },
    plugins = {
        tmux = { enabled = true },
        gitsigns = { enabled = true }
    }
})
