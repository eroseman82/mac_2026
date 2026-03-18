-- ~/.config/nvim/lua/user/file_picker.lua
local M = {}

function M.open()
  require("telescope.builtin").find_files({
    prompt_title = "Pick a file",
    cwd = vim.fn.expand("~/Core/library"), -- 👈 change this to your target dir
    hidden = true, -- optional: show dotfiles too
    follow = true, -- follow symlinks
  })
end

return M

-- local M = {}
--
-- M.config_files = {
--   { name = "commands", path = "~/Core/library/commands.md" },
--   { name = "current", path = "~/Core/library/current.md" },
-- }
--
-- M.open = function()
--   require("lazy").load({ plugins = { "telescope.nvim" } })
--   local pickers = require("telescope.pickers")
--   local finders = require("telescope.finders")
--   local actions = require("telescope.actions")
--   local action_state = require("telescope.actions.state")
--   local conf = require("telescope.config").values
--
--   pickers
--     .new({}, {
--       prompt_title = "Edit Config File",
--       finder = finders.new_table({
--         results = M.config_files,
--         entry_maker = function(entry)
--           return {
--             value = entry,
--             display = entry.name,
--             ordinal = entry.name,
--           }
--         end,
--       }),
--       sorter = conf.generic_sorter({}),
--       attach_mappings = function(prompt_bufnr)
--         actions.select_default:replace(function()
--           actions.close(prompt_bufnr)
--           local selection = action_state.get_selected_entry()
--           local filepath = vim.fn.expand(selection.value.path)
--           vim.cmd("edit " .. filepath)
--         end)
--         return true
--       end,
--     })
--     :find()
-- end
--
-- return M
