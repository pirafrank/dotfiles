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
    for _, module_name in ipairs(modules) do
        -- check if plugin dir exists
        if folder_exists(home .. "/.config/xplr/plugins/" .. module_name) then
          local module = require(module_name)
          -- check if module has a setup function
          if type(module.setup) == "function" then
              module.setup()
          end
        end
    end
end


-- PLUGINS HERE!
-- add plugins to load to this array.
-- they will be loaded only if their dir exists in ~/.config/xplr/plugins.
local modules = {
  -- git clone https://github.com/prncss-xyz/icons.xplr ~/.config/xplr/plugins/icons
  "icons",
}

-- keep this at the bottom
require_modules(modules)
