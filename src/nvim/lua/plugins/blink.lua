return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    opts = {
      completion = {
        documentation = {
          auto_show = true,
          window = { border = "single" },
        },
        ghost_text = { enabled = true },
        keyword = { range = "full" },
        menu = {
          border = "single",
          draw = {
            columns = {
              { "kind" },
              { "label" },
              { "label_description"}
            },
            -- highlight label
            treesitter = { "lsp" },
          },
        },
      },
      keymap = { preset = "super-tab" },
      signature = {
        enabled = true,
        window = { border = "single", show_documentation = false },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
  },
}
