-- ~/.config/nvim/lua/user/wrap.lua
local M = {}

-- Find paragraph bounds around the cursor (separated by blank lines)
local function para_bounds()
  local cur = vim.api.nvim_win_get_cursor(0)[1]
  local last = vim.api.nvim_buf_line_count(0)

  local s = cur
  while s > 1 do
    local line = vim.api.nvim_buf_get_lines(0, s - 2, s - 1, false)[1] or ""
    if line:match("^%s*$") then
      break
    end
    s = s - 1
  end

  local e = cur
  while e < last do
    local line = vim.api.nvim_buf_get_lines(0, e, e + 1, false)[1] or ""
    if line:match("^%s*$") then
      break
    end
    e = e + 1
  end

  -- s/e are the first/last NON-blank lines of the paragraph
  return s, e
end

-- Shift a range right by one 'shiftwidth' (Nvim's :> command)
local function shift_right(start_lnum, end_lnum)
  vim.cmd(("%d,%d>"):format(start_lnum, end_lnum))
end

-- Wrap the current paragraph with open/close lines and indent the body
function M.wrap_paragraph(opts)
  opts = opts or {}
  local open = opts.open or "{"
  local close = opts.close or "}"
  local indent_body = opts.indent ~= false -- default: true

  local s, e = para_bounds()
  if s > e then
    return
  end

  -- Insert open above, close below
  vim.api.nvim_buf_set_lines(0, s - 1, s - 1, false, { open })
  vim.api.nvim_buf_set_lines(0, e + 1, e + 1, false, { close })

  -- After insertion:
  --   open is at line s
  --   body is now s+1 .. e+1
  --   close is at e+2
  if indent_body then
    shift_right(s + 1, e + 1)
  end
end

-- Wrap current VISUAL selection with open/close and indent body
function M.wrap_selection(opts)
  opts = opts or {}
  local open = opts.open or "{"
  local close = opts.close or "}"
  local indent_body = opts.indent ~= false

  -- Visual marks are 1-based and inclusive
  local s = vim.fn.getpos("'<")[2]
  local e = vim.fn.getpos("'>")[2]
  if s > e then
    s, e = e, s
  end

  vim.api.nvim_buf_set_lines(0, s - 1, s - 1, false, { open })
  vim.api.nvim_buf_set_lines(0, e + 1, e + 1, false, { close })
  if indent_body then
    shift_right(s + 1, e + 1)
  end
end

return M
