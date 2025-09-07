--[[
=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||   KICKSTART.NVIM   ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||:Tutor              ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=====================================================================

What is Kickstart?

  Kickstart.nvim is *not* a distribution.

  Kickstart.nvim is a starting point for your own configuration.
    The goal is that you can read every line of code, top-to-bottom, understand
    what your configuration is doing, and modify it to suit your needs.

    Once you've done that, you can start exploring, configuring and tinkering to
    make Neovim your own! That might mean leaving Kickstart just the way it is for a while
    or immediately breaking it into modular pieces. It's up to you!

    If you don't know anything about Lua, I recommend taking some time to read through
    a guide. One possible example which will only take 10-15 minutes:
      - https://learnxinyminutes.com/docs/lua/

    After understanding a bit more about Lua, you can use `:help lua-guide` as a
    reference for how Neovim integrates Lua.
    - :help lua-guide
    - (or HTML version): https://neovim.io/doc/user/lua-guide.html

Kickstart Guide:

  TODO: The very first thing you should do is to run the command `:Tutor` in Neovim.

    If you don't know what this means, type the following:
      - <escape key>
      - :
      - Tutor
      - <enter key>

    (If you already know the Neovim basics, you can skip this step.)

  Once you've completed that, you can continue working through **AND READING** the rest
  of the kickstart init.lua.

  Next, run AND READ `:help`.
    This will open up a help window with some basic information
    about reading, navigating and searching the builtin help documentation.

    This should be the first place you go to look when you're stuck or confused
    with something. It's one of my favorite Neovim features.

    MOST IMPORTANTLY, we provide a keymap "<space>sh" to [s]earch the [h]elp documentation,
    which is very useful when you're not exactly sure of what you're looking for.

  I have left several `:help X` comments throughout the init.lua
    These are hints about where to find more information about the relevant settings,
    plugins or Neovim features used in Kickstart.

   NOTE: Look for lines like this

    Throughout the file. These are for you, the reader, to help you understand what is happening.
    Feel free to delete them once you know what you're doing, but they should serve as a guide
    for when you are first encountering a few different constructs in your Neovim config.

If you experience any errors while trying to install kickstart, run `:checkhealth` for more info.

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now! :)
--]]

---@diagnostic disable: undefined-global
vim.opt.termguicolors = true

vim.opt.guicursor = {
  "n-v-c:block",      -- normal, visual, command-line: block cursor
  "i-ci-ve:ver25",    -- insert, command-line insert, visual-exclude: vertical bar
  "r-cr:hor20",       -- replace, command-line replace: horizontal bar
  "o:hor50",          -- operator-pending: half-height bar
  "t:ver25",          -- terminal: vertical bar
}
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.api.nvim_create_autocmd("FileType", {
  pattern = "help",
  callback = function() vim.cmd("wincmd L") vim.cmd("set rnu") end,
})

vim.opt.breakindent = false
vim.opt.linebreak = false
vim.opt.showbreak = ""


