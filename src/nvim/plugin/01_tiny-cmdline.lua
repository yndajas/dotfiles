vim.pack.add({ "https://github.com/rachartier/tiny-cmdline.nvim" })

-- tiny-cmdline.nvim asks you to set the cmdheight to 0, but with that set I
-- can't see any messages (like errors), so I haven't done this
require("tiny-cmdline").setup({ native_types = {} })
