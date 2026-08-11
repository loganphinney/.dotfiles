vim.pack.add({
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/nvim-treesitter/nvim-treesitter-context'
})
vim.api.nvim_create_autocmd('FileType', { callback = function() pcall(vim.treesitter.start) end, })
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
