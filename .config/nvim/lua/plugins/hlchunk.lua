return {
    'shellRaining/hlchunk.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
        require('hlchunk').setup({
            --[[chunk = {
                enable = true,
                style = '#524f67',
                chars = {
                    horizontal_line = "─",
                    vertical_line = "│",
                    left_top = "╭",
                    left_bottom = "╰",
                    right_arrow = "─",
                },
            },--]]
            blank = {
                enable = true,
                style = '#524f67',
                chars = { ' ', '․', '⁚', '⁖', '⁘', '⁙' },
            },
        })
    end
}
