-- *** DAP (Debug Adapter Protocol) Configuration ***
-- This file sets up debugging support for Neovim using nvim-dap and Mason.

local dap = require('dap')
local dapui = require('dapui')

-- *** Mason DAP Setup ***
-- Mason will manage DAP adapters like codelldb
require('mason-nvim-dap').setup({
  -- Automatically install these adapters via Mason
  ensure_installed = {
    'codelldb',  -- For Rust, C, C++
  },
  -- Automatically setup adapters
  automatic_setup = true,
  handlers = {},
})

-- *** DAP UI Setup ***
-- Provides a nice UI for debugging (similar to VSCode)
dapui.setup({
  icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  layouts = {
    {
      elements = {
        -- Elements can be strings or table with id and size keys.
        { id = "scopes", size = 0.25 },
        "breakpoints",
        "stacks",
        "watches",
      },
      size = 40, -- 40 columns
      position = "left",
    },
    {
      elements = {
        "repl",
        "console",
      },
      size = 0.25, -- 25% of total lines
      position = "bottom",
    },
  },
  controls = {
    enabled = true,
    -- Display controls in this element
    element = "repl",
    icons = {
      pause = "",
      play = "",
      step_into = "",
      step_over = "",
      step_out = "",
      step_back = "",
      run_last = "",
      terminate = "",
    },
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil,
    border = "single", -- Border style. Can be "single", "double" or "rounded"
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
  render = {
    max_type_length = nil, -- Can be integer or nil.
    max_value_lines = 100, -- Can be integer or nil.
  }
})

-- *** Auto-open/close DAP UI ***
-- Automatically open DAP UI when debugging starts
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end

-- Automatically close DAP UI when debugging ends
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

-- *** CodeLLDB Adapter Configuration ***
-- CodeLLDB is automatically configured by mason-nvim-dap,
-- but we can override settings if needed

-- Manual setup (optional, mason-nvim-dap handles this automatically)
-- Uncomment and modify if you need custom configuration
--[[
dap.adapters.codelldb = {
  type = 'server',
  port = "${port}",
  executable = {
    -- This will be automatically set by mason-nvim-dap to the correct path
    command = vim.fn.stdpath("data") .. '/mason/bin/codelldb',
    args = {"--port", "${port}"},
  }
}
--]]

-- *** LLDB Adapter Alias ***
-- Many launch.json files use "type": "lldb" instead of "type": "codelldb"
-- Create an alias so both work
dap.adapters.lldb = dap.adapters.codelldb

-- *** Rust DAP Configuration ***
-- Rustaceanvim provides better integration with rust-analyzer
-- and sets up DAP automatically, so we don't configure it here manually.
-- The configuration is in languages.lua where Rustaceanvim is set up.

-- However, if you want to add custom configurations for Rust, you can do it like this:
--[[
dap.configurations.rust = {
  {
    name = 'Launch',
    type = 'codelldb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},
  },
}
--]]

-- *** DAP Signs (Breakpoint Icons) ***
-- Set icons for breakpoints in the sign column
vim.fn.sign_define('DapBreakpoint', { text='🔴', texthl='DapBreakpoint', linehl='', numhl='' })
vim.fn.sign_define('DapBreakpointCondition', { text='🟡', texthl='DapBreakpoint', linehl='', numhl='' })
vim.fn.sign_define('DapBreakpointRejected', { text='⚫', texthl='DapBreakpoint', linehl='', numhl='' })
vim.fn.sign_define('DapLogPoint', { text='📝', texthl='DapLogPoint', linehl='', numhl='' })
vim.fn.sign_define('DapStopped', { text='▶️', texthl='DapStopped', linehl='debugPC', numhl='' })

-- *** DAP User Commands ***
-- Create user commands for common debugging operations

vim.api.nvim_create_user_command('DapContinue', function()
  require('dap').continue()
end, { desc = "DAP: Continue/Start debugging" })

vim.api.nvim_create_user_command('DapStepOver', function()
  require('dap').step_over()
end, { desc = "DAP: Step over" })

vim.api.nvim_create_user_command('DapStepInto', function()
  require('dap').step_into()
end, { desc = "DAP: Step into" })

vim.api.nvim_create_user_command('DapStepOut', function()
  require('dap').step_out()
end, { desc = "DAP: Step out" })

vim.api.nvim_create_user_command('DapToggleBreakpoint', function()
  require('dap').toggle_breakpoint()
end, { desc = "DAP: Toggle breakpoint" })

vim.api.nvim_create_user_command('DapSetConditionalBreakpoint', function()
  require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))
end, { desc = "DAP: Set conditional breakpoint" })

vim.api.nvim_create_user_command('DapSetLogPoint', function()
  require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
end, { desc = "DAP: Set log point" })

vim.api.nvim_create_user_command('DapTerminate', function()
  require('dap').terminate()
end, { desc = "DAP: Terminate debugging session" })

vim.api.nvim_create_user_command('DapToggleRepl', function()
  require('dap').repl.toggle()
end, { desc = "DAP: Toggle REPL" })

vim.api.nvim_create_user_command('DapRunLast', function()
  require('dap').run_last()
end, { desc = "DAP: Run last debug configuration" })

vim.api.nvim_create_user_command('DapUIToggle', function()
  require('dapui').toggle()
end, { desc = "DAP UI: Toggle debugging UI" })

vim.api.nvim_create_user_command('DapUIEval', function()
  require('dapui').eval()
end, { desc = "DAP UI: Evaluate expression under cursor" })

vim.api.nvim_create_user_command('DapUIFloat', function()
  require('dapui').float_element()
end, { desc = "DAP UI: Open floating window" })

-- *** VSCode Launch File Support ***
-- Load launch.json configurations if present
local load_vscode_launch = function()
  require('dap.ext.vscode').load_launchjs(nil, {
    codelldb = { 'rust', 'c', 'cpp' },
    lldb = { 'rust', 'c', 'cpp' }
  })
  print("DAP: Loaded launch.json configurations")
end

-- Create command to reload launch.json (in case it's edited while Neovim is open)
vim.api.nvim_create_user_command('DapLoadLaunchJSON', load_vscode_launch, {})

-- *** Rust-specific Commands ***
-- These integrate with Rustaceanvim

vim.api.nvim_create_user_command('RustDebuggables', function()
  vim.cmd.RustLsp('debuggables')
end, { desc = "Rust: Show debuggable targets" })

vim.api.nvim_create_user_command('RustRunnables', function()
  vim.cmd.RustLsp('runnables')
end, { desc = "Rust: Show runnable targets" })

vim.api.nvim_create_user_command('RustDebugLast', function()
  vim.cmd.RustLsp({ 'debuggables', bang = true })
end, { desc = "Rust: Debug last target" })
