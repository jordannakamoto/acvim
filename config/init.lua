-- ACVim - Neovim configuration for ModelessVim fork
-- This loads the modeless presets adapted for Neovim

-- Hide all startup messages FIRST (before any plugins load)
vim.opt.shortmess = "filnxtToOFWIcCsA"  -- Comprehensive message suppression
vim.opt.cmdheight = 0                   -- Hide command line when not in use

-- Disable deprecation warnings completely
vim.deprecate = function() end

-- Suppress which-key specific warnings
local original_notify = vim.notify
vim.notify = function(msg, level, opts)
  -- Skip which-key deprecation messages
  if type(msg) == "string" and (
    msg:match("which%-key") or
    msg:match("register.*deprecated") or
    msg:match("Use.*add.*instead")
  ) then
    return
  end
  original_notify(msg, level, opts)
end

-- Disable all builtin plugins that show messages (before lazy loads)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_logipat = 1
vim.g.loaded_matchit = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_spellfile_plugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1

-- Disable intro message and other startup noise
vim.opt.ruler = false
vim.opt.showcmd = false
vim.opt.laststatus = 0

-- Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Setup plugins
require("lazy").setup({
  -- Catppuccin colorscheme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        background = { -- :h background
          light = "latte",
          dark = "mocha",
        },
        transparent_background = false,
        show_end_of_buffer = false,
        term_colors = false,
        dim_inactive = {
          enabled = false,
          shade = "dark",
          percentage = 0.15,
        },
        no_italic = false,
        no_bold = false,
        no_underline = false,
        styles = {
          comments = { "italic" },
          conditionals = { "italic" },
          loops = {},
          functions = {},
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
        },
        color_overrides = {},
        custom_highlights = {},
        integrations = {
          nvim_tree = true,
          treesitter = true,
          -- Add other integrations as needed
        },
      })
      -- Set the colorscheme
      vim.cmd.colorscheme "catppuccin"
    end,
  },

  -- telescope.nvim - fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local actions = require("telescope.actions")

      require("telescope").setup({
        defaults = {
          file_ignore_patterns = { "node_modules", ".git/" },
          layout_config = {
            horizontal = {
              width = 0.95,
              height = 0.85,
              preview_width = 0.6,
            },
            vertical = {
              width = 0.9,
              height = 0.9,
              preview_height = 0.5,
            },
          },
          -- Ensure previewer is enabled by default
          previewer = true,
          file_previewer = require("telescope.previewers").vim_buffer_cat.new,
          grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
          qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,

          -- Custom keybindings for preview scrolling
          mappings = {
            i = {
              -- Slow preview scrolling with left/right arrows (1 line at a time)
              ["<Right>"] = function(prompt_bufnr)
                actions.preview_scrolling_down(prompt_bufnr)
              end,
              ["<Left>"] = function(prompt_bufnr)
                actions.preview_scrolling_up(prompt_bufnr)
              end,
              -- Faster scrolling with Ctrl+Left/Right (default speed)
              ["<C-Right>"] = function(prompt_bufnr)
                for _ = 1, 5 do
                  actions.preview_scrolling_down(prompt_bufnr)
                end
              end,
              ["<C-Left>"] = function(prompt_bufnr)
                for _ = 1, 5 do
                  actions.preview_scrolling_up(prompt_bufnr)
                end
              end,
            },
            n = {
              -- Slow preview scrolling with left/right arrows (1 line at a time)
              ["<Right>"] = function(prompt_bufnr)
                actions.preview_scrolling_down(prompt_bufnr)
              end,
              ["<Left>"] = function(prompt_bufnr)
                actions.preview_scrolling_up(prompt_bufnr)
              end,
              -- Faster scrolling with Ctrl+Left/Right (5 lines at a time)
              ["<C-Right>"] = function(prompt_bufnr)
                for _ = 1, 5 do
                  actions.preview_scrolling_down(prompt_bufnr)
                end
              end,
              ["<C-Left>"] = function(prompt_bufnr)
                for _ = 1, 5 do
                  actions.preview_scrolling_up(prompt_bufnr)
                end
              end,
            },
          },
        },
        pickers = {
          live_grep = {
            layout_strategy = "vertical",
            layout_config = {
              width = 0.9,
              height = 0.9,
              preview_height = 0.65,  -- Give more space to preview (65%)
              mirror = false,
            },
          },
          find_files = {
            layout_strategy = "vertical",
            layout_config = {
              width = 0.9,
              height = 0.9,
              preview_height = 0.65,  -- Give more space to preview (65%)
              mirror = false,
            },
          },
        },
      })
    end,
  },

  -- dressing.nvim - improve UI elements
  {
    "stevearc/dressing.nvim",
    lazy = false,
    config = function()
      require("dressing").setup({
        input = {
          enabled = true,
          default_prompt = "Input:",
          prompt_align = "left",
          insert_only = true,
          start_in_insert = true,
          anchor = "SW",
          border = "rounded",
          relative = "cursor",
          prefer_width = 40,
          width = nil,
          max_width = { 140, 0.8 },
          min_width = { 20, 0.2 },
          win_options = {
            winblend = 10,
            wrap = false,
          },
        },
        select = {
          enabled = true,
          backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },
          trim_prompt = true,
          telescope = {
            layout_strategy = "vertical",
            layout_config = {
              width = 0.8,
              height = 0.9,
              preview_height = 0.6,
            },
          },
        },
      })

      -- Enable line numbers in telescope preview windows
      vim.api.nvim_create_autocmd('User', {
        pattern = 'TelescopePreviewerLoaded',
        callback = function(args)
          local filetype = (args.data and args.data.filetype) or vim.bo.filetype
          if filetype ~= 'help' then
            vim.wo.number = true
          end
        end,
      })
    end,
  },

  -- which-key.nvim - show keybindings popup (DISABLED)
  {
    "folke/which-key.nvim",
    enabled = false,  -- Disable which-key entirely
    event = "VeryLazy",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300

      require("which-key").setup({
        plugins = {
          marks = true,
          registers = true,
          spelling = {
            enabled = true,
            suggestions = 20,
          },
          presets = {
            operators = true,
            motions = true,
            text_objects = true,
            windows = true,
            nav = true,
            z = true,
            g = true,
          },
        },
        operators = { gc = "Comments" },
        key_labels = {
          ["<space>"] = "SPC",
          ["<cr>"] = "RET",
          ["<tab>"] = "TAB",
        },
        motions = {
          count = true,
        },
        icons = {
          breadcrumb = "»",
          separator = "➜",
          group = "+",
        },
        popup_mappings = {
          scroll_down = "<c-d>",
          scroll_up = "<c-u>",
        },
        window = {
          border = "rounded",
          position = "bottom",
          margin = { 1, 0, 1, 0 },
          padding = { 1, 2, 1, 2 },
          winblend = 0,
          zindex = 1000,
        },
        layout = {
          height = { min = 4, max = 25 },
          width = { min = 20, max = 50 },
          spacing = 3,
          align = "left",
        },
        ignore_missing = true,
        hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "^:", "^ ", "^call ", "^lua " },
        show_help = true,
        show_keys = true,
        triggers = "auto",
        triggers_nowait = {
          "`",
          "'",
          "g`",
          "g'",
          '"',
          "<c-r>",
          "z=",
        },
        triggers_blacklist = {
          i = { "j", "k" },
          v = { "j", "k" },
        },
        disable = {
          buftypes = {},
          filetypes = {},
        },
      })

      -- Register ACVim specific keybinding groups (new format)
      require("which-key").add({
        -- Normal mode bindings
        { "<C-b>", desc = "File Explorer", mode = "n" },
        { "<C-s>", desc = "Save File", mode = "n" },
        { "<C-q>", desc = "Smart Quit", mode = "n" },
        { "<C-a>", desc = "Select All", mode = "n" },
        { "<C-c>", desc = "Copy", mode = "n" },
        { "<C-v>", desc = "Paste", mode = "n" },
        { "<C-z>", desc = "Undo", mode = "n" },
        { "<C-y>", desc = "Redo", mode = "n" },
        { "<C-p>", desc = "Command Palette", mode = "n" },
        { "<C-o>", desc = "Find Files", mode = "n" },
        { "<C-f>", desc = "Search Text in Files", mode = "n" },
        { "<C-h>", desc = "Find and Replace", mode = "n" },
        { "<C-d>", desc = "Duplicate Line", mode = "n" },
        { "<C-l>", desc = "Select Line", mode = "n" },
        { "/", desc = "Find in Current File", mode = "n" },

        -- Leader group
        { "<Leader>", group = "Leader", mode = "n" },
        { "<Leader>/", desc = "Telescope Find in File", mode = "n" },

        -- Insert mode bindings
        { "<C-s>", desc = "Save File", mode = "i" },
        { "<C-q>", desc = "Smart Quit", mode = "i" },
        { "<C-c>", desc = "Copy", mode = "i" },
        { "<C-v>", desc = "Paste", mode = "i" },
        { "<C-z>", desc = "Undo", mode = "i" },
        { "<C-y>", desc = "Redo", mode = "i" },
        { "<C-p>", desc = "Command Palette", mode = "i" },

        -- Visual mode bindings
        { "<C-c>", desc = "Copy Selection", mode = "v" },
        { "<C-v>", desc = "Paste", mode = "v" },
        { "<C-s>", desc = "Save File", mode = "v" },
        { "<C-q>", desc = "Smart Quit", mode = "v" },
      })
    end,
  },

  -- legendary.nvim - command palette and keymap management
  {
    "mrjones2014/legendary.nvim",
    version = "v2.13.9",
    -- since legendary.nvim handles all your keymaps/commands,
    -- its recommended to load legendary.nvim before other plugins
    priority = 10000,
    lazy = false,
    -- sqlite is only needed if you want to use frecency sorting
    dependencies = {
      "kkharji/sqlite.lua",
      -- which-key.nvim removed - no longer needed
    },
    config = function()
      -- Setup legendary with comprehensive ACVim keybindings
      local opts = { noremap = true, silent = false }
      local opts_silent = { noremap = true, silent = true }

      require("legendary").setup({
        include_builtin = false,
        include_legendary_cmds = true,
        select_prompt = "🅰 ACVim Command Palette  ",
        col_separator_char = '│',
        most_recent_item_at_top = true,
        icons = {
          keymap = "⌨",
          command = '⚡',
          fn = '󰡱 ',
          itemgroup = ' ',
        },

        keymaps = {
          --=================================================================
          -- |> File Operations                                           ===
          --=================================================================
          {
            "<C-b>",
            "<Cmd>NvimTreeToggle<CR>",
            description = "[ACVim/File] Toggle file explorer",
            mode = { "n", "i", "v" },
            opts = opts_silent,
          },
          {
            "<C-s>",
            "<Cmd>w<CR>",
            description = "[ACVim/File] Save current file",
            mode = { "n", "i", "v" },
            opts = opts_silent,
          },
          {
            "<C-q>",
            "<Cmd>call SmartQuit()<CR>",
            description = "[ACVim/File] Smart quit with save prompt",
            mode = { "n", "i", "v" },
            opts = opts_silent,
          },

          --=================================================================
          -- |> Selection Operations                                      ===
          --=================================================================
          {
            "<C-a>",
            "ggVG",
            description = "[ACVim/Selection] Select all text",
            mode = { "n" },
            opts = opts_silent,
          },
          {
            "<C-a>",
            "<Esc>ggVG",
            description = "[ACVim/Selection] Select all text (Insert mode)",
            mode = { "i" },
            opts = opts_silent,
          },

          --=================================================================
          -- |> Clipboard Operations                                      ===
          --=================================================================
          {
            "<C-c>",
            "<Cmd>call CopyToClipboard(getline('.'))<CR>",
            description = "[ACVim/Clipboard] Copy line to clipboard",
            mode = { "n" },
            opts = opts_silent,
          },
          {
            "<C-c>",
            "<C-o>:call CopyToClipboard(getline('.'))<CR>",
            description = "[ACVim/Clipboard] Copy line to clipboard (Insert)",
            mode = { "i" },
            opts = opts_silent,
          },
          {
            "<C-v>",
            "a<C-r>=PasteFromClipboard()<CR>",
            description = "[ACVim/Clipboard] Paste from clipboard",
            mode = { "n" },
            opts = opts_silent,
          },
          {
            "<C-v>",
            "<C-r>=PasteFromClipboard()<CR>",
            description = "[ACVim/Clipboard] Paste from clipboard (Insert)",
            mode = { "i" },
            opts = opts_silent,
          },

          --=================================================================
          -- |> Undo/Redo Operations                                     ===
          --=================================================================
          {
            "<C-z>",
            "<Cmd>undo<CR>",
            description = "[ACVim/Edit] Undo",
            mode = { "n" },
            opts = opts_silent,
          },
          {
            "<C-z>",
            "<C-o>:undo<CR>",
            description = "[ACVim/Edit] Undo (Insert mode)",
            mode = { "i" },
            opts = opts_silent,
          },
          {
            "<C-y>",
            "<Cmd>redo<CR>",
            description = "[ACVim/Edit] Redo",
            mode = { "n" },
            opts = opts_silent,
          },
          {
            "<C-y>",
            "<C-o>:redo<CR>",
            description = "[ACVim/Edit] Redo (Insert mode)",
            mode = { "i" },
            opts = opts_silent,
          },

          --=================================================================
          -- |> VS Code Style Text Selection                             ===
          --=================================================================
          {
            "<S-Left>",
            "v<Left>",
            description = "[ACVim/Selection] Start/extend selection left",
            mode = { "n" },
            opts = opts_silent,
          },
          {
            "<S-Right>",
            "v<Right>",
            description = "[ACVim/Selection] Start/extend selection right",
            mode = { "n" },
            opts = opts_silent,
          },
          {
            "<S-Up>",
            function()
              if vim.fn.line('.') == 1 then
                return "0V"
              else
                return "v<Up>"
              end
            end,
            description = "[ACVim/Selection] Start/extend selection up",
            mode = { "n" },
            opts = { noremap = true, silent = true, expr = true },
          },
          {
            "<S-Down>",
            function()
              if vim.fn.line('.') == vim.fn.line('$') then
                return "0V"
              else
                return "v<Down>"
              end
            end,
            description = "[ACVim/Selection] Start/extend selection down",
            mode = { "n" },
            opts = { noremap = true, silent = true, expr = true },
          },

          --=================================================================
          -- |> Word-wise Selection                                      ===
          --=================================================================
          {
            "<S-C-Left>",
            "vb",
            description = "[ACVim/Selection] Select word left",
            mode = { "n" },
            opts = opts_silent,
          },
          {
            "<S-C-Right>",
            "ve",
            description = "[ACVim/Selection] Select word right",
            mode = { "n" },
            opts = opts_silent,
          },

          --=================================================================
          -- |> Line Navigation                                          ===
          --=================================================================
          {
            "<Home>",
            "^",
            description = "[ACVim/Navigation] Go to beginning of line",
            mode = { "n" },
            opts = opts_silent,
          },
          {
            "<End>",
            "$",
            description = "[ACVim/Navigation] Go to end of line",
            mode = { "n" },
            opts = opts_silent,
          },
          {
            "<C-Home>",
            "gg",
            description = "[ACVim/Navigation] Go to beginning of file",
            mode = { "n" },
            opts = opts_silent,
          },
          {
            "<C-End>",
            "G",
            description = "[ACVim/Navigation] Go to end of file",
            mode = { "n" },
            opts = opts_silent,
          },

          --=================================================================
          -- |> Find and Replace in Current File                        ===
          --=================================================================
          {
            "<Leader>/",
            function()
              require("telescope.builtin").current_buffer_fuzzy_find({
                prompt_title = "Find in Current File",
                layout_strategy = "horizontal",
                layout_config = {
                  width = 0.8,
                  height = 0.6,
                  preview_width = 0.5,
                },
              })
            end,
            description = "[Find] Telescope search in current file",
            mode = { "n" },
            opts = opts_silent,
          },
          {
            "/",
            function()
              vim.cmd("set hlsearch")
              return "/"
            end,
            description = "[Find] Native vim search in current file",
            mode = { "n" },
            opts = { noremap = true, silent = false, expr = true },
          },
          {
            "<C-h>",
            function()
              local find = vim.fn.input("Find and Replace - Find: ")
              if find ~= "" then
                local replace = vim.fn.input("Replace with: ")
                vim.cmd(":%s/" .. vim.fn.escape(find, "/") .. "/" .. vim.fn.escape(replace, "/") .. "/gc")
              end
            end,
            description = "[Replace] Find and replace in current file",
            mode = { "n" },
            opts = opts_silent,
          },

          --=================================================================
          -- |> Common VS Code Behaviors                                 ===
          --=================================================================
          {
            "<C-d>",
            "<Cmd>copy .<CR>",
            description = "[ACVim/Edit] Duplicate line",
            mode = { "n" },
            opts = opts_silent,
          },
          {
            "<C-l>",
            "V",
            description = "[ACVim/Selection] Select current line",
            mode = { "n" },
            opts = opts_silent,
          },
          {
            "<M-Up>",
            "<Cmd>move .-2<CR>",
            description = "[ACVim/Edit] Move line up",
            mode = { "n" },
            opts = opts_silent,
          },
          {
            "<M-Down>",
            "<Cmd>move .+1<CR>",
            description = "[ACVim/Edit] Move line down",
            mode = { "n" },
            opts = opts_silent,
          },

          --=================================================================
          -- |> File Tree Navigation                                     ===
          --=================================================================
          {
            "<C-Left>",
            "<Cmd>NvimTreeFocus<CR>",
            description = "[ACVim/Navigation] Focus file tree",
            mode = { "n", "i" },
            opts = opts_silent,
          },
          {
            "<C-Right>",
            "<Cmd>wincmd l<CR>",
            description = "[ACVim/Navigation] Focus editor pane",
            mode = { "n", "i" },
            opts = opts_silent,
          },

          --=================================================================
          -- |> Delete Operations                                        ===
          --=================================================================
          {
            "<Del>",
            '"_x',
            description = "[ACVim/Edit] Delete character under cursor",
            mode = { "n" },
            opts = opts_silent,
          },
          {
            "<BS>",
            '"_X',
            description = "[ACVim/Edit] Delete character before cursor",
            mode = { "n" },
            opts = opts_silent,
          },

          --=================================================================
          -- |> File Switching & Text Search                            ===
          --=================================================================
          {
            "<C-_>",
            "<Cmd>Oil<CR>",
            description = "[File] Open oil.nvim file explorer (Ctrl+-)",
            mode = { "n", "i", "v" },
            opts = opts_silent,
          },
          {
            "<C-e>",
            "<Cmd>Oil<CR>",
            description = "[File] Open oil.nvim file explorer (Ctrl+E)",
            mode = { "n", "i", "v" },
            opts = opts_silent,
          },
          {
            "<C-o>",
            "<Cmd>Telescope find_files<CR>",
            description = "[File] Find and open files",
            mode = { "n" },
            opts = opts_silent,
          },
          {
            "<C-f>",
            function()
              require("telescope.builtin").live_grep({
                prompt_title = "Search Text in Files",
                layout_strategy = "vertical",
                layout_config = {
                  width = 0.9,
                  height = 0.9,
                  preview_height = 0.65,  -- Give more space to preview (65%)
                  mirror = false,
                },
                file_ignore_patterns = {
                  "node_modules/.*",
                  ".git/.*",
                  "%.DS_Store$"
                },
              })
            end,
            description = "[Search] Search text across all files with preview",
            mode = { "n", "i", "v" },
            opts = opts_silent,
          },
        },

        commands = {
          -- File Operations
          {
            ":Oil",
            description = "[File] Open oil.nvim file explorer",
          },
          {
            ":NvimTreeToggle",
            description = "[File] Toggle file explorer",
          },
          {
            ":NvimTreeFocus",
            description = "[File] Focus file explorer",
          },
          {
            ":w",
            description = "[File] Save current file",
          },
          {
            ":wa",
            description = "[File] Save all files",
          },
          {
            ":q",
            description = "[File] Quit current window",
          },
          {
            ":qa",
            description = "[File] Quit all windows",
          },

          -- File Switching Commands
          {
            ":Telescope find_files",
            description = "[File] Find files in project",
          },
          {
            ":Telescope oldfiles",
            description = "[File] Recent files",
          },
          {
            ":Telescope buffers",
            description = "[File] Switch between open buffers",
          },
          {
            ":Telescope git_files",
            description = "[File] Find git-tracked files",
          },
          {
            ":Telescope live_grep",
            description = "[File] Search text across files",
          },
          {
            ":Telescope current_buffer_fuzzy_find",
            description = "[File] Search within current file",
          },

          -- System Commands
          {
            ":Legendary",
            description = "[System] Open command palette",
          },
          {
            ":Mason",
            description = "[LSP] Install/manage language servers",
          },
          {
            ":colorscheme catppuccin",
            description = "[Theme] Set Catppuccin colorscheme",
          },
          {
            ":set number!",
            description = "[Display] Toggle line numbers",
          },
          {
            ":set wrap!",
            description = "[Display] Toggle word wrap",
          },
          {
            ":noh",
            description = "[Search] Clear search highlighting",
          },
        },

        functions = {
          -- Legendary functions
          {
            function()
              require("legendary").find()
            end,
            description = "[Legendary] Find all keymaps, commands, and functions",
          },
          {
            function()
              require("legendary").find({ filters = { require("legendary.filters").keymaps() } })
            end,
            description = "[Legendary] Find keymaps only",
          },
          {
            function()
              require("legendary").find({ filters = { require("legendary.filters").commands() } })
            end,
            description = "[Legendary] Find commands only",
          },

          -- File switching functions
          {
            function()
              require("telescope.builtin").find_files({
                prompt_title = "📁 Quick File Switcher",
                layout_strategy = "vertical",
                layout_config = { width = 0.8, height = 0.8 },
              })
            end,
            description = "[File] Quick file switcher (optimized)",
          },
          {
            function()
              require("telescope.builtin").buffers({
                prompt_title = "🔄 Buffer Switcher",
                show_all_buffers = true,
                sort_lastused = true,
                layout_strategy = "vertical",
              })
            end,
            description = "[File] Smart buffer switcher",
          },
          {
            function()
              require("telescope.builtin").oldfiles({
                prompt_title = "🕒 Recent Files",
                only_cwd = false,
                layout_strategy = "vertical",
              })
            end,
            description = "[File] Global recent files switcher",
          },
          {
            function()
              require("telescope.builtin").git_files({
                prompt_title = "🌿 Git Files",
                show_untracked = true,
                layout_strategy = "vertical",
              })
            end,
            description = "[File] Git-aware file switcher",
          },
          {
            function()
              -- Find files in the same directory as current file
              local current_dir = vim.fn.expand("%:p:h")
              require("telescope.builtin").find_files({
                prompt_title = "📂 Files in " .. vim.fn.fnamemodify(current_dir, ":t"),
                search_dirs = { current_dir },
                layout_strategy = "vertical",
              })
            end,
            description = "[File] Find files in current directory",
          },

          -- ACVim functions
          {
            function()
              vim.cmd("call SmartQuit()")
            end,
            description = "[ACVim] Smart quit with save prompt",
          },
          {
            function()
              vim.cmd("call CopyToClipboard(GetVisualSelection())")
            end,
            description = "[ACVim] Copy visual selection to clipboard",
          },

          -- LSP functions
          {
            description = "[LSP] Go to definition",
            function() vim.lsp.buf.definition() end,
          },
          {
            description = "[LSP] Show hover information",
            function() vim.lsp.buf.hover() end,
          },
          {
            description = "[LSP] Find references",
            function() vim.lsp.buf.references() end,
          },
          {
            description = "[LSP] Rename symbol",
            function() vim.lsp.buf.rename() end,
          },
          {
            description = "[LSP] Show code actions",
            function() vim.lsp.buf.code_action() end,
          },
          {
            description = "[LSP] Show diagnostics",
            function() vim.diagnostic.open_float() end,
          },
          {
            description = "[LSP] Go to previous diagnostic",
            function() vim.diagnostic.goto_prev() end,
          },
          {
            description = "[LSP] Go to next diagnostic",
            function() vim.diagnostic.goto_next() end,
          },
          {
            description = "[LSP] Format document",
            function() vim.lsp.buf.format({ async = true }) end,
          },
        },

        -- UI settings
        select_prompt = "🅰 ACVim Command Palette  ",

        -- Extensions (new format)
        extensions = {
          -- which_key disabled entirely
          lazy_nvim = {
            auto_register = true,
          },
        },

        -- Frecency settings (requires sqlite.lua)
        frecency = {
          db_root = vim.fn.stdpath("data") .. "/legendary/",
          max_timestamps = 10,
        },
      })

      -- Set up the command palette keybinding
      vim.keymap.set("n", "<C-p>", require("legendary").find, { desc = "Open Legendary command palette" })
      vim.keymap.set("i", "<C-p>", function()
        vim.cmd("stopinsert")
        require("legendary").find()
      end, { desc = "Open Legendary command palette" })
      vim.keymap.set("v", "<C-p>", function()
        vim.cmd("normal! <Esc>")
        require("legendary").find()
      end, { desc = "Open Legendary command palette" })

      -- Alternative keybinding like VS Code
      vim.keymap.set("n", "<C-S-p>", require("legendary").find, { desc = "Open command palette" })
      vim.keymap.set("i", "<C-S-p>", function()
        vim.cmd("stopinsert")
        require("legendary").find()
      end, { desc = "Open command palette" })
      vim.keymap.set("v", "<C-S-p>", function()
        vim.cmd("normal! <Esc>")
        require("legendary").find()
      end, { desc = "Open command palette" })
    end,
  },

  -- oil.nvim - file explorer as a buffer
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        default_file_explorer = false,
        columns = {
          "icon",
        },
        view_options = {
          show_hidden = true,
        },
        keymaps = {
          ["<CR>"] = "actions.select",
          ["-"] = "actions.parent",
          ["_"] = "actions.open_cwd",
          ["`"] = "actions.cd",
          ["~"] = "actions.tcd",
          ["g."] = "actions.toggle_hidden",
        },
      })

      -- Add direct keymaps after setup
      vim.keymap.set("n", "<C-e>", "<cmd>Oil<cr>", { desc = "Open oil file explorer" })
      vim.keymap.set("i", "<C-e>", "<cmd>Oil<cr>", { desc = "Open oil file explorer" })
      vim.keymap.set("v", "<C-e>", "<cmd>Oil<cr>", { desc = "Open oil file explorer" })
    end,
  },

  -- mason.nvim - LSP installer with UI
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      })
    end,
  },

  -- mason-lspconfig - Bridge between mason and lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        automatic_installation = false,
      })
    end,
  },

  -- nvim-lspconfig - LSP configuration
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Setup language servers
      -- TypeScript/JavaScript
      if vim.fn.executable("typescript-language-server") == 1 then
        lspconfig.ts_ls.setup({
          capabilities = capabilities,
        })
      end

      -- Python
      if vim.fn.executable("pyright") == 1 then
        lspconfig.pyright.setup({
          capabilities = capabilities,
        })
      end

      -- Lua
      if vim.fn.executable("lua-language-server") == 1 then
        lspconfig.lua_ls.setup({
          capabilities = capabilities,
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
              },
              telemetry = {
                enable = false,
              },
            },
          },
        })
      end

      -- Rust
      if vim.fn.executable("rust-analyzer") == 1 then
        lspconfig.rust_analyzer.setup({
          capabilities = capabilities,
        })
      end

      -- Go
      if vim.fn.executable("gopls") == 1 then
        lspconfig.gopls.setup({
          capabilities = capabilities,
        })
      end

      -- C/C++
      if vim.fn.executable("clangd") == 1 then
        lspconfig.clangd.setup({
          capabilities = capabilities,
        })
      end

      -- HTML
      if vim.fn.executable("vscode-html-language-server") == 1 then
        lspconfig.html.setup({
          capabilities = capabilities,
        })
      end

      -- CSS
      if vim.fn.executable("vscode-css-language-server") == 1 then
        lspconfig.cssls.setup({
          capabilities = capabilities,
        })
      end

      -- JSON
      if vim.fn.executable("vscode-json-language-server") == 1 then
        lspconfig.jsonls.setup({
          capabilities = capabilities,
        })
      end

      -- LSP keybindings
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts = { buffer = ev.buf, noremap = true, silent = true }

          -- Go to definition
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "<C-]>", vim.lsp.buf.definition, opts)

          -- Show hover information
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

          -- Find references
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

          -- Rename symbol
          vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)

          -- Code actions
          vim.keymap.set("n", "<C-S-a>", vim.lsp.buf.code_action, opts)

          -- Show diagnostics
          vim.keymap.set("n", "<C-S-m>", vim.diagnostic.open_float, opts)

          -- Navigate diagnostics
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

          -- Register LSP commands with Legendary dynamically
          if pcall(require, "legendary") then
            require("legendary").keymaps({
              {
                "gd",
                vim.lsp.buf.definition,
                description = "[LSP] Go to definition",
                mode = { "n" },
                opts = opts,
              },
              {
                "K",
                vim.lsp.buf.hover,
                description = "[LSP] Show hover information",
                mode = { "n" },
                opts = opts,
              },
              {
                "gr",
                vim.lsp.buf.references,
                description = "[LSP] Find references",
                mode = { "n" },
                opts = opts,
              },
              {
                "<F2>",
                vim.lsp.buf.rename,
                description = "[LSP] Rename symbol",
                mode = { "n" },
                opts = opts,
              },
              {
                "[d",
                vim.diagnostic.goto_prev,
                description = "[LSP] Previous diagnostic",
                mode = { "n" },
                opts = opts,
              },
              {
                "]d",
                vim.diagnostic.goto_next,
                description = "[LSP] Next diagnostic",
                mode = { "n" },
                opts = opts,
              },
            })
          end
        end,
      })

      -- Configure diagnostics display
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      -- Diagnostic signs
      local signs = { Error = "✘", Warn = "▲", Hint = "⚑", Info = "»" }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end
    end,
  },

  -- nvim-cmp - autocompletion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<Esc>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
      })
    end,
  },

  -- nvim-tree file explorer
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup({
        -- Disable netrw
        disable_netrw = true,
        hijack_netrw = true,

        -- View settings
        view = {
          width = 30,
          side = "left",
          preserve_window_proportions = false,
          number = false,
          relativenumber = false,
          signcolumn = "yes",
        },

        -- Enable mouse support
        hijack_cursor = false,
        select_prompts = true,

        -- Renderer settings
        renderer = {
          highlight_git = true,
          icons = {
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
            },
          },
        },

        -- Actions
        actions = {
          open_file = {
            quit_on_open = false,
            window_picker = {
              enable = false,  -- Don't use window picker
            },
            resize_window = true,  -- Allow window resizing
          },
        },

        -- Custom key mappings for nvim-tree
        on_attach = function(bufnr)
          local api = require('nvim-tree.api')

          local function opts(desc)
            return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
          end

          -- Default mappings
          api.config.mappings.default_on_attach(bufnr)

          -- Custom mappings
          vim.keymap.set('n', '<CR>', function()
            api.node.open.edit()
            -- Don't change focus - stay in tree
            vim.cmd('wincmd h')
          end, opts('Open file but stay in tree'))

          vim.keymap.set('n', '<Right>', function()
            -- Right arrow opens files/folders like Enter
            api.node.open.edit()
            -- Don't change focus - stay in tree
            vim.cmd('wincmd h')
          end, opts('Open file/folder but stay in tree'))

          vim.keymap.set('n', '<Left>', function()
            -- Left arrow closes/collapses directories
            api.node.navigate.parent_close()
          end, opts('Close directory'))

          vim.keymap.set('n', 'o', function()
            api.node.open.edit()
            -- Don't change focus - stay in tree
            vim.cmd('wincmd h')
          end, opts('Open file but stay in tree'))

          -- Tab key to focus editor pane
          vim.keymap.set('n', '<Tab>', function()
            -- Move focus to editor pane
            vim.cmd('wincmd l')
          end, opts('Focus editor pane'))



          -- Hide cursor in nvim-tree buffer by making it invisible
          vim.api.nvim_create_autocmd("BufEnter", {
            buffer = bufnr,
            callback = function()
              -- Set cursor to be completely invisible
              vim.opt_local.guicursor = "a:hor1-Cursor"
              -- Also try to hide it with highlight
              vim.cmd("highlight! link Cursor Normal")
            end,
          })

          -- Restore cursor when leaving nvim-tree
          vim.api.nvim_create_autocmd("BufLeave", {
            buffer = bufnr,
            callback = function()
              -- Restore default cursor globally
              vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"
              vim.cmd("highlight! Cursor guifg=bg guibg=fg")
            end,
          })

          -- Also restore cursor when switching windows from tree
          vim.api.nvim_create_autocmd("WinLeave", {
            buffer = bufnr,
            callback = function()
              -- Restore default cursor when leaving tree window
              vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"
              vim.cmd("highlight! Cursor guifg=bg guibg=fg")
            end,
          })

        end,
      })
    end,
  },
})

