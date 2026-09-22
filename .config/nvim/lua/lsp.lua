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
capabilities = require('blink.cmp').get_lsp_capabilities()

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

vim.lsp.config("ts_ls", {
    settings = {
        javascript = {
            inlayHints = {
                includeInlayEnumMemberValueHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayVariableTypeHints = true,
            },
        },
        typescript = {
            inlayHints = {
                includeInlayEnumMemberValueHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayVariableTypeHints = true,
            },
        },
    }
})
vim.lsp.enable({"ts_ls"})


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
