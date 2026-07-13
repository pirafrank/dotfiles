return {
  s({ trig = 'fn', name = 'Local function', dscr = 'Create a local Lua function' }, {
    t('local function '), i(1, 'name'), t('('), i(2), t({ ')', '  ' }),
    i(0),
    t({ '', 'end' }),
  }),

  s({ trig = 'req', name = 'Require module', dscr = 'Require a Lua module into a local variable' }, {
    t('local '), i(1, 'module'), t(" = require('"), i(2, 'module'), t("')"),
    i(0),
  }),
}
