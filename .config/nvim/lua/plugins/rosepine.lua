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
        ['@property.json'] = { fg = 'foam' },
        ['@string.json'] = { fg = 'text' },
        ['@number.json'] = { fg = 'text' },
        ['@boolean.json'] = { fg = 'rose' },
        ['@property.yaml'] = { fg = 'foam' },
        ['@string.yaml'] = { fg = 'text' },
        ['@number.yaml'] = { fg = 'text' },
        ['@boolean.yaml'] = { fg = 'rose' },
    }
})
vim.cmd('colorscheme rose-pine')
