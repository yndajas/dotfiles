vim.pack.add({ "https://github.com/nvim-lualine/lualine.nvim" })

require("lualine").setup({
  tabline = {
    lualine_a = {
      {
        "buffers",
        icons_enabled = false,
        component_separators = { left = "|", right = "" },
        max_length = function()
          return vim.o.columns
        end,
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
})
