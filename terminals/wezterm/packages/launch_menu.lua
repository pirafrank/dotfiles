-----------------
-- launch menu --
-----------------

local utils = require 'utils'

-- This table will hold the launch menu entries
local launch_menu = {}

-- the default command to run programs in WSL from Windows
local wsl_default_args = { 'wsl.exe', '-d', 'Ubuntu-20.04', 'sh', '-c' }

-- convert *nix args to a single exec command
local function nix_args_to_single_command(nix_args)
    local command = ""
    for i, arg in ipairs(nix_args) do
        if i == 1 then
            command = arg
        else
            command = command .. " " .. arg
        end
    end
    return "exec " .. command
end

-- convert *nix args to WSL args
local function nix_to_wsl_args_entry(wsl_args, nix_args)
    local processed = {}
    for i, v in ipairs(wsl_args) do
        processed[i] = v
    end
    processed[#wsl_args + 1] = nix_args_to_single_command(nix_args)
    return processed
end

-- merge launch menu sequences of tables into one sequence
-- while converting *nix entries to WSL entries
local function merge_seq_of_tables(win_only, nix)
    local merged = {}
    for i, v in ipairs(win_only) do
        merged[i] = v
    end
    for i, v in ipairs(nix) do
        local entry = {}
        for k, w in pairs(v) do
            if k == "args" then
                entry[k] = nix_to_wsl_args_entry(wsl_default_args, w)
            else
                entry[k] = w
            end
        end
        merged[#win_only + i] = entry
    end
    return merged
end

--
-- *nix entries
--
-- note: these will be automatically propagated to WSL entries on Windows
--
local nix_menu_entries = {
  {
    label = 'top',
    args = { 'top' },
  },
  {
    label = 'ctop - Container top',
    args = { 'ctop' },
  },
  {
    label = 'lazydocker',
    args = { 'lazydocker' },
  },
  {
    label = 'dry - Docker dashboard',
    args = { 'dry' },
  },
  {
    label = 'kdash - Kubernetes dashboard',
    args = { 'kdash' },
  },
}

--
-- windows only entries
-- note: 'local' domain is required for Windows entries to work when WSL is set as the default domain
--
local windows_only_menu_entries = {
  {
    label = 'WSL (default distro)',
    args = { 'wsl.exe' },
    domain = { DomainName = 'local' },
  },
  {
    label = 'PowerShell 7',
    args = { 'C:/Program Files/PowerShell/7/pwsh.exe' },
    domain = { DomainName = 'local' },
  },
  {
    label = 'Git bash',
    args = { 'C:/Program Files/Git/bin/bash.exe', '--login' },
    domain = { DomainName = 'local' },
  },
  {
    label = 'Windows PowerShell',
    args = { 'powershell.exe', '-NoLogo' },
    domain = { DomainName = 'local' },
  }
}

-- populate launch_menu table
if utils.is_windows then
  local merged_and_converted_to_wsl = merge_seq_of_tables(windows_only_menu_entries, nix_menu_entries)
  for _, entry in ipairs(merged_and_converted_to_wsl) do
    table.insert(launch_menu, entry)
  end
else
  for _, entry in ipairs(nix_menu_entries) do
    table.insert(launch_menu, entry)
  end
end

return launch_menu
