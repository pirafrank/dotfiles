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
        local setup_args = module_entry[2]
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

-- *** PLUGINS HERE! ***
-- add plugins to load the array below.
-- they will be loaded only if their dir exists in ~/.config/xplr/plugins.
local modules = {
  -- { "some_module_without_setup_args" },
  -- { "some_module_with_setup_args", { arg1 = "some value", arg2 = "something else" } }
  -- git clone https://github.com/prncss-xyz/icons.xplr ~/.config/xplr/plugins/icons
  { "icons" },
  { "material-landscape2", { keep_default_layout = true } }
}

-- keep this at the bottom
require_modules(modules)
