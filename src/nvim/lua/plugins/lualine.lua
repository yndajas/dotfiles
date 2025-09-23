return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      tabline = {
        lualine_a = {
          {
            "buffers",
            icons_enabled = false,
            component_separators = { left = "|", right = "" },
            max_length = vim.o.columns,
            mode = 4,
            section_separators = { left = "", right = "" },
          },
        },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {},
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "diagnostics" },
        lualine_y = { { "lsp_status", icons_enabled = false } },
        lualine_z = { { "location", padding = 0 } },
      },
    },
  }
}