-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = {tab = '» ', trail = '·', nbsp = '␣'}

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system {'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath}
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  checker = { enabled = false },
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  -- NOTE: Plugins can also be added by using a table,
  -- with the first argument being the link and the following

  {
    "kawre/leetcode.nvim",
    build = ":TSUpdate html", -- if you have `nvim-treesitter` installed
    dependencies = {
      "nvim-telescope/telescope.nvim",
      -- "ibhagwan/fzf-lua",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      lang='python',
    },
  },

  {
    'stevedylandev/ansi-nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd('colorscheme ansi')
      vim.opt.termguicolors = false
    end,
  },

  {'akinsho/toggleterm.nvim', version = "*", opts={direction="float"}},

  {
    'AlphaTechnolog/pywal.nvim',
    config = function ()
      require('pywal').setup()
    end
  },

  {
    "obsidian-nvim/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    -- event = {
    --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
    --   -- refer to `:h file-pattern` for more examples
    --   "BufReadPre path/to/my-vault/*.md",
    --   "BufNewFile path/to/my-vault/*.md",
    -- },
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",

      -- see above for full list of optional dependencies ☝️
    },
    ---@module 'obsidian'
    ---@type obsidian.config
    opts = {
      workspaces = {
        {
          name = "personal",
          path = "~/Creation",
        },
      },

      -- see below for full list of options 👇
    },
  },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { "<leader>f", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "<leader>y", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "R", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      -- { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      -- { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },

  {
    'norcalli/nvim-colorizer.lua',
    config = function ()
      require('colorizer').setup()
    end
  },

  {
    'rareitems/printer.nvim',
    config = function()
      require('printer').setup({
        keymap = "<leader>p" -- Plugin doesn't have any keymaps by default
      })
    end
  },
  -- NOTE: Plugins can specify dependencies.
  --
  -- The dependencies are proper plugin specifications as well - anything
  -- you do for a plugin at the top level, you can do for a dependency.
  --
  -- Use the `dependencies` key to specify the dependencies of a particular plugin

  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        -- defaults = {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        -- },
        -- pickers = {}
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[F]ind [H]elp' })
      vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[F]ind [K]eymaps' })
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[F]ind [F]iles' })
      vim.keymap.set('n', '<leader>fs', builtin.builtin, { desc = '[F]ind [S]elect Telescope' })
      vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = '[F]ind current [W]ord' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = '[F]ind by [G]rep' })
      vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '[F]ind [D]iagnostics' })
      vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = '[F]ind [R]esume' })
      vim.keymap.set('n', '<leader>.', builtin.oldfiles, { desc = '[F]ind Recent Files ("." for repeat)' })
      -- vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },

  {
    'smoka7/hop.nvim',
    version = "*",
    opts = {
      keys = 'etovxqpdygfblzhckisuran'
    }
  },

  {
    "OXY2DEV/helpview.nvim",
    lazy = false
  },

  {
    "nvzone/typr",
    cmd = "TyprStats",
    dependencies = "nvzone/volt",
    opts = {},
  },

  { 'vuciv/golf' },

  -- {
  --   "tris203/precognition.nvim",
  --   --event = "VeryLazy",
  --   opts = {
  --     -- startVisible = true,
  --     -- showBlankVirtLine = true,
  --     -- highlightColor = { link = "Comment" },
  --     -- hints = {
  --     --      Caret = { text = "^", prio = 2 },
  --     --      Dollar = { text = "$", prio = 1 },
  --     --      MatchingPair = { text = "%", prio = 5 },
  --     --      Zero = { text = "0", prio = 1 },
  --     --      w = { text = "w", prio = 10 },
  --     --      b = { text = "b", prio = 9 },
  --     --      e = { text = "e", prio = 8 },
  --     --      W = { text = "W", prio = 7 },
  --     --      B = { text = "B", prio = 6 },
  --     --      E = { text = "E", prio = 5 },
  --     -- },
  --     -- gutterHints = {
  --     --     G = { text = "G", prio = 10 },
  --     --     gg = { text = "gg", prio = 9 },
  --     --     PrevParagraph = { text = "{", prio = 8 },
  --     --     NextParagraph = { text = "}", prio = 8 },
  --     -- },
  --     -- disabled_fts = {
  --     --     "startify",
  --     -- },
  --   },
  -- },

  -- -- LSP Plugins
  -- {
  --   -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
  --   -- used for completion, annotations and signatures of Neovim apis
  --   'folke/lazydev.nvim',
  --   ft = 'lua',
  --   opts = {
  --     library = {
  --       -- Load luvit types when the `vim.uv` word is found
  --       { path = 'luvit-meta/library', words = { 'vim%.uv' } },
  --     },
  --   },
  -- },
  -- { 'Bilal2453/luvit-meta', lazy = true },
  -- {
  --   -- Main LSP Configuration
  --   'neovim/nvim-lspconfig',
  --   dependencies = {
  --     -- Automatically install LSPs and related tools to stdpath for Neovim
  --     { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
  --     'williamboman/mason-lspconfig.nvim',
  --     'WhoIsSethDaniel/mason-tool-installer.nvim',
  --
  --     -- Useful status updates for LSP.
  --     -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
  --     { 'j-hui/fidget.nvim', opts = {} },
  --
  --     -- Allows extra capabilities provided by nvim-cmp
  --     'hrsh7th/cmp-nvim-lsp',
  --   },
  --   config = function()
  --     -- Brief aside: **What is LSP?**
  --     --
  --     -- LSP is an initialism you've probably heard, but might not understand what it is.
  --     --
  --     -- LSP stands for Language Server Protocol. It's a protocol that helps editors
  --     -- and language tooling communicate in a standardized fashion.
  --     --
  --     -- In general, you have a "server" which is some tool built to understand a particular
  --     -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
  --     -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
  --     -- processes that communicate with some "client" - in this case, Neovim!
  --     --
  --     -- LSP provides Neovim with features like:
  --     --  - Go to definition
  --     --  - Find references
  --     --  - Autocompletion
  --     --  - Symbol Search
  --     --  - and more!
  --     --
  --     -- Thus, Language Servers are external tools that must be installed separately from
  --     -- Neovim. This is where `mason` and related plugins come into play.
  --     --
  --     -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
  --     -- and elegantly composed help section, `:help lsp-vs-treesitter`
  --
  --     --  This function gets run when an LSP attaches to a particular buffer.
  --     --    That is to say, every time a new file is opened that is associated with
  --     --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
  --     --    function will be executed to configure the current buffer
  --     vim.api.nvim_create_autocmd('LspAttach', {
  --       group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  --       callback = function(event)
  --         -- NOTE: Remember that Lua is a real programming language, and as such it is possible
  --         -- to define small helper and utility functions so you don't have to repeat yourself.
  --         --
  --         -- In this case, we create a function that lets us more easily define mappings specific
  --         -- for LSP related items. It sets the mode, buffer and description for us each time.
  --         local map = function(keys, func, desc, mode)
  --           mode = mode or 'n'
  --           vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
  --         end
  --
  --         -- Jump to the definition of the word under your cursor.
  --         --  This is where a variable was first declared, or where a function is defined, etc.
  --         --  To jump back, press <C-t>.
  --         map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  --
  --         -- Find references for the word under your cursor.
  --         map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  --
  --         -- Jump to the implementation of the word under your cursor.
  --         --  Useful when your language has ways of declaring types without an actual implementation.
  --         map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  --
  --         -- Jump to the type of the word under your cursor.
  --         --  Useful when you're not sure what type a variable is and you want to see
  --         --  the definition of its *type*, not where it was *defined*.
  --         map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
  --
  --         -- Fuzzy find all the symbols in your current document.
  --         --  Symbols are things like variables, functions, types, etc.
  --         map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  --
  --         -- Fuzzy find all the symbols in your current workspace.
  --         --  Similar to document symbols, except searches over your entire project.
  --         map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
  --
  --         -- Rename the variable under your cursor.
  --         --  Most Language Servers support renaming across files, etc.
  --         map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  --
  --         -- Execute a code action, usually your cursor needs to be on top of an error
  --         -- or a suggestion from your LSP for this to activate.
  --         map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
  --
  --         -- WARN: This is not Goto Definition, this is Goto Declaration.
  --         --  For example, in C this would take you to the header.
  --         map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  --
  --         -- The following two autocommands are used to highlight references of the
  --         -- word under your cursor when your cursor rests there for a little while.
  --         --    See `:help CursorHold` for information about when this is executed
  --         --
  --         -- When you move your cursor, the highlights will be cleared (the second autocommand).
  --         local client = vim.lsp.get_client_by_id(event.data.client_id)
  --         if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
  --           local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
  --           vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
  --             buffer = event.buf,
  --             group = highlight_augroup,
  --             callback = vim.lsp.buf.document_highlight,
  --           })
  --
  --           vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
  --             buffer = event.buf,
  --             group = highlight_augroup,
  --             callback = vim.lsp.buf.clear_references,
  --           })
  --
  --           vim.api.nvim_create_autocmd('LspDetach', {
  --             group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
  --             callback = function(event2)
  --               vim.lsp.buf.clear_references()
  --               vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
  --             end,
  --           })
  --         end
  --
  --         -- The following code creates a keymap to toggle inlay hints in your
  --         -- code, if the language server you are using supports them
  --         --
  --         -- This may be unwanted, since they displace some of your code
  --         if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
  --           map('<leader>th', function()
  --             vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
  --           end, '[T]oggle Inlay [H]ints')
  --         end
  --       end,
  --     })
  --
  --     -- Change diagnostic symbols in the sign column (gutter)
  --     -- if vim.g.have_nerd_font then
  --     --   local signs = { ERROR = '', WARN = '', INFO = '', HINT = '' }
  --     --   local diagnostic_signs = {}
  --     --   for type, icon in pairs(signs) do
  --     --     diagnostic_signs[vim.diagnostic.severity[type]] = icon
  --     --   end
  --     --   vim.diagnostic.config { signs = { text = diagnostic_signs } }
  --     -- end
  --
  --     -- LSP servers and clients are able to communicate to each other what features they support.
  --     --  By default, Neovim doesn't support everything that is in the LSP specification.
  --     --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
  --     --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
  --     local capabilities = vim.lsp.protocol.make_client_capabilities()
  --     capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
  --
  --     -- Enable the following language servers
  --     --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
  --     --
  --     --  Add any additional override configuration in the following tables. Available keys are:
  --     --  - cmd (table): Override the default command used to start the server
  --     --  - filetypes (table): Override the default list of associated filetypes for the server
  --     --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
  --     --  - settings (table): Override the default settings passed when initializing the server.
  --     --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
  --     local servers = {
  --       -- clangd = {},
  --       -- gopls = {},
  --       -- pyright = {},
  --       -- rust_analyzer = {},
  --       -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
  --       --
  --       -- Some languages (like typescript) have entire language plugins that can be useful:
  --       --    https://github.com/pmizio/typescript-tools.nvim
  --       --
  --       -- But for many setups, the LSP (`ts_ls`) will work just fine
  --       -- ts_ls = {},
  --       --
  --
  --       lua_ls = {
  --         -- cmd = { ... },
  --         -- filetypes = { ... },
  --         -- capabilities = {},
  --         settings = {
  --           Lua = {
  --             completion = {
  --               callSnippet = 'Replace',
  --             },
  --             -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
  --             -- diagnostics = { disable = { 'missing-fields' } },
  --           },
  --         },
  --       },
  --     }
  --
  --     -- Ensure the servers and tools above are installed
  --     --  To check the current status of installed tools and/or manually install
  --     --  other tools, you can run
  --     --    :Mason
  --     --
  --     --  You can press `g?` for help in this menu.
  --     require('mason').setup()
  --
  --     -- You can add other tools here that you want Mason to install
  --     -- for you, so that they are available from within Neovim.
  --     local ensure_installed = vim.tbl_keys(servers or {})
  --     vim.list_extend(ensure_installed, {
  --       'stylua', -- Used to format Lua code
  --     })
  --     require('mason-tool-installer').setup { ensure_installed = ensure_installed }
  --
  --     require('mason-lspconfig').setup {
  --       handlers = {
  --         function(server_name)
  --           local server = servers[server_name] or {}
  --           -- This handles overriding only values explicitly passed
  --           -- by the server configuration above. Useful when disabling
  --           -- certain features of an LSP (for example, turning off formatting for ts_ls)
  --           server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
  --           require('lspconfig')[server_name].setup(server)
  --         end,
  --       },
  --     }
  --   end,
  -- },
  --
  -- { -- Autoformat
  --   'stevearc/conform.nvim',
  --   event = { 'BufWritePre' },
  --   cmd = { 'ConformInfo' },
  --   keys = {
  --     {
  --       '<leader>f',
  --       function()
  --         require('conform').format { async = true, lsp_format = 'fallback' }
  --       end,
  --       mode = '',
  --       desc = '[F]ormat buffer',
  --     },
  --   },
  --   opts = {
  --     notify_on_error = false,
  --     format_on_save = function(bufnr)
  --       -- Disable "format_on_save lsp_fallback" for languages that don't
  --       -- have a well standardized coding style. You can add additional
  --       -- languages here or re-enable it for the disabled ones.
  --       local disable_filetypes = { c = true, cpp = true }
  --       local lsp_format_opt
  --       if disable_filetypes[vim.bo[bufnr].filetype] then
  --         lsp_format_opt = 'never'
  --       else
  --         lsp_format_opt = 'fallback'
  --       end
  --       return {
  --         timeout_ms = 500,
  --         lsp_format = lsp_format_opt,
  --       }
  --     end,
  --     formatters_by_ft = {
  --       lua = { 'stylua' },
  --       -- Conform can also run multiple formatters sequentially
  --       -- python = { "isort", "black" },
  --       --
  --       -- You can use 'stop_after_first' to run the first available formatter from the list
  --       -- javascript = { "prettierd", "prettier", stop_after_first = true },
  --     },
  --   },
  -- },
  --
  -- { -- Autocompletion
  --   'hrsh7th/nvim-cmp',
  --   event = 'InsertEnter',
  --   dependencies = {
  --     -- Snippet Engine & its associated nvim-cmp source
  --     {
  --       'L3MON4D3/LuaSnip',
  --       build = (function()
  --         -- Build Step is needed for regex support in snippets.
  --         -- This step is not supported in many windows environments.
  --         -- Remove the below condition to re-enable on windows.
  --         if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
  --           return
  --         end
  --         return 'make install_jsregexp'
  --       end)(),
  --       dependencies = {
  --         -- `friendly-snippets` contains a variety of premade snippets.
  --         --    See the README about individual language/framework/plugin snippets:
  --         --    https://github.com/rafamadriz/friendly-snippets
  --         -- {
  --         --   'rafamadriz/friendly-snippets',
  --         --   config = function()
  --         --     require('luasnip.loaders.from_vscode').lazy_load()
  --         --   end,
  --         -- },
  --       },
  --     },
  --     'saadparwaiz1/cmp_luasnip',
  --
  --     -- Adds other completion capabilities.
  --     --  nvim-cmp does not ship with all sources by default. They are split
  --     --  into multiple repos for maintenance purposes.
  --     'hrsh7th/cmp-nvim-lsp',
  --     'hrsh7th/cmp-path',
  --   },
  --   config = function()
  --     -- See `:help cmp`
  --     local cmp = require 'cmp'
  --     local luasnip = require 'luasnip'
  --     luasnip.config.setup {}
  --
  --     cmp.setup {
  --       snippet = {
  --         expand = function(args)
  --           luasnip.lsp_expand(args.body)
  --         end,
  --       },
  --       completion = { completeopt = 'menu,menuone,noinsert' },
  --
  --       -- For an understanding of why these mappings were
  --       -- chosen, you will need to read `:help ins-completion`
  --       --
  --       -- No, but seriously. Please read `:help ins-completion`, it is really good!
  --       mapping = cmp.mapping.preset.insert {
  --         -- Select the [n]ext item
  --         ['<C-n>'] = cmp.mapping.select_next_item(),
  --         -- Select the [p]revious item
  --         ['<C-p>'] = cmp.mapping.select_prev_item(),
  --
  --         -- Scroll the documentation window [b]ack / [f]orward
  --         ['<C-b>'] = cmp.mapping.scroll_docs(-4),
  --         ['<C-f>'] = cmp.mapping.scroll_docs(4),
  --
  --         -- Accept ([y]es) the completion.
  --         --  This will auto-import if your LSP supports it.
  --         --  This will expand snippets if the LSP sent a snippet.
  --         ['<C-y>'] = cmp.mapping.confirm { select = true },
  --
  --         -- If you prefer more traditional completion keymaps,
  --         -- you can uncomment the following lines
  --         --['<CR>'] = cmp.mapping.confirm { select = true },
  --         --['<Tab>'] = cmp.mapping.select_next_item(),
  --         --['<S-Tab>'] = cmp.mapping.select_prev_item(),
  --
  --         -- Manually trigger a completion from nvim-cmp.
  --         --  Generally you don't need this, because nvim-cmp will display
  --         --  completions whenever it has completion options available.
  --         ['<C-Space>'] = cmp.mapping.complete {},
  --
  --         -- Think of <c-l> as moving to the right of your snippet expansion.
  --         --  So if you have a snippet that's like:
  --         --  function $name($args)
  --         --    $body
  --         --  end
  --         --
  --         -- <c-l> will move you to the right of each of the expansion locations.
  --         -- <c-h> is similar, except moving you backwards.
  --         ['<C-l>'] = cmp.mapping(function()
  --           if luasnip.expand_or_locally_jumpable() then
  --             luasnip.expand_or_jump()
  --           end
  --         end, { 'i', 's' }),
  --         ['<C-h>'] = cmp.mapping(function()
  --           if luasnip.locally_jumpable(-1) then
  --             luasnip.jump(-1)
  --           end
  --         end, { 'i', 's' }),
  --
  --         -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
  --         --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
  --       },
  --       sources = {
  --         {
  --           name = 'lazydev',
  --           -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
  --           group_index = 0,
  --         },
  --         { name = 'nvim_lsp' },
  --         { name = 'luasnip' },
  --         { name = 'path' },
  --       },
  --     }
  --   end,
  -- },
  --

  {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup()
    end,
  },


  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
      'williamboman/mason.nvim',
      'neovim/nvim-lspconfig',
      {
        "SmiteshP/nvim-navbuddy",
        dependencies = {
          "SmiteshP/nvim-navic",
          "MunifTanjim/nui.nvim"
        },
        opts = { lsp = { auto_attach = true } }
      }
    },
    config = function()
      require('mason-lspconfig').setup({
        automatic_enable
      })
      local lspconfig = require 'lspconfig'
      local cmp_nvim_lsp = require 'cmp_nvim_lsp'
    end,
  },

  {
    'hrsh7th/nvim-cmp',
    dependencies = { 'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-buffer' },
    config = function()
      local cmp = require 'cmp'
      local icons = {
        Text = '󰉿',
        Method = '󰆧',
        Function = '󰊕',
        Constructor = '',
        Field = '󰜢',
        Variable = '󰀫',
        Class = '󰠱',
        Interface = '',
        Module = '',
        Property = '󰜢',
        Unit = '󰑭',
        Value = '󰎠',
        Enum = '',
        Keyword = '󰌋',
        Snippet = '',
        Color = '󰏘',
        File = '󰈙',
        Reference = '󰈇',
        Folder = '󰉋',
        EnumMember = '',
        Constant = '󰏿',
        Struct = '󰙅',
        Event = '',
        Operator = '󰆕',
        TypeParameter = '',
      }
      cmp.setup {
        mapping = cmp.mapping.preset.insert {
          ['<Tab>'] = cmp.mapping.confirm { select = true },
        },
        window = {
          -- completion = cmp.config.window.bordered(),
          -- documentation = cmp.config.window.bordered(),
        },
        sources = {
          { name = 'buffer' },
          { name = 'nvim_lsp' },
        },
        formatting = {
          format = function(_, vim_item)
            vim_item.kind = (icons[vim_item.kind or ''] or '') .. ' ' .. (vim_item.kind or 'Unknown')
            return vim_item
          end,
        },
      }
    end,
  },

  {
    'neovim/nvim-lspconfig',
    config = function()
      vim.diagnostic.config({
        virtual_text = {
          severity = { min = vim.diagnostic.severity.HINT },
          -- Note: 'only_current_line' is deprecated; consider alternative approaches
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN]  = "",
            [vim.diagnostic.severity.INFO]  = "",
            [vim.diagnostic.severity.HINT]  = "",
          },
          numhl = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticError",
            [vim.diagnostic.severity.WARN]  = "DiagnosticWarn",
            [vim.diagnostic.severity.INFO]  = "DiagnosticInfo",
            [vim.diagnostic.severity.HINT]  = "DiagnosticHint",
          },
        },
        severity_sort = true,
        update_in_insert = false,
        underline = {
          severity = {
            min = vim.diagnostic.severity.ERROR,
            max = vim.diagnostic.severity.ERROR,
          },
        },
      })
    end,
  },


  {
    "xiyaowong/transparent.nvim",
    config = function()
      require("transparent").setup({
        groups = {
          'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
          'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
          'Conditional', 'Repeat', 'Operator', 'Structure', 'NonText',
          'SignColumn', 'StatusLineNC', 'EndOfBuffer', 'BufferLine',
        },
        extra_groups = { 'BufferLineFill' },
        exclude_groups = { 'StatusLine', 'CursorLine', 'LineNr', 'LineNrAbove' },
        on_clear = function() end,
      })
    end
  },

  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true
    -- use opts = {} for passing setup options
    -- this is equivalent to setup({}) function
  },


  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'folke/tokyonight.nvim',
    init = function()
      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.

      -- You can configure highlights by doing something like:
      vim.cmd.hi 'Comment gui=none'
    end,
  },


