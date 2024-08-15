--
-- Set up nvim-cmp
--

vim.opt.completeopt = {'menu', 'menuone', 'noselect'}

local cmp = require('cmp')
local luasnip = require('luasnip')
local lspkind = require('lspkind')

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end
  },
  sources = {
    -- `group_index` groups several sources,
    -- and if any completion item for that index is found
    -- all sources with a lower index will be ignored.
    { name = 'copilot', group_index = 2 },
    { name = 'nvim_lsp', group_index = 2 },
    { name = 'buffer', group_index = 3 },
    { name = 'path', group_index = 2 },
    { name = 'nvim_lua', group_index = 2 },
    { name = 'luasnip', group_index = 2 },
  },
  window = {
    completion = {
      -- border = 'rounded',
    },
    documentation = {
      -- border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    },
  },
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol', -- show only symbol annotations
      maxwidth = 50, -- prevent the popup from showing more than provided num. of chars
                     -- can also be a function to dynamically calculate max width such as
                     -- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
      ellipsis_char = '...', -- when popup menu exceed maxwidth, truncate with this char.
      show_labelDetails = true, -- show labelDetails in menu. Disabled by default
      -- The function below will be called before any actual modifications from lspkind
      -- so that you can provide more controls on popup customization.
      -- See [#30](https://github.com/onsails/lspkind-nvim/pull/30)
      before = function (entry, vim_item)
        -- vim_item.kind = lspkind.presets.condicons[vim_item.kind] .. " " .. vim_item.kind
        vim_item.kind = vim_item.kind
        vim_item.menu = ({
          buffer = "[Buffer]",
          path = "[Path]",
          nvim_lsp = "[LSP]",
          nvim_lua = "[Lua]",
          copilot = " ",
        })[entry.source.name]
        return vim_item
      end
    })
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-x>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      --behavior = cmp.ConfirmBehavior.Replace,
      --select = false,
      select = true,
    }),
    ['<Down>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ['<Up>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-u>'] = cmp.mapping.scroll_docs(4),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { 'i', 's', }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i', 's', }),
  })
})
