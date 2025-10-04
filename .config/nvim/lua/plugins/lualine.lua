return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        require('lualine').setup({
            options = {
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
