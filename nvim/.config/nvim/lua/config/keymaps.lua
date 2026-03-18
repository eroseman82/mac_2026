-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- ~/.config/nvim/lua/user/keymaps.lua
-- All custom keymaps live here
-- This file is loaded in init.lua with: require("user.keymaps")

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- =====================
-- NORMAL MODE KEYMAPS
-- =====================
--
map("i", "jk", "<Esc>", { desc = "Exit insert mode with jk" })
map("n", "<leader>rj", ":%!jq .", { desc = "Clean Json" })
map("n", "<leader>rk", [[:%s/^\(\d\+\), \(.*\), \(.*\)$/(\1, '\2', '\3'),/<CR>]], { desc = "wrap todos" })
map("n", "<leader>ft", "<cmd>ToggleTerm direction=float<CR>", { desc = "Open floating terminal" })
map("n", "<leader>rn", "<cmd>%s/^\\s*null,\\s*//<CR>", { desc = "Drop first NULL column" })
map("n", "<leader>ru", "<cmd>%s/.*/\\L&/<CR>", { desc = "Lowercase entire file" })
map("n", "<leader>ro", [[:%s/\([.!?]\) \+/\1\r/g<CR>]], { desc = "Move next sentence to new line" })
map(
  "n",
  "<leader>rr",
  "<cmd>%s/\\v(^|,)\\zs\\s*\\ze(,|$)/NULL/g<CR>",
  { desc = "CSV clean: fill empty fields with NULL" }
)
map("n", "<leader>r,", "<cmd>%s/,,/,/g<CR>", { desc = "Get rid of double ," })

-- DELETE all then paste
map("n", "<leader>p", '<cmd>%delete _<CR>"+p', { desc = "Replace buffer with clipboard" })

-- OPEN TMUX IN NEW PANE
map("n", "<leader>tp", function()
  local path = vim.fn.expand(vim.fn.expand("<cfile>"))
  os.execute("tmux split-window -h -c " .. vim.fn.shellescape(path))
end, { desc = "Open path in tmux pane" })

-- Markdown indentation keymaps (LazyVim-style)
-- Helper commands defined elsewhere (in autocmds.lua or similar)
map("n", "<leader>mi", "<cmd>IndentMarkdown<CR>", { desc = "Indent between Markdown headers" })
map("n", "<leader>mI", "<cmd>IndentMarkdownByLevel<CR>", { desc = "Indent Markdown by header level" })

map(
  "n",
  "<leader>rp",
  "<cmd>%s/\\s*,\\s*/,/g | %s/\\v^\\s*(?=,)/NULL/g | %s/\\v,(\\s*)(?=,|$)/,NULL/g | %s/\\v(^|,)null(?=,|$)/\\1NULL/gI<CR>",
  { desc = "Clean CSV: trim spaces, fill empty cells, normalize NULL" }
)
map(
  "n",
  "<leader>rt",
  "<cmd>%s/\\s*,\\s*/,/g | %s/^,/NULL,/g | %s/,,/,NULL,/g | %s/,$/,NULL/g | %s/\\v(^|,)null(,|$)/\\1NULL\\2/gI<CR>",
  { desc = "Clean CSV: trim spaces, fill empty cells, normalize NULL" }
)
map("n", "<leader>rs", "<cmd>g/^[,[:space:]]*$/d<CR>", { desc = "Remove empty comma rows" })

map(
  "n",
  "<leader>rc",
  "<cmd>%s/^\\s*,/NULL,/g | %s/,\\s*,/,NULL,/g | %s/,\\s*$/ ,NULL/g<CR>",
  { desc = "Replace empty CSV cells with NULL" }
)

map("n", "<leader>qw", ":w<CR>", { desc = "Save current buffer" })
map(
  "n",
  "<leader>j",
  "i                                                                            ",
  { desc = "dashedLine" }
)

-- Next buffer
map("n", "<Tab>", ":bnext<CR>", { desc = "Next buffer" })

-- Previous buffer
map("n", "<S-Tab>", ":bprevious<CR>", { desc = "Previous buffer" })

map(
  "n",
  "<leader>cb",
  [[:%g/^\s*\S/ v/^\s*-\s\[\s\]\s/ normal! ^i- [ ] <CR>]],
  { desc = "Add checkboxes to all lines without one" }
)

-- Buffer navigation
map("n", "]b", function()
  require("astrocore.buffer").nav(vim.v.count1)
end, { desc = "Next buffer" })
map("n", "[b", function()
  require("astrocore.buffer").nav(-vim.v.count1)
end, { desc = "Previous buffer" })

-- Delete all lines in current buffer
map("n", "<leader>da", ":%d<CR>", { desc = "Delete all lines in buffer" })

-- Format JSON using jq
map("n", "<leader>fj", ":%!jq .<CR>", { desc = "Fix JSON formatting" })

-- Delete all instances of word under cursor globally
map("n", "<leader>dw", [[:%s/\<\<<C-r><C-w>\>\>//g<CR>]], { desc = "Delete word under cursor globally" })

-- Scroll down 15 lines without moving cursor
map("n", "<leader>gu", [[15<C-e><CR>]], { desc = "Scroll down 15 lines" })

-- Paste after cursor inline (no newline)
map("n", "gp", function()
  vim.api.nvim_put({ vim.fn.getreg('"') }, "c", true, true)
end, { desc = "Paste after cursor inline" })

-- PICKERS --
map("n", "<leader>fd", function()
  require("user.config_picker").open()
end, { desc = "Find config file" })

-- keymaps.lua or wherever you set keymaps
vim.keymap.set("n", "<leader>fi", function()
  require("user.file_picker").open()
end, { desc = "Find file in library" })

vim.keymap.set("n", "<leader>fs", function()
  require("user.todo_picker").open()
end, { desc = "Find ToDos" })

-- map("n", "<leader>fi", function()
--   require("user.file_picker").open()
-- end, { desc = "Find config file" })

-- Close buffer from tabline (AstroNvim heirline picker)
-- map("n", "<leader>bd", function()
--   require("astroui.status.heirline").buffer_picker(function(bufnr)
--     require("astrocore.buffer").close(bufnr)
--   end)
-- end, { desc = "Close buffer from tabline" })

-- =====================
-- VISUAL MODE KEYMAPS
-- =====================
-- Delete blank lines in selection
map("v", "<leader>dw", [[:<C-u>'<,'>g/^\s*$/d<CR>]], { desc = "Delete blank lines in selection" })

-- Wrap the current paragraph in { ... } and indent body
map("n", "<leader>wp", function()
  require("user.wrap").wrap_paragraph({ open = "{", close = "}" })
end, { desc = "Wrap paragraph with {}" })
