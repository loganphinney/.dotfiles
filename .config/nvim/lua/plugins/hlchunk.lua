vim.pack.add({ 'https://github.com/shellRaining/hlchunk.nvim' })
require('hlchunk').setup({
    blank = {
        enable = true,
        style = '#524f67',
        chars = { ' ', '․', '⁚', '⁖', '⁘', '⁙' }
    }
})
