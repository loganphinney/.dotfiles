vim.pack.add({
    'https://github.com/nvimdev/lspsaga.nvim',
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/nvim-tree/nvim-web-devicons'
})
require('lspsaga').setup({
    symbol_in_winbar = { enable = false },
    lightbulb = { enable = false }
})
