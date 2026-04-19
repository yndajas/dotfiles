vim.pack.add({
  { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
})

-- I think this might be needed before plugins that use highlights in some cases
vim.cmd.colorscheme("catppuccin-nvim")
