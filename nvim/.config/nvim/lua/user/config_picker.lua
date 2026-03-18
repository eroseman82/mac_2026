local M = {}

M.config_files = {
  { name = "nvim", path = "~/.config/nvim/init.lua" },
  { name = "tmux", path = "~/.config/tmux/tmux.conf" },
  { name = "tmux_mappings", path = "~/.config/tmux/tmux.reset.conf" },
  { name = "zsh", path = "~/.zshrc" },
  { name = "ghostty", path = "~/.config/ghostty/config" },
  { name = "alacritty", path = "~/.config/alacritty/alacritty.yml" },
  { name = "nvim_mappings", path = "~/.config/nvim/lua/plugins/astrocore.lua" },
  { name = "config_picker", path = "~/.config/nvim/lua/user/config_picker.lua" },
  { name = "yazi", path = "~/.config/yazi/keymap.toml" },
  { name = "file_picker", path = "~/.config/nvim/lua/user/file_picker.lua" },
}

M.open = function()
  require("lazy").load({ plugins = { "telescope.nvim" } })
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local conf = require("telescope.config").values

  pickers
    .new({}, {
      prompt_title = "Edit Config File",
      finder = finders.new_table({
        results = M.config_files,
        entry_maker = function(entry)
          return {
            value = entry,
            display = entry.name,
            ordinal = entry.name,
          }
        end,
      }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          local filepath = vim.fn.expand(selection.value.path)
          vim.cmd("edit " .. filepath)
        end)
        return true
      end,
    })
    :find()
end

return M
