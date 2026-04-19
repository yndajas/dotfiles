vim.pack.add({ "https://github.com/lewis6991/gitsigns.nvim" })

require("gitsigns").setup({
  current_line_blame = true,
  -- lower priority than diagnostics
  current_line_blame_opts = { virt_text_priority = 10000 },
})
