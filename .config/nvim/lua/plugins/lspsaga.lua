return {
    'nvimdev/lspsaga.nvim',
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
        'nvim-tree/nvim-web-devicons'
    },
    config = function()
        require('lspsaga').setup({
            symbol_in_winbar = { enable = false },
            lightbulb = { enable = false },
            vim.keymap.set('n', 'K', '<cmd>Lspsaga hover_doc<Cr>')
        })
    end
}
