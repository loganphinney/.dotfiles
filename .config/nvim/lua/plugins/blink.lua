vim.pack.add({
    'https://github.com/saghen/blink.lib',
    'https://github.com/saghen/blink.cmp',
    'https://github.com/L3MON4D3/LuaSnip',
    'https://github.com/rafamadriz/friendly-snippets',
})
local blink = require('blink.cmp')
blink.build():pwait()
blink.setup({
    keymap = { preset = 'super-tab' },
    appearance = { nerd_font_variant = 'mono' },
    snippets = { preset = 'luasnip' },
    signature = { enabled = true },
    completion = {
        documentation = { auto_show = true },
        list = { selection = { preselect = false, auto_insert = false } }
    },
    sources = { default = { 'lsp', 'path', 'snippets', 'buffer', 'cmdline' } },
    fuzzy = { implementation = 'prefer_rust_with_warning' },
    cmdline = {
        keymap = { preset = 'inherit' },
        completion = { menu = { auto_show = true } },
    },
    enabled = function() return not vim.tbl_contains({ 'markdown' }, vim.bo.filetype) end
})
