vim.pack.add({ "https://github.com/ibhagwan/fzf-lua" })

require("fzf-lua").setup({
  actions = {
    files = {
      ["enter"] = FzfLua.actions.file_edit,
    },
  },
  git = {
    files = {
      cmd = "git ls-files --exclude-standard --cached --other | sort",
    },
  },
})

vim.keymap.set("n", "<leader>fzf", ":FzfLua ", { desc = "FzfLua" })
vim.keymap.set("n", "<leader>ffg", ":FzfLua git_files<CR>", {
  desc = "Find git files",
})
vim.keymap.set("n", "<leader>fff", ":FzfLua files<CR>", {
  desc = "Find files",
})
vim.keymap.set("n", "<leader>fg", ":FzfLua live_grep<CR>", {
  desc = "Live grep files (--file/pattern for glob)",
})
vim.keymap.set("n", "<leader>fb", ":FzfLua buffers<CR>", {
  desc = "Find buffers",
})
-- TODO: diagnostics? code actions? any others?
