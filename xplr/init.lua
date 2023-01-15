version = '0.20.2'

-- general settings
xplr.config.general.enable_mouse = true
xplr.config.general.show_hidden = true

-- set plugins
local home = os.getenv("HOME")
package.path = home
.. "/.config/xplr/plugins/?/init.lua;"
.. home
.. "/.config/xplr/plugins/?.lua;"
.. package.path

-- plugins to load

-- https://github.com/prncss-xyz/icons.xplr
require"icons".setup()

