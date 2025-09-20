return {
  {
    "j-hui/fidget.nvim",
    dependencies = {
      { "nvim-telescope/telescope.nvim" },
    },
    config = function()
      require("fidget").setup({})
      require("telescope").load_extension("fidget")
    end,
  },
}
