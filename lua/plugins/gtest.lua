return {
  "hfn92/cmake-gtest.nvim",
  lazy = false,
  config = function()
    require("cmake-gtest").setup {
      SetKeyBinds {
        n = {
          ["<C-t>"] = { [[<cmd>GTestRunTestsuite<CR>]], "Run current Testsuite" },
          ["<leader>tc"] = { [[<cmd>GTestCancel<CR>]], "Cancel current test" },
          ["<leader>ts"] = { [[<cmd>GTestSelectAndRunTestsuite<CR>]], "Run Testsuite" },
          ["<leader>tt"] = { [[<cmd>GTestSelectAndRunTest<CR>]], "Run Test" },
        },
      },
    }
  end,
}
