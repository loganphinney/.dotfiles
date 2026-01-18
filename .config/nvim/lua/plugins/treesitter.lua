return {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    dependencies = { 'nvim-treesitter/nvim-treesitter-context' },
    config = function()
        require('nvim-treesitter.configs').setup {
            ensure_installed = {
                "bash",
                "lua",
                "perl",
                "vim",
                "vimdoc",
                "query",
                "markdown",
                "markdown_inline",
                "json",
                "yaml",
                "html",
                "regex",
                "nix",
            },
            sync_install = false,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            }
        }
    end
}
