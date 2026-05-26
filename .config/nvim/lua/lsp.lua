-- Configure my lsp's.
-- `:help lspconfig` to start, probably.


-- Enable inlay hints and make them quite dark (as dark as comments).
vim.lsp.inlay_hint.enable()
vim.cmd.hi 'LspInlayHint guifg=#767676'


-- Work around this issue: <https://github.com/neovim/neovim/issues/26511>
-- by constantly re-enabling it for newly opened buffers. We also
-- call this on save (while formatting).
--
-- TODO(guswynn): consider making this slightly less expensive, by
-- calling it only when needed?
vim.lsp.handlers['experimental/serverStatus'] = function(_, result)
  if not result.quiescent then
    return
  end
  vim.lsp.inlay_hint.enable()
end

-- Diagnostics hold
vim.api.nvim_create_augroup("lsp_diagnostics_hold", { clear = true })
vim.api.nvim_create_autocmd({ "CursorHold" }, {
  group = "lsp_diagnostics_hold",
  pattern = "*",
  callback = function()
    vim.diagnostic.open_float({
      scope = "line",
      focusable = false,
      close_events = {
        "CursorMoved",
        "CursorMovedI",
        "BufHidden",
        "InsertCharPre",
        "WinLeave",
      },
    })
  end
})


-- Configuration for servers.
local servers = {
  -- ra should be installed with rustup
  rust_analyzer = {
    ["rust-analyzer"] = {
      rust = {
        analyzerTargetDir = "target-ra",
      },
      inlayHints = {
        enable = true,
        typeHints = { enable = true },
        parameterHints = { enable = false },
      },
    }
  },
}

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Setup and configure servers.
on_attach = require('on_attach')

-- For `rust-analyzer`, for which I prefer the rustup
-- version.
vim.lsp.config("rust_analyzer", {
  capabilities = capabilities,
  on_attach = on_attach.on_attach,
  settings = servers["rust_analyzer"],
  filetypes = (servers["rust_analyzer"] or {}).filetypes,
})
vim.lsp.enable({"rust_analyzer"})

-- Basic python support
vim.lsp.config("basedpyright", {
  capabilities = capabilities,
  on_attach = on_attach.on_attach,
})
vim.lsp.enable({"basedpyright"})

vim.lsp.config("ruff", {
  capabilities = capabilities,
  on_attach = on_attach.on_attach,
})
vim.lsp.enable({"ruff"})

-- Basic cpp support
vim.lsp.config("clangd", {
  capabilities = capabilities,
  on_attach = on_attach.on_attach,
})
vim.lsp.enable({"clangd"})

-- For Scala, we used https://github.com/scalameta/nvim-metals,
-- configured without lspconfig


-- Configure nvim-cmp. From kickstart.nvim.
-- `:help cmp`
-- TODO(guswynn): I probably don't need this
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  completion = {
    completeopt = 'menu,menuone,noinsert',
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}
