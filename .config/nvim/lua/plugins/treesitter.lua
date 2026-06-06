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
    'json',
    'yaml',
    'ini',
    'regex',
    'html',
    'bash',
    'perl',
    'python',
    'nix',
    'typescript'
}
