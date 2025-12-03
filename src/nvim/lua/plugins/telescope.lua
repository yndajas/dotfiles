return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    config = function()
      require("telescope").load_extension("fzf")
      require("telescope").setup {
        pickers = {
          buffers = {
            mappings = {
              i = {
                ['<M-d>'] = require('telescope.actions').delete_buffer
              },
              n = {
                ['<M-d>'] = require('telescope.actions').delete_buffer
              }
            }
          },
          find_files = {
            hidden = true,
            no_ignore = false,
          },
        },
      }

      vim.keymap.set("n", "<leader>t", ":Telescope ")

      local builtin = require("telescope.builtin")
      vim.keymap.set(
        "n", "<leader>fff", function()
          builtin.find_files(
            {
              find_command = {
                "fd",
                "--strip-cwd-prefix",
                "--hidden",
                "--follow",
                "--exclude",
                ".git",
                "--type",
                "f",
              },
            }
          )
        end, { desc = "Find file with fd" }
      )
      -- exclude git submodules (by default), unlike fd
      vim.keymap.set("n", "<leader>ffg", function()
        builtin.git_files({ show_untracked = true })
      end, { desc = "Find file with git" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, {
        desc = "Grep files"
      })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, {
        desc = "Find buffer"
      })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, {
        desc = "Find help" }
      )
      vim.keymap.set("n", "<leader>fd", function()
        builtin.diagnostics({ bufnr = 0, sort_by = "severity", wrap_results = true })
      end, { desc = "Find diagnostics" })
    end,
  },
}
