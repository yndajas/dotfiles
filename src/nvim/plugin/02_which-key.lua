vim.pack.add({ "https://github.com/folke/which-key.nvim" })

-- needs to come after any plugins that add key bindings
require("which-key").setup({ delay = 0, preset = "helix" })
