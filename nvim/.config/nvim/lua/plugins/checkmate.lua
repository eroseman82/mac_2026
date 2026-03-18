-- lua/plugins/checkmate.lua
return {
  "bngarren/checkmate.nvim",
  ft = "markdown",
  opts = {
    files = { "*.md" }, -- make it activate for any markdown filename. :contentReference[oaicite:0]{index=0}
    -- Replace ALL default keymaps with lowercase `t` versions:
    keys = {
      ["<leader>tt"] = {
        rhs = "<cmd>Checkmate toggle<CR>",
        desc = "Toggle todo",
        modes = { "n", "v" },
      },
      ["<leader>tm"] = {
        rhs = "<cmd>Checkmate check<CR>",
        desc = "Check todo",
        modes = { "n", "v" },
      },
      ["<leader>tu"] = {
        rhs = "<cmd>Checkmate uncheck<CR>",
        desc = "Uncheck todo",
        modes = { "n", "v" },
      },
      ["<leader>t="] = {
        rhs = "<cmd>Checkmate cycle_next<CR>",
        desc = "Cycle next state",
        modes = { "n", "v" },
      },
      ["<leader>t-"] = {
        rhs = "<cmd>Checkmate cycle_previous<CR>",
        desc = "Cycle prev state",
        modes = { "n", "v" },
      },
      ["<leader>tn"] = {
        rhs = "<cmd>Checkmate create<CR>",
        desc = "Create todo",
        modes = { "n", "v" },
      },
      ["<leader>tr"] = {
        rhs = "<cmd>Checkmate remove<CR>",
        desc = "Remove todo marker",
        modes = { "n", "v" },
      },
      ["<leader>tR"] = {
        rhs = "<cmd>Checkmate remove_all_metadata<CR>",
        desc = "Remove all metadata",
        modes = { "n", "v" },
      },
      ["<leader>ta"] = { rhs = "<cmd>Checkmate archive<CR>", desc = "Archive checked items", modes = { "n" } },
      ["<leader>tv"] = { rhs = "<cmd>Checkmate metadata select_value<CR>", desc = "Select meta value", modes = { "n" } },
      ["<leader>t]"] = { rhs = "<cmd>Checkmate metadata jump_next<CR>", desc = "Next metadata", modes = { "n" } },
      ["<leader>t["] = { rhs = "<cmd>Checkmate metadata jump_previous<CR>", desc = "Prev metadata", modes = { "n" } },
    },
  },
}

-- -- lua/plugins/checkmate.lua
-- return {
--   "bngarren/checkmate.nvim",
--   ft = "markdown",
--   opts = {
--     files = { "*.md" }, -- ensure it loads for your markdown files
--
--     -- Override default keymaps here:
--     keymaps = {
--       create = "<leader>tn", -- new todo
--       toggle = "<leader>tt", -- toggle state
--       check = "<leader>tc", -- mark as checked
--       uncheck = "<leader>tu", -- mark as unchecked
--       cycle = "<leader>t=", -- cycle state
--       archive = "<leader>ta", -- archive checked items
--     },
--   },
-- }
--
-- -- lua/plugins/checkmate.lua
-- return {
--   "bngarren/checkmate.nvim",
--   ft = "markdown", -- only loads for markdown buffers
--   opts = {
--     -- Activate on ANY markdown file:
--     files = { "*.md" }, -- or get fancy: { "*todo*", "docs/**/*.md" }
--     -- optional: see README for more options
--   },
-- }
--
-- -- lua/plugins/checkmate.lua
-- return {
--   "bngarren/checkmate.nvim",
--   ft = { "markdown" }, -- load only for markdown files
--   opts = {}, -- leave empty for defaults
-- }

-- return {
--   "bngarren/checkmate.nvim",
--   ft = "markdown", -- Lazy loads for Markdown files matching patterns in 'files'
--   opts = {
--     -- your configuration here
--     -- or leave empty to use defaults
--   },
-- }
