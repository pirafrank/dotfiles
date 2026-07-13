return {
  s({ trig = 'fn', name = 'Function', dscr = 'Create a Rust function' }, {
    t('fn '), i(1, 'name'), t('('), i(2), t({ ') {', '    ' }),
    i(0),
    t({ '', '}' }),
  }),

  s({ trig = 'test', name = 'Test function', dscr = 'Create a Rust unit test' }, {
    t({ '#[test]', 'fn ' }), i(1, 'test_name'), t({ '() {', '    ' }),
    i(0),
    t({ '', '}' }),
  }),
}
