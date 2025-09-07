return {
  {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function()
        require("nvim-treesitter.configs").setup {
            ensure_installed = {
                "c",
                "css",
                "csv",
                "diff",
                "dockerfile",
                "gdscript",
                "git_config",
                "git_rebase",
                "gitattributes",
                "gitcommit",
                "gitignore",
                "godot_resource",
                "html",
                "javascript",
                "json",
                "lua",
                "markdown",
                "python",
                "query",
                "ruby",
                "rust",
                "scss",
                "sql",
                "toml",
                "typescript",
                "vim",
                "vimdoc",
            },
            sync_install = false,
            highlight = {
                enable = true,
             },
            indent = {
                enable = true,
             },
        }
      end,
   },
}
