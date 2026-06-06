vim.pack.add({
    'https://github.com/folke/noice.nvim',
    'https://github.com/MunifTanjim/nui.nvim'
})
require('noice').setup({
    presets = { command_palette = true },
    lsp = {
        override = {
            ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
            ['vim.lsp.util.stylize_markdown'] = true,
            ['cmp.entry.get_documentation'] = true
        }
    },
    views = {
        cmdline_popup = {
            border = {
                style = {
                    '┌', '─', '┐', '│',
                    '┘', '─', '└', '│'
                }
            }
        }
    }
})
