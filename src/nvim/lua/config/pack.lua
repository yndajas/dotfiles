vim.api.nvim_create_user_command("DeleteInactivePlugins", function()
  local inactive_plugin_names = vim
    .iter(vim.pack.get())
    :filter(function(plugin)
      return not plugin.active -- no vim.pack.add call
    end)
    :map(function(plugin)
      return plugin.spec.name
    end)
    :totable()
  vim.pack.del(inactive_plugin_names)
end, { desc = "Delete inactive plugins" })

vim.api.nvim_create_user_command("UpdatePlugins", function()
  vim.pack.update()
end, { desc = "Update plugins" })

-- if plugin lockfile hasn't been updated in the last week, remind to:
-- - delete unused plugins
-- - check for updates to plugins
local current_time = os.time()
local last_update_time =
  io.popen('stat -f %m "${DOTFILES_DIR}"/src/nvim/nvim-pack-lock.json'):read()
local week_in_seconds = 60 * 60 * 24 * 7

if current_time - last_update_time >= week_in_seconds then
  print("Remember to :DeleteInactivePlugins and :UpdatePlugins")
end
