vim.pack.add({
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/neovim/nvim-lspconfig",
})

require("mason").setup()

vim.lsp.config("ruby_lsp", {
  cmd = { vim.fn.expand("~/.rbenv/shims/ruby-lsp") },
})

vim.lsp.enable("lua_ls")
vim.lsp.enable("ruby_lsp")