{ "diegoulloao/neofusion.nvim", priority = 100000 , config = true},

  {"mg979/vim-visual-multi"},

  {
    'maxmx03/fluoromachine.nvim',
    lazy = false,
    priority = 100000,
    config = function ()
      local fm = require 'fluoromachine'

      fm.setup {
        glow = true,
        theme = 'fluoromachine',
        transparent = true,
      }

    end
  },

  {
    'github/copilot.vim',
    -- You can add configuration options here if needed
    -- config = function()
    --   -- Example: Change keybindings
    --   vim.g.copilot_no_tab_map = true
    --   vim.api.nvim_set_keymap('i', '<C-J>', 'copilot#Accept("<CR>")', { silent = true, expr = true })
    -- end,
  },

  {
    "gbprod/substitute.nvim",
    config = function()
      require("substitute").setup()
    end,
  },

  {
    "tiagovla/tokyodark.nvim",
    opts = {
      -- custom options here
    },
    config = function(_, opts)
      require("tokyodark").setup(opts) -- calling setup is optional
    end,
  },

  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  -- lazy.nvim
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      image = {
        -- our image configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    }
  },

  {
    "jiaoshijie/undotree",
    dependencies = "nvim-lua/plenary.nvim",
    config = true,
    keys = { -- load the plugin only when using it's keybinding:
      { "<leader>-", "<cmd>lua require('undotree').toggle()<cr>" },
    },
  },

  {
    "MysticalDevil/inlay-hints.nvim",
    event = "LspAttach",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      require("inlay-hints").setup()
    end
  },

  {
    "leath-dub/snipe.nvim",
    keys = {
      -- {"<leader><leader>", function () require("snipe").open_buffer_menu() end, desc = "Open Snipe buffer menu"}
    },
    opts = {
      ui = {
        position = "center",
      }
    }
  },

  { -- Collection of various small independent plugins/modules
    -- 'echasnovski/mini.nvim',
    dir = "/home/truegav/.local/share/nvim/lazy/mini.nvim/",
    lazy = false,
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      require('mini.move').setup()
      require('mini.bracketed').setup()
      require('mini.indentscope').setup()

      require('mini.splitjoin').setup()

      require('mini.files').setup()
      require('mini.tabline').setup()

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup({
        mappings = {
          add = '<leader>sa',
          delete = '<leader>sd',
        },
     })

      starter = require('mini.starter')

      starter.setup({
        evaluate_single = true,
        footer = "",
        header = io.popen("fortune -s | cowsay -r"):read("*a"),
        items = {
          starter.sections.recent_files(5, false, false),
          -- Use this if you set up 'mini.sessions'
        },
        content_hooks = {
          starter.gen_hook.adding_bullet(),
          starter.gen_hook.aligning('center', 'center'),
          starter.gen_hook.indexing('all', { 'Builtin actions' }),
          starter.gen_hook.padding(3, 2),
        },
      })

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  },

  -- The following comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- place them in the correct locations.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --
  --  Here are some example plugins that I've included in the Kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  -- require 'kickstart.plugins.debug',
  -- require 'kickstart.plugins.indent_line',
  -- require 'kickstart.plugins.lint',
  -- require 'kickstart.plugins.autopairs',
  -- require 'kickstart.plugins.neo-tree',
  -- require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  -- { import = 'custom.plugins' },
  --
  -- For additional information with loading, sourcing and examples see `:help lazy.nvim-🔌-plugin-spec`
  -- Or use telescope!
  -- In normal mode type `<space>sh` then write `lazy.nvim-plugin`
  -- you can continue same window with `<space>sr` which resumes last telescope search
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

