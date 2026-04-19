vim.pack.add({
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-treesitter/nvim-treesitter-context",
  "https://github.com/rrethy/nvim-treesitter-endwise",
})

-- incremental_selection is now built in with van an an an in in in
-- TODO: run :TSUpdate when updating nvim-treesitter if it gets unarchived

local file_types_excluding_ruby = {
  "bash",
  "c",
  "c_sharp",
  "comment",
  "cpp",
  "css",
  "csv",
  "diff",
  "dockerfile",
  "editorconfig",
  "gdscript",
  "git_config",
  "git_rebase",
  "gitattributes",
  "gitcommit",
  "gitignore",
  "go",
  "godot_resource",
  "gomod",
  "graphql",
  "html",
  "javascript",
  "jq",
  "jsdoc",
  "json",
  "jsonnet",
  "lua",
  "luap",
  "make",
  "markdown",
  "markdown_inline",
  "mermaid",
  "perl",
  "python",
  "query",
  "regex",
  "rust",
  "scss",
  "sql",
  "terraform",
  "tmux",
  "toml",
  "tsx",
  "typescript",
  "vimdoc",
  "yaml",
  "zsh",
}

require("nvim-treesitter").install(file_types_excluding_ruby)
vim.api.nvim_create_autocmd("FileType", {
  pattern = file_types_excluding_ruby,
  callback = function()
    vim.treesitter.start()
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

require("nvim-treesitter").install({ "ruby" })
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "ruby" },
  callback = function()
    vim.treesitter.start()
  end,
})
