vim.pack.add({ 'https://github.com/stevearc/conform.nvim' })
require('conform').setup({
    formatters_by_ft = {
        yaml = { 'yamlfmt' }
    }
})
