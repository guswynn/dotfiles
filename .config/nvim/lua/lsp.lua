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

-- Configure LSP
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(client, bufnr)
  -- TODO(guswynn): what does this do?
  client.server_capabilities.semanticTokensProvider = nil

  -- LSP commands
  --
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  --
  -- ^ kickstart.nvim helping us
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  -- Codemods
  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  -- core
  nmap('<leader>gd', function() require('telescope.builtin').lsp_definitions({ jump_type = "vsplit" }) end,
    '[G]oto [D]efinition')
  nmap('<leader>gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('<leader>gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

  -- other
  nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap. Use `<C-w>q` to close.
  -- TODO(guswynn): improve this
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('<leader>gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')


  -- Format on :w
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
  vim.api.nvim_create_augroup("InlayPlusAutoFormat", {})
  vim.api.nvim_create_autocmd(
    "BufWritePre",
    {
      group = "InlayPlusAutoFormat",
      callback = function()
        vim.lsp.inlay_hint.enable()
        vim.lsp.buf.format()
      end,
    }
  )
end

-- Configuration for servers.
local servers = {
  -- TODO(guswynn): not using mason anymore, so this, python, and lua might need to installed manually
  clangd = {
    initialization_options = {
      fallback_flags = { '-std=c++23' },
    }
  },
  -- Only for neovim lol.
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },

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
-- Currently this is `rust-analyzer`, for which I prefer the rustup
-- version.
require('lspconfig')["rust_analyzer"].setup {
  capabilities = capabilities,
  on_attach = on_attach,
  settings = servers["rust_analyzer"],
  filetypes = (servers["rust_analyzer"] or {}).filetypes,
}

-- TODO(guswynn): setup other ones as well

-- Configure nvim-cmp. From kickstart.nvim.
-- `:help cmp`
-- TODO(guswynn): I might not need this.
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
