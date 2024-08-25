return {
  'andythigpen/nvim-coverage',
  cmd = { 'CoverageLoadLcov' },
  config = function()
    require('coverage').setup {
      signs = {
        covered = { hl = 'CoverageCovered', text = '▎' },
        uncovered = { hl = 'CoverageUncovered', text = 'X' },
        partial = { hl = 'CoverageCovered', text = '▎' },
      },

      load_coverage_cb = function(ftype)
        vim.notify('Loaded ' .. ftype .. ' coverage')
      end,
    }
  end,
}
