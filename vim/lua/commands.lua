-- helper function
local function command(alias, cmd, opts, desc)
  opts.desc = desc
  vim.api.nvim_create_user_command(alias, cmd, opts)
end

--
-- *** Terminal ***
--

-- open terminal in bottom split like in vim
-- every time you run :Terminal it will open a new terminal as bottom split
vim.api.nvim_create_user_command('Terminal', 'botright split | terminal', {})

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

vim.api.nvim_create_user_command("Term", Term, {
  desc = "Open terminal window",
})

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

vim.api.nvim_create_user_command('FrequentFiles', frequent_files, {})

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

vim.api.nvim_create_user_command('CopilotChatWithBuffer', (function()
  local input = vim.fn.input("Quick Chat: ")
  if input ~= "" then
    copilotchat.ask(input, { selection = require("CopilotChat.select").buffer })
  end
end), {})

-- Show help actions with telescope
vim.api.nvim_create_user_command('CopilotChatHelp', (function()
  copilotchat_telescope.pick(copilotchat_actions.help_actions())
end), {})

-- Show prompts actions with telescope
vim.api.nvim_create_user_command('CopilotChatPrompts', (function()
  copilotchat_telescope.pick(copilotchat_actions.prompt_actions())
end), {})
