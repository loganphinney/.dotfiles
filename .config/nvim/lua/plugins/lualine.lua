return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        local p = require('rose-pine.palette')
        local rose_pine = {
            normal = {
                a = { bg = 'NONE', fg = p.rose, gui = 'bold' },
                b = { bg = 'NONE', fg = p.rose },
                c = { bg = 'NONE', fg = p.subtle, gui = 'italic' },
            },
            insert = {
                a = { bg = 'NONE', fg = p.foam, gui = 'bold' },
                b = { bg = 'NONE', fg = p.foam },
                c = { bg = 'NONE', fg = p.subtle, gui = 'italic' },
            },
            visual = {
                a = { bg = 'NONE', fg = p.iris, gui = 'bold' },
                b = { bg = 'NONE', fg = p.iris },
                c = { bg = 'NONE', fg = p.subtle, gui = 'italic' },
            },
            replace = {
                a = { bg = 'NONE', fg = p.pine, gui = 'bold' },
                b = { bg = 'NONE', fg = p.pine },
                c = { bg = 'NONE', fg = p.subtle, gui = 'italic' },
            },
            command = {
                a = { bg = 'NONE', fg = p.love, gui = 'bold' },
                b = { bg = 'NONE', fg = p.love },
                c = { bg = 'NONE', fg = p.subtle, gui = 'italic' },
            },
            inactive = {
                a = { bg = 'NONE', fg = p.subtle, gui = 'bold' },
                b = { bg = 'NONE', fg = p.subtle },
                c = { bg = 'NONE', fg = p.subtle, gui = 'italic' },
            },
        }
        require('lualine').setup({
            options = {
                theme = rose_pine,
                section_separators = '',
                component_separators = ''
            },
            sections = {
                lualine_x = { 'filetype' },
                lualine_y = { 'lsp_status' }
            }
        })
    end,
}