vim.cmd('runtime modeless.vimrc')

-- Override any ModelessVim keybindings that conflict with our setup
vim.keymap.set('n', '<C-o>', function()
  require("telescope.builtin").find_files({
    prompt_title = "Find Files",
    layout_strategy = "vertical",
    layout_config = {
      width = 0.9,
      height = 0.9,
      preview_height = 0.65,  -- Give more space to preview (65%)
      mirror = false,
    },
    file_ignore_patterns = {
      "node_modules/.*",
      ".git/.*",
      "%.DS_Store$"
    },
  })
end, { noremap = true, silent = true, desc = "Find Files" })

-- Additional ACVim customizations

-- Clear any remaining startup messages after everything loads
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Clear any messages that appeared during startup
    vim.cmd("silent! messages clear")
    -- Redraw to clean up the screen
    vim.cmd("redraw!")
  end,
})

-- Enable line numbers by default (like an IDE)
vim.opt.number = true
vim.opt.relativenumber = false

-- Disable Neovim's clipboard integration to avoid conflicts
-- We'll handle clipboard operations manually with pbcopy/pbpaste
vim.opt.clipboard = ''

-- Enable mouse support for nvim-tree interactions
vim.opt.mouse = 'a'

-- Enable window resizing with mouse
vim.opt.splitright = true
vim.opt.splitbelow = true


