vim.pack.add({
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/saghen/blink.cmp',
    'https://github.com/nvimdev/lspsaga.nvim'
})
local capabilities = {}
pcall(function() capabilities = require('blink.cmp').get_lsp_capabilities() end)
vim.lsp.enable({
    'bashls',
    'lua_ls',
    'perlpls',
    'nixd',
    'pyright',
    'ruff',
    'jsonls',
    'ansiblels',
    'terraformls',
    'ts_ls',
})
vim.lsp.config('*', { capabilities = capabilities })
vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            diagnostics = { globals = { 'vim' } },
            workspace = { library = { vim.env.VIMRUNTIME } }
        }
    }
})
vim.filetype.add({
    extension = {
        tf = 'terraform',
        tfvars = 'terraform',
        terraform = 'terraform',
        ansible = 'yaml.ansible',
    }
})
require('luasnip.loaders.from_vscode').lazy_load()
