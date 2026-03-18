return {
  {
    "nvim-mini/mini.nvim",
    version = false, -- or '*' for stable
    config = function()
      require("mini.ai").setup()
      require("mini.comment").setup()
      -- add more modules here if you want
    end,
  },
}
