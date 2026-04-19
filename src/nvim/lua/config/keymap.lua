-- alias option-up/down to move current line (normal mode) or selected lines
-- (visual mode)
vim.keymap.set("v", "<M-Up>", ":move '<-2<CR>gv=gv")
vim.keymap.set("v", "<M-Down>", ":move '>+1<CR>gv=gv")
vim.keymap.set("n", "<M-Up>", "<S-v> :move '<-2<CR><S-v>=")
vim.keymap.set("n", "<M-Down>", "<S-v> :move '>+1<CR><S-v>=")

-- alias tab and shift-tab to buffer next/previous
vim.keymap.set("n", "<Tab>", ":bnext<CR>")
vim.keymap.set("n", "<S-Tab>", ":bprev<CR>")

-- LSP
vim.keymap.set(
  "n",
  "<leader>lsp",
  ":lua vim.lsp.buf.",
  { desc = "Run an LSP action in command mode" }
)
