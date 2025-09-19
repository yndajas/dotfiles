return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        -- lower priority than diagnositics
        virt_text_priority = 10000,
      },
    },
  },
}
