-- from https://github.com/nvim-mini/mini.nvim/blob/main/lua/mini/trailspace.lua
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    local n_lines = vim.api.nvim_buf_line_count(0)
    local last_nonblank_line = vim.fn.prevnonblank(n_lines)

    if last_nonblank_line < n_lines then
      vim.api.nvim_buf_set_lines(0, last_nonblank_line, n_lines, true, {})
    end
  end,
})

-- copied from https://www.lazyvim.org/configuration/general#auto-commands
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "gitcommit", "markdown", "text" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})
