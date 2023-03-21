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
        local module_name = module_entry[1]
        local setup_args = module_entry[3]
        -- check if plugin dir exists
        if folder_exists(home .. "/.config/xplr/plugins/" .. module_name) then
          local module = require(module_name)
          -- check if module has a setup function
          if type(module.setup) == "function" then
            if setup_args then
                module.setup(setup_args)
            else
                module.setup()
            end
          end
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
