--DIAGNOSTIC MESSAGES
vim.diagnostic.config({
    virtual_text = {
        prefix = '',
        spacing = 2
    },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true
})
-- VIM.LSP.BUF.FORMAT
vim.keymap.set('n', '<space>tt', function() vim.lsp.buf.format() end)
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then return end

        if client:supports_method('textDocument/formatting') then
            vim.api.nvim_create_autocmd('BufWritePre', {
                buffer = args.buf,
                callback = function()
                    vim.lsp.buf.format({ bufnr = args.buf, lsp_client_id = client.id })
                end
            })
        end
    end,
})
--FRIENDLY SNIPPETS
require("luasnip.loaders.from_vscode").lazy_load()
