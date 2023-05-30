version = '0.21.0'

-- NOTE:
-- you can load any config file using --extra-config or -C.
-- e.g.: xplr -C some_config.lua

-- general settings
xplr.config.general.enable_mouse = true
xplr.config.general.show_hidden = false



-- check if file (file or dir) exists without using any external library
function folder_exists(path)
    local file = io.open(path)
    if file then
        file:close()
        return true
    else
        return false
    end
end

-- setup plugins loading
local home = os.getenv("HOME")
package.path = home
.. "/.config/xplr/plugins/?/init.lua;"
.. home
.. "/.config/xplr/plugins/?.lua;"
.. package.path

-- load plugins function
function require_modules(modules)
    for _, module_entry in ipairs(modules) do
        local module_name = module_entry.name or module_entry[1]
        local setup_args = module_entry.args
        -- check if plugin dir exists
        if folder_exists(home .. "/.config/xplr/plugins/" .. module_name) then
          -- handling optional 'before' function, sets stuff BEFORE plugin load
          local before = module_entry.before
          if type(before) == "function" then
            before()
          end
          -- loading plugin
          local module = require(module_name)
          -- check if module has a setup function
          if type(module.setup) == "function" then
            if setup_args then
                module.setup(setup_args)
            else
                module.setup()
            end
            -- handling optional 'after' function, sets stuff AFTER plugin load
            local after = module_entry.after
            if type(after) == "function" then
              after()
            end
          end
        -- safe fallback: do nothing
        end
    end
end

-- *** PLUGINS HERE ***
-- plugins are loader here reading the list from an external file!
-- if you want to add/edit loaded plugins, edit plugins.lua.
local f = assert(loadfile(home .. "/.config/xplr/plugins.lua"))
local modules = f()

-- actually loading plugins
require_modules(modules)


-- *** KEYBINDINGS ***

-- use enter to enter dirs
/*
xplr.config.modes.builtin.default.key_bindings.on_key["enter"] = {
  help = "enter",
  messages = {
    "Enter"
  },
}
*/

