return {
    'rose-pine/neovim',
    name = 'rose-pine',
    priority = 1000,
    config = function()
        require('rose-pine').setup({
            palette = {
                main = {
                    pine = '#3e8fb0'
                }
            }
        })
        vim.cmd('colorscheme rose-pine')
    end
}
