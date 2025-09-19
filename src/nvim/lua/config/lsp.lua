-- apply quick fix from code actions
-- if you use this on one line then select other lines and type @@ or @: it will
-- repeat the command for the selected lines
vim.api.nvim_create_user_command("QuickFix", function ()
  vim.lsp.buf.code_action({
    filter = function(action) return action.isPreferred end,
    apply = true,
  })
end, {})

vim.lsp.enable("lua_ls")
vim.lsp.enable("ruby_lsp")
