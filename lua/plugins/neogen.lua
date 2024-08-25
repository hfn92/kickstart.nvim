return {
  {
    'danymat/neogen',
    -- branch = "cpp_alt_comment_style",
    dependencies = 'nvim-treesitter/nvim-treesitter',
    cmd = { 'Neogen' },
    config = function()
      local i = require('neogen.types.template').item
      require('neogen').setup {
        snippet_engine = 'luasnip',

        languages = {
          cpp = {
            template = {
              annotation_convention = 'my_doxygen',
              my_doxygen = {
                { nil, '/// \\file', { no_results = true, type = { 'file' } } },
                { nil, '/// \\brief $1', { no_results = true, type = { 'func', 'file', 'class' } } },
                { nil, '', { no_results = true, type = { 'file' } } },

                { i.ClassName, '/// \\class %s', { type = { 'class' } } },
                { i.Type, '/// \\typedef %s', { type = { 'type' } } },
                { nil, '/// \\brief $1', { type = { 'func', 'class', 'type' } } },
                { i.Tparam, '/// \\tparam %s $1' },
                { i.Parameter, '/// \\param %s $1' },
                { i.Return, '/// \\return $1' },
              },
            },
          },
        },

        placeholders_text = {
          ['description'] = '',
          ['tparam'] = '',
          ['parameter'] = '',
          ['return'] = '',
          ['class'] = '',
          ['throw'] = '',
          ['varargs'] = '',
          ['type'] = '',
          ['attribute'] = '',
          ['args'] = '',
          ['kwargs'] = '',
        },
      }
    end,
    -- Uncomment next line if you want to follow only stable versions
    -- version = "*"
  },
}
