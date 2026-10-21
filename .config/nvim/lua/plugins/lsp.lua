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
    'yamlls',
    'ansiblels',
    'terraformls',
    'tflint',
    'ts_ls',
    'html',
    'cssls',
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
vim.lsp.config('pyright', {
    handlers = {
        ['$/progress'] = function(err, result, ctx)
            if result.token == (vim.g.basedpyright_progress_token or result.token) then
                vim.g.basedpyright_progress_token = result.token
                vim.lsp.handlers['$/progress'](err, result, ctx)
            end
        end,
    },
})
vim.lsp.config('terraformls', {
    capabilities = capabilities,
    on_attach = function(client) client.server_capabilities.semanticTokensProvider = nil end,
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
