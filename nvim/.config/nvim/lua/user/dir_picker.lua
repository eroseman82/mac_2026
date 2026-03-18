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