-- Make line number column extend the full height of the window like VS Code
vim.opt.signcolumn = 'yes'
vim.opt.numberwidth = 4  -- Minimum width for line number column

-- Show line numbers on empty lines (like VS Code)
-- We need to use a custom function to achieve this
local function setup_line_numbers()
  -- Create an autocmd to show line numbers on empty lines
  vim.api.nvim_create_autocmd({'BufEnter', 'BufWinEnter', 'WinEnter'}, {
    callback = function()
      -- Force line numbers to be shown
      vim.wo.number = true
      -- Remove the ~ characters from empty lines and show line numbers instead
      vim.wo.fillchars = 'eob: '
    end,
  })
end

setup_line_numbers()

-- Fix multi-line deletion in visual mode
-- Delete key in visual mode should delete selection
vim.keymap.set('v', '<Del>', 'd', { noremap = true })
vim.keymap.set('v', '<BS>', 'd', { noremap = true })

-- Backspace in visual mode should also delete selection
vim.keymap.set('v', '<Backspace>', 'd', { noremap = true })

-- Load custom vim overrides
vim.cmd('runtime acvim-custom.vim')

-- Override Ctrl+Z and Ctrl+Y mappings after everything else loads
-- This ensures our mappings take precedence
vim.cmd([[
  " Completely disable terminal suspension for Ctrl+Z
  " Use multiple methods to ensure it's disabled
  silent! !stty susp undef 2>/dev/null
  silent! !stty -ixon 2>/dev/null

  " Also disable it when entering any buffer
  autocmd BufEnter * silent! !stty susp undef 2>/dev/null
  autocmd BufEnter * silent! !stty -ixon 2>/dev/null

  " Map Ctrl+Z for undo (override ModelessVim mapping)
  " Use multiple variations to catch all cases
  nnoremap <c-z> :u<CR>
  inoremap <c-z> <c-o>:u<CR>
  nnoremap <C-Z> :u<CR>
  inoremap <C-Z> <c-o>:u<CR>
  vnoremap <c-z> <Esc>:u<CR>
  vnoremap <C-Z> <Esc>:u<CR>

  " Also map the literal Ctrl+Z character (ASCII 26)
  nnoremap <C-@> :u<CR>
  inoremap <C-@> <c-o>:u<CR>

  " Map Ctrl+Y for redo
  nnoremap <c-y> :redo<CR>
  inoremap <c-y> <c-o>:redo<CR>

  " Direct clipboard functions using pbcopy/pbpaste only
  function! CopyToClipboard(text_to_copy)
    call system('pbcopy', a:text_to_copy)
  endfunction

  function! PasteFromClipboard()
    return substitute(system('pbpaste'), '\n$', '', '')
  endfunction

  function! GetVisualSelection()
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
  endfunction

  " Map Cmd+C for copy to system clipboard (using escape sequences from Alacritty)
  nnoremap <Esc>[1;5C :call CopyToClipboard(getline('.'))<CR>a
  inoremap <Esc>[1;5C <c-o>:call CopyToClipboard(getline('.'))<CR>
  vnoremap <Esc>[1;5C :<c-u>call CopyToClipboard(GetVisualSelection())<CR>i

  " Map Cmd+V for paste from system clipboard
  nnoremap <Esc>[1;5V a<c-r>=PasteFromClipboard()<CR>
  inoremap <Esc>[1;5V <c-r>=PasteFromClipboard()<CR>
  vnoremap <Esc>[1;5V d<c-r>=PasteFromClipboard()<CR>

  " Map other Cmd keys
  nnoremap <Esc>[1;5Z :u<CR>
  inoremap <Esc>[1;5Z <c-o>:u<CR>
  nnoremap <Esc>[1;5Y :redo<CR>
  inoremap <Esc>[1;5Y <c-o>:redo<CR>
  nnoremap <Esc>[1;5A ggVG
  inoremap <Esc>[1;5A <Esc>ggVG
  vnoremap <Esc>[1;5A <Esc>ggVG
  nnoremap <Esc>[1;5Q :call SmartQuit()<CR>
  inoremap <Esc>[1;5Q <c-o>:call SmartQuit()<CR>
  vnoremap <Esc>[1;5Q <Esc>:call SmartQuit()<CR>

  " Keep original <D-> mappings as backup
  nnoremap <D-c> :call CopyToClipboard(getline('.'))<CR>a
  inoremap <D-c> <c-o>:call CopyToClipboard(getline('.'))<CR>
  vnoremap <D-c> :<c-u>call CopyToClipboard(GetVisualSelection())<CR>i
  nnoremap <D-v> a<c-r>=PasteFromClipboard()<CR>
  inoremap <D-v> <c-r>=PasteFromClipboard()<CR>
  vnoremap <D-v> c<c-r>=PasteFromClipboard()<CR><Esc>

  " Keep Ctrl+C and Ctrl+V as fallbacks
  nnoremap <c-c> :call CopyToClipboard(getline('.'))<CR>a
  inoremap <c-c> <c-o>:call CopyToClipboard(getline('.'))<CR>
  vnoremap <c-c> :<c-u>call CopyToClipboard(GetVisualSelection())<CR>i

  nnoremap <c-v> a<c-r>=PasteFromClipboard()<CR>
  inoremap <c-v> <c-r>=PasteFromClipboard()<CR>
  vnoremap <c-v> c<c-r>=PasteFromClipboard()<CR><Esc>

  " Map Ctrl+A for select all (stay in visual mode for selection)
  " In normal mode: select all text
  nnoremap <c-a> ggVG
  " In insert mode: escape to normal, select all (user can then copy/cut)
  inoremap <c-a> <Esc>ggVG
  " In visual mode: extend to select all
  vnoremap <c-a> <Esc>ggVG

  " Ctrl+S: Save file
  nnoremap <c-s> :w<CR>a
  inoremap <c-s> <c-o>:w<CR>
  vnoremap <c-s> <Esc>:w<CR>

  " Smart selection functions for edge cases
  function! SmartShiftUp()
    if line('.') == 1
      " At top line, always select the whole line regardless of cursor position
      return "\<Esc>0V"
    else
      " Normal up selection
      return "\<Esc>v\<Up>"
    endif
  endfunction

  function! SmartShiftDown()
    if line('.') == line('$')
      " At bottom line, always select the whole line regardless of cursor position
      return "\<Esc>0V"
    else
      " Normal down selection
      return "\<Esc>v\<Down>"
    endif
  endfunction

  " VS Code-style Shift+Arrow key selection
  " Start selection with Shift+Arrow keys from insert mode
  inoremap <S-Left> <Esc>v<Left>
  inoremap <S-Right> <Esc>v<Right>
  inoremap <expr> <S-Up> SmartShiftUp()
  inoremap <expr> <S-Down> SmartShiftDown()

  " Extend selection with Shift+Arrow keys in visual mode
  vnoremap <S-Left> <Left>
  vnoremap <S-Right> <Right>
  vnoremap <S-Up> <Up>
  vnoremap <S-Down> <Down>

  " Start selection from normal mode with smart edge handling
  nnoremap <S-Left> v<Left>
  nnoremap <S-Right> v<Right>
  nnoremap <expr> <S-Up> line('.') == 1 ? '0V' : 'v<Up>'
  nnoremap <expr> <S-Down> line('.') == line('$') ? '0V' : 'v<Down>'

  " Word-wise selection with Shift+Ctrl+Arrow (like VS Code)
  inoremap <S-C-Left> <Esc>vb
  inoremap <S-C-Right> <Esc>ve
  vnoremap <S-C-Left> b
  vnoremap <S-C-Right> e
  nnoremap <S-C-Left> vb
  nnoremap <S-C-Right> ve

  " Line selection with Shift+Home/End
  inoremap <S-Home> <Esc>v^
  inoremap <S-End> <Esc>v$
  vnoremap <S-Home> ^
  vnoremap <S-End> $
  nnoremap <S-Home> v^
  nnoremap <S-End> v$

  " Arrow keys without Shift should cancel selection and move cursor
  vnoremap <Left> <Esc><Left>
  vnoremap <Right> <Esc><Right>
  vnoremap <Up> <Esc><Up>
  vnoremap <Down> <Esc><Down>

  " Typing to replace selected text - use a more targeted approach
  " Map common characters that users type to replace selections
  " Letters and numbers
  vnoremap a ca
  vnoremap b cb
  vnoremap c cc
  vnoremap d cd
  vnoremap e ce
  vnoremap f cf
  vnoremap g cg
  vnoremap h ch
  vnoremap i ci
  vnoremap j cj
  vnoremap k ck
  vnoremap l cl
  vnoremap m cm
  vnoremap n cn
  vnoremap o co
  vnoremap p cp
  vnoremap q cq
  vnoremap r cr
  vnoremap s cs
  vnoremap t ct
  vnoremap u cu
  vnoremap v cv
  vnoremap w cw
  vnoremap x cx
  vnoremap y cy
  vnoremap z cz
  vnoremap A cA
  vnoremap B cB
  vnoremap C cC
  vnoremap D cD
  vnoremap E cE
  vnoremap F cF
  vnoremap G cG
  vnoremap H cH
  vnoremap I cI
  vnoremap J cJ
  vnoremap K cK
  vnoremap L cL
  vnoremap M cM
  vnoremap N cN
  vnoremap O cO
  vnoremap P cP
  vnoremap Q cQ
  vnoremap R cR
  vnoremap S cS
  vnoremap T cT
  vnoremap U cU
  vnoremap V cV
  vnoremap W cW
  vnoremap X cX
  vnoremap Y cY
  vnoremap Z cZ

  " Numbers
  vnoremap 0 c0
  vnoremap 1 c1
  vnoremap 2 c2
  vnoremap 3 c3
  vnoremap 4 c4
  vnoremap 5 c5
  vnoremap 6 c6
  vnoremap 7 c7
  vnoremap 8 c8
  vnoremap 9 c9

  " Common symbols
  vnoremap ! c!
  vnoremap @ c@
  vnoremap # c#
  vnoremap $ c$
  vnoremap % c%
  vnoremap ^ c^
  vnoremap & c&
  vnoremap * c*
  vnoremap ( c(
  vnoremap ) c)
  vnoremap - c-
  vnoremap _ c_
  vnoremap = c=
  vnoremap + c+
  vnoremap [ c[
  vnoremap ] c]
  vnoremap { c{
  vnoremap } c}
  vnoremap \| c\|
  vnoremap \\ c\\
  vnoremap ; c;
  vnoremap : c:
  vnoremap , c,
  vnoremap . c.
  vnoremap < c<
  vnoremap > c>
  vnoremap / c/
  vnoremap ? c?
  vnoremap ` c`
  vnoremap ~ c~
  vnoremap <Space> c<Space>

  " Handle special characters that need escaping
  vnoremap " c"
  vnoremap ' c'

  " Also handle Enter and Tab for replacement
  vnoremap <CR> c<CR>
  vnoremap <Tab> c<Tab>

  " Backspace and Delete should delete selected text and enter insert mode
  vnoremap <BS> c
  vnoremap <Del> c

  " Common VS Code behaviors
  " Ctrl+D: Duplicate line
  nnoremap <c-d> :copy .<CR>a
  inoremap <c-d> <c-o>:copy .<CR>

  " Ctrl+L: Select current line
  nnoremap <c-l> V
  inoremap <c-l> <Esc>V

  " Ctrl+/: Toggle comment (simple version)
  nnoremap <c-/> I// <Esc>a
  inoremap <c-/> <c-o>I// <Esc>a

  " Alt+Up/Down: Move line up/down
  nnoremap <M-Up> :move .-2<CR>a
  nnoremap <M-Down> :move .+1<CR>a
  inoremap <M-Up> <c-o>:move .-2<CR>
  inoremap <M-Down> <c-o>:move .+1<CR>

  " Ctrl+Enter: Insert new line below
  nnoremap <c-CR> o
  inoremap <c-CR> <c-o>o

  " Ctrl+Shift+Enter: Insert new line above
  nnoremap <c-s-CR> O
  inoremap <c-s-CR> <c-o>O

  " Home/End keys for line navigation
  inoremap <Home> <c-o>^
  inoremap <End> <c-o>$
  nnoremap <Home> ^
  nnoremap <End> $

  " Ctrl+Home/End: Go to beginning/end of file
  inoremap <c-Home> <c-o>gg
  inoremap <c-End> <c-o>G
  nnoremap <c-Home> gg
  nnoremap <c-End> G

  " File Explorer (nvim-tree) keybindings
  " Ctrl+B: Toggle file explorer (like VS Code sidebar)
  nnoremap <c-b> :NvimTreeToggle<CR>a
  inoremap <c-b> <c-o>:NvimTreeToggle<CR>
  vnoremap <c-b> <Esc>:NvimTreeToggle<CR>

  " Ctrl+Shift+E: Focus file explorer
  nnoremap <c-s-e> :NvimTreeFocus<CR>
  inoremap <c-s-e> <c-o>:NvimTreeFocus<CR>
  vnoremap <c-s-e> <Esc>:NvimTreeFocus<CR>

  " Pane navigation with Ctrl+Arrow keys
  " Ctrl+Left: Focus nvim-tree (if open)
  nnoremap <c-Left> :NvimTreeFocus<CR>
  inoremap <c-Left> <c-o>:NvimTreeFocus<CR>

  " Ctrl+Right: Focus editor pane (from tree)
  nnoremap <c-Right> :wincmd l<CR>
  inoremap <c-Right> <c-o>:wincmd l<CR>

  " Tab/Shift+Tab for cycling through search matches while typing (search mode only)
  " Use a function to check if we're in search mode
  function! SmartTab()
    if getcmdtype() == '/' || getcmdtype() == '?'
      return "\<C-G>"
    else
      return "\<Tab>"
    endif
  endfunction

  function! SmartShiftTab()
    if getcmdtype() == '/' || getcmdtype() == '?'
      return "\<C-T>"
    else
      return "\<S-Tab>"
    endif
  endfunction

  cnoremap <expr> <Tab> SmartTab()
  cnoremap <expr> <S-Tab> SmartShiftTab()



  " Smart Ctrl+Q: Check for unsaved changes and prompt to save
  function! SmartQuit()
    " Close nvim-tree if it's open
    if exists(':NvimTreeClose')
      NvimTreeClose
    endif

    " Check for any modified buffers
    let modified_buffers = []
    for bufnr in range(1, bufnr('$'))
      if bufexists(bufnr) && getbufvar(bufnr, '&modified')
        let bufname = bufname(bufnr)
        if bufname == ''
          let bufname = '[No Name]'
        endif
        call add(modified_buffers, bufname)
      endif
    endfor

    if len(modified_buffers) > 0
      let files_list = join(modified_buffers, "\n")
      let choice = confirm("Save changes to:\n" . files_list . "\n\nSave changes before quitting?", "&Yes\n&No\n&Cancel", 1)

      if choice == 1
        " Save all modified buffers and quit
        try
          wall  " Write all modified buffers
          qall! " Quit all
        catch
          " Handle files without names
          for bufnr in range(1, bufnr('$'))
            if bufexists(bufnr) && getbufvar(bufnr, '&modified')
              execute 'buffer' bufnr
              if expand('%:t') == ''
                let filename = input('Save buffer as: ')
                if filename != ''
                  execute 'write ' . filename
                else
                  " If no filename given, stay in editor
                  return
                endif
              else
                write
              endif
            endif
          endfor
          qall!
        endtry
      elseif choice == 2
        " Quit without saving
        qall!
      endif
      " If choice == 3 (Cancel), do nothing
    else
      " No changes, just quit everything
      qall!
    endif
  endfunction

  " Map Ctrl+Q to smart quit function
  nnoremap <c-q> :call SmartQuit()<CR>
  inoremap <c-q> <c-o>:call SmartQuit()<CR>
  vnoremap <c-q> <Esc>:call SmartQuit()<CR>

  " Restore suspension on exit
  autocmd VimLeave * silent! !stty susp ^Z 2>/dev/null
]])
