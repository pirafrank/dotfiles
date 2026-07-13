return {
  s({ trig = 'def', name = 'Function', dscr = 'Create a Python function' }, {
    t('def '), i(1, 'function_name'), t('('), i(2), t({ '):', '    ' }),
    i(0, 'pass'),
  }),

  s({ trig = 'main', name = 'Main entry point', dscr = 'Create a Python main guard' }, {
    t({ 'def main():', '    ' }), i(1, 'pass'),
    t({ '', '', 'if __name__ == "__main__":', '    main()' }),
    i(0),
  }),
}
