vim.diagnostic.config({
  severity_sort = true,
  -- TODO: consider switching to just unconditional virtual lines - virtual text
  -- looks nice but it doesn't play well with half a small screen
  virtual_text = true,
  virtual_lines = { current_line = true },
})
