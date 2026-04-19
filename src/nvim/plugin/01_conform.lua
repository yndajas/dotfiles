vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

require("conform").setup({
  -- TODO: consider giving priority to LSP?
  default_format_opts = { lsp_format = "fallback", timeout = 500 },
  format_on_save = {},
  formatters_by_ft = {
    bash = { "shellcheck" },
    c = { "clang-format" },
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
    html = { "prettier", "biome-check", stop_after_first = true },
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
})
