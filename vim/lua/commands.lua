-- helper function
local function command(alias, cmd, opts, desc)
  opts.desc = desc
  vim.api.nvim_create_user_command(alias, cmd, opts)
end

--
-- *** Helpers ***
--

local function get_current_buffer_absolute_path()
  local abs_path = vim.fn.expand('%:p')
  vim.fn.setreg('+', abs_path)
  vim.notify(abs_path .. " copied to clipboard")
end

command('PathAbsolute', get_current_buffer_absolute_path, {}, 'Copy buffer absolute path')

-- Get current buffer path relative to git root
local function get_current_buffer_relative_path()
  local current_file = vim.fn.expand('%:p')
  local git_root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]

  if vim.v.shell_error ~= 0 then
    vim.notify("Not in a git repository", vim.log.levels.ERROR)
    return
  end

  local relative_path = string.sub(current_file, string.len(git_root) + 2)
  vim.fn.setreg('+', relative_path)
  vim.notify(relative_path .. " copied to clipboard")
end

command('PathRelative', get_current_buffer_relative_path, {}, 'Copy buffer path relative to git root')

--
-- *** Terminal ***
--

-- open terminal in bottom split like in vim
-- every time you run :Terminal it will open a new terminal as bottom split
command('Terminal', 'botright split | terminal', {}, 'Open terminal in bottom split')

-- credits: https://gist.github.com/shivamashtikar/16a4d7b83b743c9619e29b47a66138e0
--
-- Function to quickly open/hide terminal window inside vim
-- Terminal operation  when
-- 1. terminal is open in split window, it closes the window (terminal still
--    running)
-- 2. terminal open in buffer, it moves window into split window
-- 3. no termial instance running then it opens new terminal instance in split
--    window
local function Term()
  local terminal_buffer_number = vim.fn.bufnr("term://")
  local terminal_window_number = vim.fn.bufwinnr("term://")
  local window_count = vim.fn.winnr("$")

  if terminal_window_number > 0 and window_count > 1 then
    vim.fn.execute(terminal_window_number .. "wincmd c")
  elseif terminal_buffer_number > 0 and terminal_buffer_number ~= vim.fn.bufnr("%") then
    vim.fn.execute("sb " .. terminal_buffer_number)
  elseif terminal_buffer_number == vim.fn.bufnr("%") then
    vim.fn.execute("bprevious | sb " .. terminal_buffer_number .. " | wincmd p")
  else
    vim.fn.execute("sp term://zsh")
  end
  vim.cmd.startinsert()
end

command("Term", Term, {}, "Open terminal window")

--
-- *** Frecency ***
--
local telescope = require('telescope')
local themes = require('telescope.themes')

local function frequent_files()
  telescope.extensions.frecency.frecency(themes.get_dropdown({
    prompt_title = "Frequent Files",
    cwd = vim.fn.getcwd()
  }))
end

command('FrequentFiles', frequent_files, {}, "Get frequent files (Frecency)")

--
-- *** Floaterm ***
--
command('Lg', 'FloatermNew lazygit', {}, 'lazygit')
command('Yazi', 'FloatermNew yazi', {}, 'yazi')
command('Xplr', 'FloatermNew xplr', {}, 'xplr')
command('Lf', 'FloatermNew lf', {}, 'lf')

--
-- *** Copilot Chat ***
--

local copilotchat = require("CopilotChat")
local copilotchat_actions = require("CopilotChat.actions")
local copilotchat_telescope = require("CopilotChat.integrations.telescope")

command('CopilotChatWithBuffer', (function()
  local input = vim.fn.input("Quick Chat: ")
  if input ~= "" then
    copilotchat.ask(input, { selection = require("CopilotChat.select").buffer })
  end
end), {}, "Copilot: Chat with current Buffer")

-- Show help actions with telescope
command('CopilotChatHelp', (function()
  copilotchat_telescope.pick(copilotchat_actions.help_actions())
end), {}, "Copilot: Show help actions")

-- Show prompts actions with telescope
command('CopilotChatPrompts', (function()
  copilotchat_telescope.pick(copilotchat_actions.prompt_actions())
end), {}, "Copilot: Show prompt actions")
