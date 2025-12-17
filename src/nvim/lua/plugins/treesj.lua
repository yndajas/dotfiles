return {
  {
    "Wansmer/treesj",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      local treesj = require("treesj")

      treesj.setup({ use_default_keymaps = false })

      vim.keymap.set(
        "n",
        "<leader>sj",
        treesj.toggle,
        { desc = "Toggle single-/multi-line list" }
      )
    end,
  },
}
