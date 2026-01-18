return {
    'shellRaining/hlchunk.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
        require('hlchunk').setup({
            blank = {
                enable = true,
                style = '#524f67',
                chars = { ' ', '․', '⁚', '⁖', '⁘', '⁙' },
            },
        })
    end
}
