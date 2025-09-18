-- set leader key to space rather than backslash; needs to come before Lazy
vim.g.mapleader = " "

require("config.options") -- core (Neo)vim options
require("config.lazy") -- package management

