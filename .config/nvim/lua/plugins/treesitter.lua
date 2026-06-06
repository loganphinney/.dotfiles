--[[
return {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    dependencies = { 'nvim-treesitter/nvim-treesitter-context' },
    config = function()
        require('nvim-treesitter').setup {
            sync_install = false,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            }
        }
        require('nvim-treesitter').install {
            'bash',
            'lua',
            'perl',
            'python',
            'vim',
            'vimdoc',
            'query',
            'markdown',
            'markdown_inline',
            'regex',
            'json',
            'yaml',
            'nix',
            'html',
            'hcl',
        }
    end
}
]] --
