vim.pack.add({ 'https://github.com/shellRaining/hlchunk.nvim' })
local indent = require('hlchunk.mods.indent')
indent({
    enable = true,
    style = '#524f67',
    chars = { ' ', '․', '⁚', '⁖', '⁘', '⁙' }
}):enable() -- don't forget call enable method
