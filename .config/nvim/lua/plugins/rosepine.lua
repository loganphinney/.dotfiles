vim.pack.add({ 'https://github.com/rose-pine/neovim' })
require('rose-pine').setup({
    palette = {
        main = {
            pine = '#3e8fb0'
        }
    },
    styles = { transparency = true },
    highlight_groups = {
        NoiceCmdlinePopupBorder = { fg = 'love' },
        NoiceCmdlinePopupBorderSearch = { fg = 'iris' },
        NoiceCmdlineIconSearch = { fg = 'foam' },
        jsonString = { fg = 'text' },
        jsonNumber = { fg = 'text' },
        yamlDocumentStart = { fg = 'subtle' },
        yamlBlockMappingKey = { fg = 'pine' },
        yamlBlockCollectionItemStart = { fg = 'subtle' },
        yamlBlockMappingDelimiter = { fg = 'subtle' },
        yamlFlowString = { fg = 'text' },
        yamlFlowStringDelimiter = { fg = 'subtle' },
        yamlBool = { fg = 'text' },
        yamlInteger = { fg = 'text' },
        yamlTodo = { fg = 'rose', bg = 'none' }
    }
})
vim.cmd('colorscheme rose-pine')
