vim.pack.add({ 'https://github.com/shellRaining/hlchunk.nvim' })
local indent = require('hlchunk.mods.indent')
indent({
    enable = true,
    style = '#524f67',
    chars = { ' ', '․', '⁚', '⁖', '⁘', '⁙' },
    exclude_filetypes = { markdown = true }
}):enable()
