vim.pack.add({ 'https://github.com/rose-pine/neovim' })
require('rose-pine').setup({
    palette = {
        main = {
            pine = '#3e8fb0'
        }
    },
    styles = { transparency = true },
    highlight_groups = {
        jsonKeyword = { fg = 'foam' },
        jsonKeywordMatch = { fg = 'subtle' },
        jsonString = { fg = 'text' },
        jsonNumber = { fg = 'text' },
        jsonBoolean = { fg = 'text' },
        jsonQuote = { fg = 'subtle' },
        jsonBraces = { fg = 'subtle' },
        jsonNoise = { fg = 'subtle' },
        yamlBlockMappingKey = { fg = 'pine' },
        yamlFlowString = { fg = 'text' },
        yamlInteger = { fg = 'text' },
        yamlFloat = { fg = 'text' },
        yamlBool = { fg = 'text' },
        yamlNull = { fg = 'text' },
        yamlBlockMappingDelimiter = { fg = 'subtle' },
        yamlBlockScalarHeader = { fg = 'iris' },
        yamlFlowMappingDelimiter = { fg = 'subtle' },
        yamlFlowStringDelimiter = { fg = 'subtle' },
        yamlFlowIndicator = { fg = 'subtle' },
        yamlBlockCollectionItemStart = { fg = 'subtle' },
        yamlDocumentStart = { fg = 'subtle' },
        NoiceCmdlinePopupBorder = { fg = 'love' },
        NoiceCmdlinePopupBorderSearch = { fg = 'iris' },
        NoiceCmdlineIconSearch = { fg = 'foam' },
    }
})
vim.cmd('colorscheme rose-pine')
