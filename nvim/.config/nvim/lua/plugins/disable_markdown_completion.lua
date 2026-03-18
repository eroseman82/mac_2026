return {
  -- If you're using blink.cmp (new LazyVim default in many setups)
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.enabled = function()
        return vim.bo.filetype ~= "markdown"
      end
    end,
  },

  -- If you're using nvim-cmp (older LazyVim setups or if you enabled the extra)
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.enabled = function()
        return vim.bo.filetype ~= "markdown"
      end
    end,
  },
}
