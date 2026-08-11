vim.pack.add({ 'https://github.com/rose-pine/neovim' })
require('rose-pine').setup({
    palette = { main = { pine = '#3e8fb0' } },
    styles = { transparency = true, bold = false, italic = true },
    highlight_groups = {
        NoiceCmdlinePopupBorder = { fg = 'love' },
        NoiceCmdlinePopupBorderSearch = { fg = 'iris' },
        NoiceCmdlineIconSearch = { fg = 'foam' },
    }
})
vim.cmd('colorscheme rose-pine')
