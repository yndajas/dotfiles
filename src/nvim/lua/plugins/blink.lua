return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = {
      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            -- load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
      {
        "Kaiser-Yang/blink-cmp-git",
        config = function ()
          local kind_hl = { default = false, fg = "#7287fd" }
          local label_id_hl = { default = false, fg = "#209fb5" }
          for _, kind in ipairs({ "Commit", "Issue", "Mention", "PR" }) do
            vim.api.nvim_set_hl(0, "BlinkCmpGitKind" .. kind, kind_hl)
            vim.api.nvim_set_hl(
              0,
              "BlinkCmpGitLabel" .. kind .. "Id",
              label_id_hl
            )
          end
        end
      },
      {
        "Kaiser-Yang/blink-cmp-dictionary",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function ()
          vim.api.nvim_set_hl(
            0,
            "BlinkCmpKindDict",
            { default = false, fg = "#1e66f5" }
          )
        end
      },
    },
    opts = {
      completion = {
        documentation = {
          auto_show = true,
          window = { border = "single" },
        },
        ghost_text = { enabled = true },
        keyword = { range = "full" },
        menu = {
          border = "single",
          draw = {
            columns = {
              { "kind" },
              { "label" },
              { "label_description"}
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
          gitcommit = { "git", "dictionary" },
          lua = { inherit_defaults = true, "lazydev" },
          markdown = { "dictionary" },
          text = { "dictionary" },
        },
        providers = {
          dictionary = {
            module = 'blink-cmp-dictionary',
            name = 'Dict',
            min_keyword_length = 3,
            opts = {
              dictionary_files = {
                vim.fn.expand(
                  "~/.config/nvim/lua/plugins/data/words_alpha.txt"
                )
              },
            }
          },
          git = {
            module = "blink-cmp-git",
            name = "Git",
          },
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            -- make lazydev completions top priority (see `:h blink.cmp`)
            score_offset = 100,
          },
        },
      },
    },
  },
}
