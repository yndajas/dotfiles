return {
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    config = function()
      require("git-conflict").setup {
        highlights = {
          current = "DiffAdd",
          ancestor = "DiffChange",
          incoming = "DiffText",
        }
      }
    end
  },
}
