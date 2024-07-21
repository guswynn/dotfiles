-- Gus's Neovim setup. Requires at least 0.10
--
-- Originally derived from https://github.com/nvim-lua/kickstart.nvim, but
-- largely simplified.
--
-- lsp setup is in `lua/lsp.lua
-- treesitter setup is in `lua/treesitter.lua`
-- The rest of the config is simple enough to be contained in this file.


-- Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '


-- Colors
vim.o.termguicolors = true
vim.cmd.colorscheme 'wildcharm'
-- Add a bit more contrast, for some colorschemes this is nice.
-- vim.cmd.hi 'Normal guifg=White guibg=Black'

-- Set colors before ibl is setup.
-- TODO(guswynn): this could be done with a refresh function in ibl
vim.cmd.hi 'IblScope guifg=#767676'
vim.cmd.hi 'IblIndent guifg=#767676'


-- Plugins!

-- https://github.com/folke/lazy.nvim package manager
-- `:help lazy.nvim.txt`
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      -- TODO(guswynn): just use native?
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      { 'j-hui/fidget.nvim', opts = {} },
    },
  },
  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
    },
  },
  {
    -- lualine as statusline
    -- `:help lualine.txt`
    'nvim-lualine/lualine.nvim',
    opts = {
      options = {
        icons_enabled = false,
        theme = 'auto',
        component_separators = '|',
        section_separators = '',
      },
    },
  },
  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- `:help ibl`
    main = 'ibl',
    opts = {
      scope = {
        show_start = false,
      },
      indent = {
        char = "¦",
      }
    },
  },

  -- "gc" to comment visual regions/lines
  -- TODO(guswynn): consider removing this.
  { 'numToStr/Comment.nvim', opts = {} },
  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
  },
  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },

}, {})


-- General vim settings
-- Set highlight on search
vim.o.hlsearch = false
-- Make line numbers default
vim.wo.number = true
-- Show tabs and trailing spaces.
vim.o.list = true
-- Enable mouse mode
vim.o.mouse = 'a'
-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
-- vim.o.clipboard = 'unnamedplus'
-- Enable break indent
vim.o.breakindent = true
-- Save undo history
vim.o.undofile = true
-- Case-insensitive searching UNLESS \C or capital in search
-- vim.o.ignorecase = true
-- vim.o.smartcase = true
-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'
-- Decrease update time
vim.o.updatetime = 250
-- Long leader time
vim.o.timeoutlen = 2000
-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'
-- Force expandtab
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
-- TODO(guswynn): investigate these.
vim.o.number = true
vim.o.ls = 2
vim.o.ruler = true
vim.o.history = 500
vim.o.backspace = "indent,eol,start"
-- No swapfiles
vim.o.swapfile = false
-- Spelling
vim.opt.spelllang = 'en_us'
vim.opt.spell = true
vim.o.spellcapcheck = ""
-- Block cursor only
vim.opt.guicursor = 'a:blinkon0'
-- I don't like wrapping
vim.o.wrap = false

-- Non-lsp keymaps.

-- `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })


-- configure telescope and its keymaps
-- `:help telescope` and `:help telescope.setup()`
local actions = require 'telescope.actions'
require('telescope').setup {
  defaults = {
    colorscheme = "koehler",
    mappings = {
      i = {
        -- Split vertical
        ['<CR>'] = actions.select_vertical,
        ['<esc>'] = actions.close,
        ['<C-g>'] = actions.close,
        -- Movement with j and k
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
      },
    },
  },
}
-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
  -- Use the current buffer's path as the starting point for the git search
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.fn.getcwd()
  -- If the buffer is not associated with a file, return nil
  if current_file == '' then
    current_dir = cwd
  else
    -- Extract the directory from the current file's path
    current_dir = vim.fn.fnamemodify(current_file, ':h')
  end

  -- Find the Git root directory from the current file's path
  local git_root = vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')
      [1]
  if vim.v.shell_error ~= 0 then
    print 'Not a git repository. Searching on current working directory'
    return cwd
  end
  return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
  local git_root = find_git_root()
  if git_root then
    require('telescope.builtin').live_grep {
      search_dirs = { git_root },
    }
  end
end

vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})
-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

local function telescope_live_grep_open_files()
  require('telescope.builtin').live_grep {
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  }
end

-- Main telescope/fzf keymaps.
vim.keymap.set('n', '<leader>sg', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep on Git Root' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
-- lesser used ones
vim.keymap.set('n', '<leader>s/', telescope_live_grep_open_files, { desc = '[S]earch [/] in Open Files' })
vim.keymap.set('n', '<leader>ss', require('telescope.builtin').builtin, { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set('n', '<leader>SF', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sG', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })


-- Lsp
require('lsp')
require('treesitter')


-- Nice bottom line.
require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = 'auto',
    component_separators = '|',
    section_separators = '',
  },
  sections = {
    lualine_c = { { 'filename', path = 3 } },
  },
}
