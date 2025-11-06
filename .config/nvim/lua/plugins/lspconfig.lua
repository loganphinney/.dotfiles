return {
    'neovim/nvim-lspconfig',
    dependencies = { 'saghen/blink.cmp', 'nvimdev/lspsaga.nvim' },
    config = function()
        local capabilities = require('blink.cmp').get_lsp_capabilities()
        vim.lsp.enable({ 'lua_ls', 'bashls', 'perlpls', 'nixd', 'ts_ls', })
        vim.lsp.config('*', { capabilities = capabilities })
        vim.lsp.config('lua_ls', {
            settings = {
                Lua = {
                    diagnostics = { globals = { 'vim' } },
                    workspace = { library = { vim.env.VIMRUNTIME } }
                }
            }
        })
    end,
}
