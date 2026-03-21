-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
--
--
--
--
--
-- Indent Markdown lines between headers (non-code-block safe)
local INDENT_SPACES = 2 -- <-- set 2 or 3 to avoid Markdown code blocks

local function indent_between_headers(by_level)
  if vim.bo.filetype ~= "markdown" then
    vim.notify("IndentMarkdown: not a markdown buffer", vim.log.levels.WARN)
    return
  end
  local api = vim.api
  local buf = 0
  local lines = api.nvim_buf_get_lines(buf, 0, -1, false)

  local in_code = false
  local current_level = 0

  local function header_level(s)
    local hashes = s:match("^%s*(#+)%s+")
    return hashes and #hashes or 0
  end

  for i = 1, #lines do
    local line = lines[i] or ""

    -- toggle on ``` or ~~~ fences
    if line:match("^%s*```") or line:match("^%s*~~~") then
      in_code = not in_code
    elseif not in_code then
      local lvl = header_level(line)
      if lvl > 0 then
        current_level = lvl
        lines[i] = line:gsub("^%s+", "") -- keep headers unindented
      elseif line:match("^%s*$") then
        -- keep blank lines
      else
        if current_level > 0 then
          local base = line:gsub("^%s+", "") -- normalize first
          local nspaces = by_level and (INDENT_SPACES * (current_level - 1)) or INDENT_SPACES
          -- guard: never reach 4+ which would create code blocks
          if nspaces >= 4 then
            nspaces = 3
          end
          lines[i] = string.rep(" ", nspaces) .. base
        end
      end
    end
  end

  api.nvim_buf_set_lines(buf, 0, -1, false, lines)
end

vim.api.nvim_create_user_command("IndentMarkdown", function()
  indent_between_headers(false)
end, { desc = "Indent lines between markdown headers (safe width)" })

vim.api.nvim_create_user_command("IndentMarkdownByLevel", function()
  indent_between_headers(true)
end, { desc = "Indent lines between markdown headers (by level, safe width)" })
-- JSON COLORSCHEME
local function set_json_colors()
  vim.cmd("highlight @property.json guifg=#ff9e64")
  vim.cmd("highlight @string.json guifg=#bb9af7")
end

-- run immediately (fixes startup)
set_json_colors()

-- run again whenever colorscheme changes
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = set_json_colors,
})
