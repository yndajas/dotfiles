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
        defaults = {
          mappings = {
            i = {
              ["<CR>"] = require("telescope.actions").select_tab,
            },
          },
        },
        pickers = {
          find_files = {
            hidden = true,
            no_ignore = false,
          },
        },
      }

      local builtin = require("telescope.builtin")
      vim.keymap.set(
        "n", "<leader>ff", function()
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
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, {
        desc = "Grep files"
      })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, {
        desc = "Find buffer"
      })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, {
        desc = "Find help" }
      )
    end,
  },
}
