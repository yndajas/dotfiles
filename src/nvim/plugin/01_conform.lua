vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

require("conform").setup({
  -- TODO: consider giving priority to LSP?
  default_format_opts = { lsp_format = "fallback", timeout_ms = 500 },
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
    json = { "jq", "biome-check", "prettier", stop_after_first = true },
    lua = { "stylua" },
    markdown = {
      "prettier",
      "markdownlint",
      "mdformat",
      stop_after_first = true,
      timeout_ms = 1000,
    },
    ruby = { "rubocop", timeout_ms = 5000 },
    rust = { "rustfmt" },
    sql = { "sqlfluff" },
    typescript = { "biome-check", "prettier", stop_after_first = true },
    yaml = { "yq", "yamlfmt", "prettier", stop_after_first = true },
    zsh = { "shellcheck" },
  },
})

require("conform").formatters["biome-check"] = {
  append_args = {
    "--css-formatter-enabled=true",
    "--graphql-formatter-enabled=true",
    "--html-formatter-enabled=true",
  },
}

require("conform").formatters.mdformat = {
  append_args = {
    "--wrap",
    "80",
    "--extensions",
    "gfm",
    "--extensions",
    "frontmatter",
  },
}
