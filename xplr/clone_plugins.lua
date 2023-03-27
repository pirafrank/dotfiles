
function create_folder_if_not_exists(folder_path)
    local success, err = os.execute("mkdir -p " .. folder_path)
    if not success then
        print("Error creating folder:", err)
    end
end

function check_if_folder_exists(path)
    local file = io.open(path)
    if file then
        file:close()
        return true
    else
        return false
    end
end

-- reading user's $HOME
local home = os.getenv("HOME")

-- load plugins list
local f = assert(loadfile(home .. "/dotfiles/xplr/plugins.lua"))
local plugins = f()

-- set plugin target dir
local xplr_plugins_dir = home .. "/.config/xplr/plugins"

-- create xplr plugins dir if it doesn't exist
create_folder_if_not_exists(xplr_plugins_dir)

for _, plugin_entry in ipairs(plugins) do
  local plugin_name = plugin_entry.name or plugin_entry[1] -- plugin name is 1st param
  local plugin_url = plugin_entry.repo_url or plugin_entry[2] -- repo url is 2nd param
  if plugin_url then
    local clone_target = xplr_plugins_dir .. "/" .. plugin_name
    if check_if_folder_exists(clone_target) then
      -- if it's already been cloned, pull
      print("Repo exists locally. Pulling " .. plugin_name .. " from " .. plugin_url)
      os.execute("cd " .. clone_target .. "; git pull; cd ..")
    else
      -- otherwise, clone repo
      print("Cloning " .. plugin_name .. " from " .. plugin_url)
      os.execute("git clone " .. plugin_url .. " " .. clone_target)
    end
  end
end
