
-- revert Y behavior to act like vim
vim.keymap.set('n', 'Y', 'yy', { noremap = true })

-- shared options
local tsb = require('telescope.builtin')

-- helper function to create keymaps
local function map(mode, keymap, action, opts, desc)
  opts.desc = desc
  vim.keymap.set(mode, keymap, action, opts)
end

-- shared options
local ns = { noremap = true, silent = true }
-- note: bufnr is the buffer number of the current buffer.
--       use this to set buffer-local mappings.
local bufnr = vim.api.nvim_get_current_buf()
local nsbuf = { noremap=true, silent=true, buffer=bufnr }

--
-- Jumping around
--

map('n', '<leader>j', ':HopWord<CR>', ns, "Jump to word")

--
-- Telescope
--

-- file pickers --
-- TODO: change this to fuzzy search among buffers, frequent files, find files
map('n', '<C-p>', tsb.find_files, ns, "Find files")
map('!', '<C-p>', tsb.find_files, ns, "Find files")

map('n', '<leader>p', ':FrequentFiles<CR>', ns, "Frequent files")
map('n', '<leader>ff', tsb.find_files, ns, "Find files")
map('n', '<leader>gf', tsb.git_files, ns, "Git files")
map('n', '<leader>gg', tsb.live_grep, ns, "Git grep")

-- vim pickers --
map('n', '<leader>/', tsb.current_buffer_fuzzy_find, ns, "Fuzzy find in buffer")
map('n', '<leader>b', tsb.buffers, ns, "Buffers")
map('n', '<leader>r', tsb.oldfiles, ns, "Recent files")

-- vim commands and keymaps
map('n', '<leader>hh', tsb.help_tags, ns, "Help tags")
map('n', '<leader>hk', tsb.keymaps, ns, "Keymaps")

-- git pickers --
map('n', '<leader>gl', tsb.git_commits, ns, "Git commits")
map('n', '<leader>gb', tsb.git_bcommits, ns, "Git history of buffer")

--
-- Sidebars
--

-- Set the keymap to toggle Neotree pane
map('n', '<C-n>', ':Neotree toggle<CR>', ns, "Toggle Neotree pane")

-- Set the keymap to toggle Vista sidebar
map('n', '<leader>vv', ':Vista!!<CR>', ns, "Toggle Vista sidebar")

-- Bookmarks
map('n', '<leader>mm', ':BookmarkToggle<CR>', ns, "Toggle bookmark")
map('n', '<leader>mg', ':BookmarkGoto<CR>', ns, "Go to bookmark")
map('n', '<leader>mc', ':BookmarksCommands<CR>', ns, "Bookmark commands")
map('n', '<leader>mt', ':BookmarksTree<CR>', ns, "Open bookmark tree")

--
-- LSP
--

map('n', '<leader>2', ':LspToggleVirtualText<CR>', ns, "Toggle virtual text")

map('n', '<leader>gd', ':LspGoToDefinition<CR>', ns, "Go to definition")
map('n', '<leader>gc', ':LspGoToDeclaration<CR>', ns, "Go to declaration")

map('n', '<leader>gt', ':LspGoToTypeDefinition<CR>', ns, "Go to type definition")
map('n', '<leader>gi', ':LspGoToImplementation<CR>', ns, "Go to implementation")

map('n', '<leader>ll', ':LspDocumentSymbols<CR>', ns, "Document symbols")
map('n', '<leader>lf', ':LspFindReferences<CR>', ns, "Find references")
map('n', '<leader>lw', ':LspSearchWorkspaceSymbols<CR>', ns, "Workspace symbols")

map('n', '<leader>ld', ':LspDiagnostics<CR>', ns, "Show diagnostics")
map('n', '<leader>l[', ':LspDiagGoToPrev<CR>', ns, "Previous diagnostic")
map('n', '<leader>l]', ':LspDiagGoToNext<CR>', ns, "Next diagnostic")

map('n', '<leader>la', ':LspActions<CR>', ns, "Code actions")
map('n', '<leader>lr', ':LspRenameSymbol<CR>', ns, "Rename symbol")
map('n', '<leader>ls', ':LspHover<CR>', ns, "Show documentation")

--
-- Terminal
--

-- open terminal
map("n", "<C-t>", vim.cmd.Term, ns, "Open terminal")
-- use 'jj' to exit insert mode and return to normal mode while in terminal
map("t", "jj", "<C-\\><C-n>", ns, "Exit insert mode in terminal")
-- use '<C-t>' to exit insert mode and close terminal split, this way C-t works like a toggle
map("t", "<C-t>", "<C-\\><C-n><cmd>q<CR>", ns, "Exit insert mode and close terminal split")

--
-- Copilot
--

-- toggle copilot chat
map('n', '<C-i>', ':CopilotChatToggle<CR>', ns, "Toggle Copilot Chat")
-- open copilot chat with buffer
map('n', '<leader>ccb', ':CopilotChatWithBuffer<CR>', ns, "Copilot Chat with buffer")
-- show help actions with telescope
map('n', '<leader>cch', ':CopilotChatHelp<CR>', ns, "Show help actions")
-- copilot chat fix
map('n', '<leader>ccf', ':CopilotChatFix<CR>', ns, "Copilot Chat fix")
map('v', '<leader>ccf', ':CopilotChatFix<CR>', ns, "Copilot Chat fix")
-- copilot chat explain
map('n', '<leader>cce', ':CopilotChatExplain<CR>', ns, "Copilot Chat explain")
map('v', '<leader>cce', ':CopilotChatExplain<CR>', ns, "Copilot Chat explain")
