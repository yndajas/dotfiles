return {
  {
    "rachartier/tiny-code-action.nvim",
    dependencies = {
      {"nvim-lua/plenary.nvim"},
      {"nvim-telescope/telescope.nvim"},
    },
    event = "LspAttach",
    config = function ()
      local tiny_code_action = require("tiny-code-action")

      tiny_code_action.setup { backend = "delta" }

      vim.keymap.set(
        { "n", "x" },
        "<leader>ca",
        tiny_code_action.code_action,
        { noremap = true, silent = true, desc = "Choose code action" }
      )
    end
  }
}
