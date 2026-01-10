return {
    'saghen/blink.cmp',
    dependencies = {
        {
            'L3MON4D3/LuaSnip',
            dependencies = { "rafamadriz/friendly-snippets" },
            build = "make install_jsregexp"
        }
    },
    version = '1.*',
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        keymap = { preset = 'super-tab' },
        appearance = { nerd_font_variant = 'mono' },
        snippets = { preset = 'luasnip' },
        signature = { enabled = true },
        completion = {
            documentation = { auto_show = true },
            list = { selection = { preselect = false, auto_insert = false } }
        },
        sources = { default = { 'lsp', 'path', 'snippets', 'buffer', 'cmdline' } },
        fuzzy = { implementation = 'prefer_rust_with_warning', sorts = { 'exact', 'score', 'sort_text' } },
        cmdline = {
            keymap = { preset = 'inherit' },
            completion = { menu = { auto_show = true } }
        }
    },
    opts_extend = { "sources.default" },
}
