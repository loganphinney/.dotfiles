vim.pack.add({ 'https://github.com/rose-pine/neovim' })
require('rose-pine').setup({
    palette = { main = { pine = '#3e8fb0' } },
    styles = { transparency = true },
    highlight_groups = {
        Cursor = { fg = 'base', bg = 'text' },
        CursorIM = { fg = 'base', bg = 'text' },
        NoiceCmdlinePopupBorder = { fg = 'love' },
        NoiceCmdlinePopupBorderSearch = { fg = 'iris' },
        NoiceCmdlineIconSearch = { fg = 'foam' },
        ['@keyword.directive'] = { fg = 'subtle' },
        ['@property.json'] = { fg = 'pine' },
        ['@string.json'] = { fg = 'text' },
        ['@number.json'] = { fg = 'text' },
        ['@property.yaml'] = { fg = 'pine' },
        ['@string.yaml'] = { fg = 'text' },
        ['@number.yaml'] = { fg = 'text' },
    }
})
vim.cmd('colorscheme rose-pine')
