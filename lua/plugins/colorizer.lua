return {
  "hfn92/nvim-colorizer.lua",
  lazy = false,
  config = function(_, opts)
    require("colorizer").setup {
      user_default_options = {
        names = false,
        RRGGBB = true,
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        -- AARRGGBB = true, -- 0xAARRGGBB hex codes
      },
    }

    -- execute colorizer as soon as possible
    vim.defer_fn(function()
      require("colorizer").attach_to_buffer(0)
    end, 0)
  end,
}
