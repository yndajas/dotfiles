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
      {
        "Kaiser-Yang/blink-cmp-git",
        config = function ()
          local kind_hl = { default = false, fg = "#7287fd" }
          local label_id_hl = { default = false, fg = "#209fb5" }
          for _, kind in ipairs({ "Commit", "Issue", "Mention", "PR" }) do
            vim.api.nvim_set_hl(0, "BlinkCmpGitKind" .. kind, kind_hl)
            vim.api.nvim_set_hl(
              0,
              "BlinkCmpGitLabel" .. kind .. "Id",
              label_id_hl
            )
          end
        end
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
          gitcommit = { "git" },
          lua = { inherit_defaults = true, "lazydev" },
        },
        providers = {
          git = {
            module = "blink-cmp-git",
            name = "Git",
          },
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
