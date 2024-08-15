
-- disable language provider support I don't use.
-- plugins are either written in lua or vimscript.
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0

-- set home dir
local home = ""
if vim.fn.has("win32") == 1 then
  home = os.getenv("USERPROFILE")
else
  home = os.getenv("HOME")
end

-- Stabilize.nvim
require('stabilize').setup()

-- Gitsigns
require('gitsigns').setup()

-- Dressing UI improvements
require("dressing").setup()

-- Neo-tree
require('neo-tree').setup {
  filesystem = {
    filtered_items = {
	    visible = true,
	    show_hidden_count = true,
	    hide_dotfiles = false,
	    hide_gitignored = true,
	    hide_by_name = {
        '.git',
        '.DS_Store',
        'thumbs.db'
      },
      never_show = {},
    },
  }
}

-- Oil
require("oil").setup({
  columns = {
    "icon",
    -- "permissions",
    -- "size",
    -- "mtime",
  },
  -- Buffer-local options to use for oil buffers
  buf_options = {
    -- 'false' makes the buffer not appear in the buffer list
    buflisted = true,
    -- 'hide' means the buffer will be hidden instead of being unloaded
    bufhidden = "hide",
  },
  view_options = {
    show_hidden = true,
  },
})

-- Telescope
local telescope = require('telescope')
local actions = require("telescope.actions")

telescope.setup{
    defaults = {
        preview = true,
        mappings = {
            i = {
                ["<C-c>"] = actions.close,
                ["?"] = actions.which_key,
            },
            n = {
                ["<esc>"] = actions.close,
                ["?"] = actions.which_key,
            },
        },
    },
    extensions = {
      frecency = {
        show_scores = true,
        show_unindexed = true,
        ignore_patterns = { "*.git/*", "*/tmp/*", "*/node_modules/*"},
        --[[
        workspaces = {
          ["conf"]    = "/home/user/.config",
          ["data"]    = "/home/user/.local/share",
          ["project"] = "/home/user/projects",
          ["wiki"]    = "/home/user/wiki"
        }
        --]]
      }
    }
}

-- Preview of the search in Telescope
vim.opt.inccommand = 'nosplit'

-- frecency
require("telescope").load_extension("frecency")

-- Vista (right sidebar) settings
function NearestMethodOrFunction()
  return vim.b.vista_nearest_method_or_function or ''
end

vim.g.vista_default_executive = 'nvim_lsp'
vim.g.vista_icon_indent = { "╰─▸ ", "├─▸ " }

-- Copilot
require('copilot').setup({
  -- disable copilot.lua suggestions and panel modules, as they can interfere
  -- with completions properly appearing in copilot-cmp.
  suggestion = { enabled = false },
  panel = { enabled = false },
})
-- Copilot as nvim-cmp source
require('copilot_cmp').setup()
-- Copilot Chat
-- note: nvim-cmp integration must be required before CopilotChat.
require("CopilotChat.integrations.cmp").setup()
require("CopilotChat").setup {
  debug = false, -- Enable debugging
  window = {
    layout = 'vertical',   -- 'vertical', 'horizontal', 'float', 'replace'
    width = 0.3,           -- fractional width of parent, or absolute width in columns when > 1
    height = 0.5,          -- fractional height of parent, or absolute height in rows when > 1
    title = 'Copilot Chat'
  },
  -- disable default <tab> complete mapping because of nvim-cmp integration
  mappings = {
    complete = {
      insert = '',
    },
  },
}

-- Hop
require('hop').setup{
    keys = 'etovxqpdygfblzhckisuran'
}
