vim.pack.add({
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/nvim-treesitter/nvim-treesitter-context'
})
require('nvim-treesitter').setup {
    sync_install = false,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false
    }
}
require('nvim-treesitter').install {
    'bash',
    'perl',
    'python',
    --
    'json',
    'yaml',
    'toml',
    'ini',
    --
    'awk',
    'regex',
    'html',
    --
    'nix',
    'typescript'
}
