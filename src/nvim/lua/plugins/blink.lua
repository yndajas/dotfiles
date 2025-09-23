return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = {
      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            -- load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
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
        per_filetype = {
          lua = { inherit_defaults = true, "lazydev" },
        },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            -- make lazydev completions top priority (see `:h blink.cmp`)
            score_offset = 100,
          },
        },
      },
    },
  },
}
