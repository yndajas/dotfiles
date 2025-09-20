local quit_maps = { "q", "quit" }

-- alias :bq[uit] to :bd[elete], mirroring :q for buffers
--we get bang support for free because the alias is still composable
for _, quit_map in ipairs({ "q", "quit" }) do
  vim.keymap.set("ca", "b" .. quit_map, "bdelete")
end

-- alias :w[rite]bd[elete] and :w[rite]bq[uit] to :write|bdelete
for _, write_map in ipairs({ "w", "write" }) do
  for _, delete_map in ipairs({ "d", "delete" }) do
    vim.keymap.set("ca", write_map .. "b" .. delete_map, "write|bdelete")
  end

  for _, quit_map in ipairs(quit_maps) do
    vim.keymap.set("ca", write_map .. "b" .. quit_map, "write|bdelete")
  end
end

-- alias option-up/down to move current line (normal mode) or selected lines
-- (visual mode)
vim.keymap.set("v", "<M-Up>", ":move '<-2<CR>gv=gv")
vim.keymap.set("v", "<M-Down>", ":move '>+1<CR>gv=gv")
vim.keymap.set("n", "<M-Up>", "<S-v> :move '<-2<CR><S-v>=")
vim.keymap.set("n", "<M-Down>", "<S-v> :move '>+1<CR><S-v>=")

-- alias tab and shift-tab to buffer next/previous
vim.keymap.set("n", "<Tab>", ":bnext<CR>")
vim.keymap.set("n", "<S-Tab>", ":bprev<CR>")
