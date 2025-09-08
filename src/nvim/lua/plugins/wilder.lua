return {
  {
    "gelguy/wilder.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "romgrk/fzy-lua-native",
    },
    config = function()
      local wilder = require("wilder")
      wilder.setup {
        modes = { ":", "/", "?" },
        next_key = "<Down>",
        previous_key = "<Up>",
        reject_key = "<Left>",
        accept_key = "<Right>",
      }

      wilder.set_option("pipeline", {
        wilder.branch(
          wilder.search_pipeline(),
          {
            wilder.check(function(ctx, x) return x == "" end),
            wilder.history(),
          },
          wilder.cmdline_pipeline({ fuzzy = 2, hide_in_substitute = true })
        )
      })

      wilder.set_option("renderer", wilder.popupmenu_renderer(
        wilder.popupmenu_palette_theme({
          highlighter = wilder.lua_fzy_highlighter(),
          highlights = {
            accent = wilder.make_hl(
              "WilderAccent",
              "Pmenu",
              {
                { a = 1 },
                { a = 1 },
                {
                  foreground = "#f4468f",
                  background = "#eff1f5",
                  underline = true,
                }
              }
            ),
          },
          border = "rounded",
          max_height = "75%",
          min_height = 0,
          prompt_position = "top",
          reverse = 0,
          left = {
            " ",
            wilder.popupmenu_devicons(),
          },
          right = {
            " ",
            wilder.popupmenu_scrollbar(),
          },
        })
      ))
    end,
  },
}
