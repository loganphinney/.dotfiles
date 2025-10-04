return {
    "folke/zen-mode.nvim",
    vim.keymap.set('n', '<leader>zz', ':ZenMode<CR>', { desc = 'Zen Mode' }),
    opts = {
        window = {
            backdrop = 1.0,
            -- height and width can be:
            -- * an absolute number of cells when > 1
            -- * a percentage of the width / height of the editor when <= 1
            -- * a function that returns the width or the height
            width = 120,   -- width of the Zen window
            height = 0.95, -- height of the Zen window
            options = {
                -- by default, no options are changed for the Zen window
                -- uncomment any of the options below, or add other vim.wo options you want to apply
                -- signcolumn = "no", -- disable signcolumn
                -- number = false, -- disable number column
                relativenumber = false, -- disable relative numbers
                -- cursorline = false, -- disable cursorline
                -- cursorcolumn = false,   -- disable cursor column
                -- foldcolumn = "0", -- disable fold column
                -- list = false, -- disable whitespace characters
            }
        }
    }
}
