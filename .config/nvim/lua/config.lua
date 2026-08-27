--LOAD PLUGINS
local dir = vim.fn.stdpath('config') .. '/lua/plugins'
for _, file in ipairs(vim.fn.readdir(dir)) do
    if file:match('%.lua$') then
        require('plugins.' .. file:gsub('%.lua$', ''))
    end
end
-- PackUpdate
vim.api.nvim_create_user_command('PackUpdate', function()
    vim.pack.update()
end, {})
--DIAGNOSTIC MESSAGES
vim.diagnostic.config({
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    virtual_text = {
        spacing = 2,
        prefix = function(diagnostic)
            local icons = {
                [vim.diagnostic.severity.ERROR] = '',
                [vim.diagnostic.severity.WARN]  = '',
                [vim.diagnostic.severity.INFO]  = '',
                [vim.diagnostic.severity.HINT]  = '',
            }
            return icons[diagnostic.severity] or '󰝥'
        end,
    },
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
-- RESTORE CURSOR STYLE ON EXIT
vim.api.nvim_create_autocmd({ 'VimEnter', 'VimResume' }, {
    pattern = '*',
    command = [[set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50]]
        .. [[\,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor]]
        .. [[\,sm:block-blinkwait175-blinkoff150-blinkon175]],
})
vim.api.nvim_create_autocmd({ 'VimLeave', 'VimSuspend' }, {
    pattern = '*',
    command = 'set guicursor=a:block-blinkon0',
})
-- KEYBINDS
vim.keymap.set('n', '<leader>-', '<CMD>Oil<CR>')
vim.keymap.set('n', 'K', '<cmd>Lspsaga hover_doc<cr>')
vim.keymap.set('n', '<leader>ff', function() require('telescope.builtin').find_files() end)
vim.keymap.set('n', '<leader>fg', function() require('telescope.builtin').live_grep() end)
vim.keymap.set('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>')
vim.keymap.set('n', '<leader>zz', '<cmd>ZenMode<cr>', { desc = 'Zen Mode', })
vim.keymap.set('n', '<leader>ww', '<cmd>set wrap!<cr>')
