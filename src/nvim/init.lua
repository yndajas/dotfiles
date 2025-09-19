-- set leader key to space rather than backslash; needs to come before Lazy
vim.g.mapleader = " "

require("config.options") -- core (Neo)vim options
require("config.keymap") -- custom keymaps unrelated to any particular plugin
require("config.autocmds") -- autoc(om)m(an)ds

require("config.lazy") -- package management

require("config.lsp") -- language server protocol; probably needs to come after
                      -- Lazy
