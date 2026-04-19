-- if you use this on one line then select other lines and type @@ or @: it will
-- repeat the command for the selected lines
vim.api.nvim_create_user_command("QuickFix", function()
  vim.lsp.buf.code_action({
    filter = function(action)
      return action.isPreferred
    end,
    apply = true,
  })
end, { desc = "Apply quick fix from LSP code actions" })

vim.api.nvim_create_user_command("PrepareRuby", function()
  vim.cmd([[!prepare_ruby_for_vim]])
end, { desc = "Prepare Ruby LSP and formatter" })
