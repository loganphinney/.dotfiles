vim.pack.add({ 'https://github.com/goolord/alpha-nvim', 'https://github.com/nvim-tree/nvim-web-devicons' })
local theta = require('alpha.themes.theta')
local dashboard = require('alpha.themes.dashboard')
theta.file_icons.provider = 'devicons'
theta.header.opts.hl = 'SpecialComment'
theta.header.val = {
    '', '', '', '', '', '', '', '', '', '',
    '⠀⠀⠀⣾⣿⣿⣿⣿⣦⡀⢸⣿⣿⣿⣿⠃⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⡆⢸⣿⣿⣿⣿⡄⠀⠀⠀⠀⣠⣾⣿⣿⣿⣿⡿⢁⣿⣿⣿⣿⡇⠀⣸⣿⣿⣿⣿⣷⣄⠀⢀⣴⣿⣿⣿⣿⡟',
    '⠀⠀⠀⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠟⠸⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠀⠀⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠇⠘⠿⠿⠿⠿⠇⠀⠀⠀⠰⠿⠿⠿⠿⠿⠟⠀⠸⠿⠿⠿⠿⠀⠀⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠇',
    '⠀⠀⣴⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⠀⢠⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⡆⠀⣰⣶⣶⣶⡶⠀⠀⠀⣶⣶⣶⣶⡆⠀⣶⣶⣶⣶⣶⠀⢀⣶⣶⣶⣶⣶⡶⠀⠀⠀⣶⣶⣶⣶⡆⠀⢰⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⠀',
    '⠀⢰⣿⣿⣿⣿⠉⠻⣿⣿⣿⣿⣿⡟⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠁⠀⣿⣿⣿⣿⠇⠀⠀⢸⣿⣿⣿⣿⠀⠀⢸⣿⣿⣿⣿⣧⣾⣿⣿⣿⣿⠟⠁⠀⠀⢸⣿⣿⣿⣿⠁⠀⣿⣿⣿⣿⠇⠙⢿⣿⠟⢹⣿⣿⣿⣿⡇⠀',
    '⠀⣾⣿⣿⣿⡟⠀⠀⢸⣿⣿⣿⣿⠃⢠⣿⣿⣿⣿⡿⠉⠉⠉⠉⠉⠉⠀⢸⣿⣿⣿⡿⠀⠀⠀⣿⣿⣿⣿⡇⠀⠀⠈⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠀⠀⠀⠀⣿⣿⣿⣿⡇⠀⢸⣿⣿⣿⣿⠀⠀⠈⠁⠀⣼⣿⣿⣿⡿⠀⠀',
    '⢠⣿⣿⣿⣿⠁⠀⠀⣿⣿⣿⣿⡿⠀⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⢸⣿⣿⣿⣷⣶⣶⣾⣿⣿⣿⡟⠀⠀⠀⠀⢻⣿⣿⣿⣿⣿⣿⠟⠁⠀⠀⠀⠀⣸⣿⣿⣿⣿⠁⠀⣿⣿⣿⣿⡇⠀⠀⠀⠀⢰⣿⣿⣿⣿⠇⠀⠀',
    '⣼⣿⣿⣿⡏⠀⠀⢸⣿⣿⣿⣿⡇⢀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⠀⠀⠈⠻⢿⣿⣿⣿⣿⣿⡿⠟⠋⠀⠀⠀⠀⠀⠸⣿⣿⣿⣿⣿⠋⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⡟⠀⢸⣿⣿⣿⣿⠀⠀⠀⠀⠀⣾⣿⣿⣿⣿⠀⠀⠀',
    '', '', '', '', '', '', '', '', '', '',
}
theta.buttons.val = {
    { type = 'text',    val = 'Quick links', opts = { hl = 'SpecialComment', position = 'center' } },
    { type = 'padding', val = 1 },
    dashboard.button('e', '  New file', '<cmd>ene<CR>'),
    dashboard.button('c', '  Configuration', '<cmd>exe \'cd\' stdpath (\'config\')<CR>'),
    dashboard.button('u', '  Update plugins', '<cmd>PackUpdate<CR>'),
    dashboard.button('q', '󰅚  Quit', '<cmd>qa<CR>'),
    dashboard.button('spc ff', '󰈞  fzf'),
    dashboard.button('spc fg', '󰈞  rg'),
}
require('alpha').setup(theta.config)
