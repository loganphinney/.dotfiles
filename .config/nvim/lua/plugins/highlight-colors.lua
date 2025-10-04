return {
    'brenoprata10/nvim-highlight-colors',
    config = function()
        require('nvim-highlight-colors').setup({
            render = 'virtual',
            enable_short_hex = false,
            enable_named_colors = false,
        })
    end
}
