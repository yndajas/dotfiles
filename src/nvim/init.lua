-- set leader key to space rather than backslash; needs to come before Lazy
vim.g.mapleader = " "

require("vim._core.ui2").enable({})

require("config.options") -- core (Neo)vim options
require("config.keymap") -- custom keymaps unrelated to plugins
require("config.autocmds") -- autoc(om)m(an)ds unrelated to plugins
require("config.user_commands") -- user commands unrelated to plugins
require("config.pack") -- plugin management
require("config.diagnostics") -- diagnostics (e.g. from LSPs)
