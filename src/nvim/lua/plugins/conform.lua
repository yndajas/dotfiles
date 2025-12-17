return {
  {
    "stevearc/conform.nvim",
    config = function()
      local conform = require("conform")

      conform.setup({
        default_format_opts = { lsp_format = "fallback", timeout = 500 },
        formatters_by_ft = {
          bash = { "shellcheck" },
          csharp = { "csharpier" },
          css = {
            "stylelint",
            "biome-check",
            "prettier",
            stop_after_first = true,
          },
          gdscript = { "gdformat" },
          go = { "gofmt" },
          graphql = { "biome-check", "prettier", stop_after_first = true },
          html = { "biome-check", "prettier", stop_after_first = true },
          javascript = { "biome-check", "prettier", stop_after_first = true },
          json = { "jq", "prettier", stop_after_first = true },
          lua = { "stylua" },
          markdown = { "prettier", "markdownlint", stop_after_first = true },
          ruby = { "rubocop" },
          rust = { "rustfmt" },
          sql = { "sqlfluff" },
          typescript = { "biome-check", "prettier", stop_after_first = true },
          yaml = { "yq", "yamlfmt", "prettier", stop_after_first = true },
          zsh = { "shellcheck" },
        },
        format_on_save = {},
      })

      vim.keymap.set("n", "<leader>cf", function()
        conform.format({ async = true })
      end, { desc = "Format buffer" })
    end,
  },
}
