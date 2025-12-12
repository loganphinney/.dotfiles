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
        -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
        -- 'super-tab' for mappings similar to vscode (tab to accept)
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        -- ALL PRESETS have the following mappings:
        -- C-space: Open menu or open docs if already open
        -- C-n/C-p or Up/Down: Select next/previous item
        -- C-e: Hide menu
        -- C-k: Toggle signature help (if signature.enabled = true)
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
