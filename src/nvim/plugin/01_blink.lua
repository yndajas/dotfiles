vim.pack.add({
  {
    src = "https://github.com/saghen/blink.cmp",
    version = vim.version.range("1.x"),
  },
  "https://github.com/folke/lazydev.nvim",
  "https://github.com/Kaiser-Yang/blink-cmp-dictionary",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "lua" },
  callback = function()
    require("lazydev").setup({
      library = {
        -- load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    })
  end,
})

vim.api.nvim_set_hl(0, "BlinkCmpKindDict", { default = false, fg = "#1e66f5" })

require("blink.cmp").setup({
  cmdline = {
    keymap = { preset = "inherit" },
    completion = {
      menu = { auto_show = true },
      list = { selection = { preselect = false, auto_insert = false } },
    },
  },
  completion = {
    documentation = {
      auto_show = true,
      window = { border = "single" },
    },
    keyword = { range = "full" },
    menu = {
      border = "single",
      draw = {
        columns = {
          { "kind" },
          { "label" },
          { "label_description" },
        },
        components = {
          kind = {
            text = function(ctx)
              if vim.api.nvim_get_mode().mode == "c" then
                return ""
              else
                return ctx.kind
              end
            end,
          },
        },
        -- highlight label
        treesitter = { "lsp" },
      },
    },
  },
  keymap = { preset = "super-tab" },
  signature = {
    enabled = true,
    window = { border = "single", show_documentation = false },
  },
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
    per_filetype = {
      gitcommit = { "dictionary" },
      lua = { inherit_defaults = true, "lazydev" },
      markdown = { "dictionary" },
      text = { "dictionary" },
    },
    providers = {
      dictionary = {
        module = "blink-cmp-dictionary",
        name = "Dict",
        min_keyword_length = 3,
        opts = {
          dictionary_files = {
            vim.fn.expand("~/.config/nvim/lua/config/words_alpha.txt"),
          },
        },
      },
      lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        -- make lazydev completions top priority (see `:h blink.cmp`)
        score_offset = 100,
      },
    },
  },
})