-- REMAPS


vim.keymap.set("n", "<leader>o", '<C-w>w', {desc="[O]ther pane"})
vim.keymap.set("n", "<leader>O", '<C-^>', {desc="[O]ther buffer"})

vim.keymap.set("n", "<leader>u", ':HopWord<CR>', {desc="J[u]mp"})

vim.keymap.set("v", "<leader>h", ':HopWord<CR>', {desc="[H]op word"})
vim.keymap.set("v", "<leader>u", ':HopChar1<CR>', {desc="J[u]np"})
vim.keymap.set("v", "<leader>l", ':HopLineStart<CR>', {desc="Hop [L]ine"})

vim.keymap.set("n", "<C-u>", '<C-u>zz')
vim.keymap.set("n", "<C-d>", '<C-d>zz')

vim.keymap.set('n', '<Tab>', ':bnext<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<S-Tab>', ':bprev<CR>', { noremap = true, silent = true })

vim.keymap.set('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })

vim.keymap.set('v', '<leader>d', '"_d', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>d', '"_d', { noremap = true, silent = true })

vim.keymap.set('n', '<leader>w', ':w<CR>', { noremap = true, silent = true, desc="[W]rite file" })

vim.keymap.set('n', '<leader>t', function()
  if not require('mini.files').close() then
    require('mini.files').open()
  end
end, { noremap = true, silent = true })
vim.keymap.set('n', '<Esc>', ":lua require('mini.files').close()<CR>", { noremap = true, silent = true })

vim.keymap.set('n', '<leader>bd', ':bw!<CR>', { noremap = true, silent = true, desc="[B]uffer [D]elete" })

vim.keymap.set('n', '<leader>n', ':Navbuddy<CR>', { noremap = true, silent = true, desc="[N]avBuddy" })


vim.keymap.set("n", "<leader>r", function()
  vim.o.operatorfunc = "v:lua._replace_with_clipboard"
  return "g@"
end, { expr = true, noremap = true })

function _G._replace_with_clipboard(motion_type)
  vim.cmd('normal! "_d' .. motion_type)
  vim.cmd('normal! "+p')
end

-- vim.cmd('colorscheme mytheme') 

require("minicolors")

vim.o.guifont = "JetBrainsMono Nerd Font:h11" 

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.undofile = true
vim.o.undodir = vim.fn.expand('~/tmp/nvim/undo')
vim.o.undolevels = 1000
vim.o.undoreload = 10000



-- Default remove and paste operation
vim.keymap.set('n', '<leader>rr', '"_ddP', {noremap = true})   -- remove and paste

vim.keymap.set('n', '<leader>c', ':Telescope colorscheme<CR>', {noremap = true})   -- remove and paste

vim.keymap.set('n', '<leader>l', '<C-^>', {noremap = true})

-- Lua
vim.keymap.set("n", "s", require('substitute').operator, { noremap = true })
vim.keymap.set("n", "ss", require('substitute').line, { noremap = true })
vim.keymap.set("n", "S", require('substitute').eol, { noremap = true })
vim.keymap.set("x", "s", require('substitute').visual, { noremap = true })

vim.keymap.set('n', 'j', 'gj', { noremap = true, silent = true })
vim.keymap.set('n', 'k', 'gk', { noremap = true, silent = true })
vim.keymap.set('n', 'gS', ':lua MiniSplitjoin.toggle()<CR>', { noremap = true, silent = true })

vim.keymap.set('t', '<leader><leader>', '<C-\\><C-n>:ToggleTerm<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader><leader>', ':ToggleTerm<CR>', { noremap = true, silent = true })

vim.keymap.set("i", "jj", "<Esc>")

vim.keymap.set('n', '<leader>gv', '`[v`]<Esc>', { noremap = true, silent = true })


