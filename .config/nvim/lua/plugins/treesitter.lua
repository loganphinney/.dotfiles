vim.pack.add({
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/nvim-treesitter/nvim-treesitter-context'
})
vim.api.nvim_create_autocmd('FileType', {
    callback = function()
        if pcall(vim.treesitter.start) then
            vim.wo.foldmethod = 'expr'
            vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
            vim.opt.fillchars:append({ fold = '─' })
            vim.o.foldtext = ''
            vim.o.foldlevelstart = 99
            vim.o.foldlevel = 99
        end
    end,
})
require('nvim-treesitter').install {
    'bash',
    'zsh',
    'python',
    'perl',
    'go',
    'java',
    'lua',
    'nix',
    --
    'json',
    'yaml',
    'toml',
    'ini',
    'markdown',
    'xml',
    --
    'sql',
    'awk',
    'regex',
    'jinja',
    --
    'make',
    'nginx',
    'dockerfile',
    'helm',
    'terraform',
    'hcl',
    --
    'html',
    'css',
    'typescript',
    --
    'git_config',
    'git_rebase',
    'gitcommit',
    'gitignore',
    'gitattributes',
    'ssh_config',
    'comment',
    'vimdoc',
}
require('treesitter-context').setup({
    max_lines = 4,
    trim_scope = 'outer',
})
