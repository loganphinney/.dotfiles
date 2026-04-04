return {
    'rose-pine/neovim',
    name = 'rose-pine',
    priority = 1000,
    config = function()
        require('rose-pine').setup({
            palette = { main = { pine = '#3e8fb0' } },
            styles = { transparency = true },
            highlight_groups = {
                yamlBlockMappingKey = { fg = 'pine', bold = true },
                yamlFlowString = { fg = 'text' },
                yamlInteger = { fg = 'text' },
                yamlFloat = { fg = 'text' },
                yamlBool = { fg = 'text' },
                yamlNull = { fg = 'text' },
                yamlBlockMappingDelimiter = { fg = 'foam', bold = true },
                yamlBlockScalarHeader = { fg = 'foam', bold = true },
                yamlFlowStringDelimiter = { fg = 'foam', bold = true },
                yamlFlowIndicator = { fg = 'foam', bold = true },
                yamlBlockCollectionItemStart = { fg = 'foam', bold = true },
                yamlDocumentStart = { fg = 'subtle' },
                NoiceCmdlinePopupBorder = { fg = 'love' },
                NoiceCmdlinePopupBorderSearch = { fg = 'iris' },
                NoiceCmdlineIconSearch = { fg = 'foam' },
            },
        })
        vim.cmd('colorscheme rose-pine')
    end
}
