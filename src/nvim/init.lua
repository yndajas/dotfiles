-- Set up basic config
-- scroll when reaching end of screen
vim.opt.scrolloff = 8

-- cursor style
-- default: "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,t:block-blinkon500-blinkoff500-TermCursor"
-- (according to https://neovim.io/doc/user/options.html#'guicursor', though the last part doesn't work)

vim.opt.guicursor = "n-v-c-sm-i:block,ci-ve:ver25,r-cr-o:hor20"

-- line numbers

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"

-- indentation

local indent_size = 2
vim.opt.tabstop = indent_size
vim.opt.softtabstop = indent_size
vim.opt.shiftwidth = indent_size
vim.opt.expandtab = true
vim.opt.smartindent = true

-- max line width

vim.opt.textwidth = 80
vim.opt.colorcolumn = "+1"

-- copy to OS clipboard with yy

vim.opt.clipboard = "unnamed"

-- Set up lazy.nvim for package management

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    }
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
     },
    {
        "junegunn/fzf",
        build = "./install --all",
     },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = {
            "nvim-lua/plenary.nvim",
         },
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
     },
    {
        "nvim-tree/nvim-web-devicons",
     },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
         },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
     },
}

-- Set up colour scheme

require("catppuccin").setup {
    flavour = "latte",
 }
vim.cmd [[colorscheme catppuccin]]

-- Set up Telescope
-- \ff = find files
-- \sf = search files

require("telescope").load_extension("fzf")
require("telescope").setup {
    pickers = {
        find_files = {
            hidden = true,
            no_ignore = false,
         },
    },
}

local builtin = require("telescope.builtin")
vim.keymap.set(
    "n", "<leader>ff", function()
        builtin.find_files(
            {
                find_command = {
                    "fd",
                    "--strip-cwd-prefix",
                    "--hidden",
                    "--follow",
                    "--exclude",
                    ".git",
                    "--type",
                    "f",
                },
            }
        )
    end, {}
)
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})

-- Set up lualine (status bar)

require("lualine").setup()

-- Set up Treesitter

require("nvim-treesitter.configs").setup {
    ensure_installed = {
        "c",
        "css",
        "csv",
        "diff",
        "dockerfile",
        "gdscript",
        "git_config",
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitignore",
        "godot_resource",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "python",
        "query",
        "ruby",
        "rust",
        "scss",
        "sql",
        "toml",
        "typescript",
        "vim",
        "vimdoc",
    },
    sync_install = false,
    highlight = {
        enable = true,
     },
    indent = {
        enable = true,
     },
}
