return {
  -- ── Oil: file browser (edit filesystem like a buffer) ─────────────────────
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      default_file_explorer = true,
      columns = {
        "icon",
        "permissions",
        "size",
        "mtime",
      },
      view_options = {
        show_hidden = true,
        is_hidden_file = function(name, _)
          return name:match("^%.") ~= nil
        end,
        natural_order = true,
      },
      keymaps = {
        ["g?"]    = "actions.show_help",
        ["<CR>"]  = "actions.select",
        ["<C-v>"] = "actions.select_vsplit",
        ["<C-s>"] = "actions.select_split",
        ["<C-t>"] = "actions.select_tab",
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = "actions.close",
        ["-"]     = "actions.parent",
        ["_"]     = "actions.open_cwd",
        ["`"]     = "actions.cd",
        ["~"]     = "actions.tcd",
        ["gs"]    = "actions.change_sort",
        ["gx"]    = "actions.open_external",
        ["g."]    = "actions.toggle_hidden",
        ["g\\"]   = "actions.toggle_trash",
      },
      use_default_keymaps = false,
    },
    keys = {
      { "-",          "<cmd>Oil<cr>",              desc = "Oil: open parent dir" },
      { "<leader>e",  "<cmd>Oil .<cr>",            desc = "Oil: open cwd" },
      { "<leader>E",  function()
          require("oil").open(vim.fn.expand("%:p:h"))
        end, desc = "Oil: open file's dir" },
    },
  },

  -- ── Nvim-tree: sidebar tree view ──────────────────────────────────────────
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>n",  "<cmd>NvimTreeToggle<cr>",   desc = "Tree: toggle" },
      { "<leader>nf", "<cmd>NvimTreeFindFile<cr>", desc = "Tree: find current file" },
    },
    opts = {
      hijack_netrw = false,   -- let Oil handle netrw
      sync_root_with_cwd = true,
      respect_buf_cwd    = true,
      update_focused_file = { enable = true },
      view = { width = 35, side = "left" },
      renderer = {
        group_empty = true,
        highlight_git = true,
        icons = {
          git_placement = "after",
          glyphs = {
            git = {
              unstaged  = "✗", staged = "✓", unmerged = "",
              renamed   = "➜", untracked = "★", deleted = "", ignored = "◌",
            },
          },
        },
      },
      git = { enable = true, ignore = false },
      actions = {
        open_file = { quit_on_open = false },
      },
      filters = { dotfiles = false },
    },
  },

  -- ── Trouble: diagnostics / LSP list panel ──────────────────────────────────
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      modes = {
        diagnostics = { auto_close = true, auto_preview = true },
      },
    },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",              desc = "Trouble: workspace diagnostics" },
      { "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Trouble: buffer diagnostics" },
      { "<leader>xs", "<cmd>Trouble symbols toggle<cr>",                  desc = "Trouble: symbols" },
      { "<leader>xr", "<cmd>Trouble lsp toggle<cr>",                      desc = "Trouble: LSP references" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<cr>",                   desc = "Trouble: quickfix" },
      { "[t",         function() require("trouble").prev({ skip_groups = true, jump = true }) end, desc = "Trouble: prev" },
      { "]t",         function() require("trouble").next({ skip_groups = true, jump = true }) end, desc = "Trouble: next" },
    },
  },

  -- ── Mini.pairs: auto-pairs ─────────────────────────────────────────────────
  {
    "echasnovski/mini.pairs",
    event = "InsertEnter",
    opts  = {},
  },

  -- ── Mini.surround ─────────────────────────────────────────────────────────
  {
    "echasnovski/mini.surround",
    keys = { "sa", "sd", "sr", "sf", "sF", "sh", "sn" },
    opts = {
      mappings = {
        add            = "sa",
        delete         = "sd",
        replace        = "sr",
        find           = "sf",
        find_left      = "sF",
        highlight      = "sh",
        update_n_lines = "sn",
      },
    },
  },

  -- ── Todo-comments ─────────────────────────────────────────────────────────
  {
    "folke/todo-comments.nvim",
    event = "BufReadPost",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    keys = {
      { "]T",          function() require("todo-comments").jump_next() end, desc = "Next TODO" },
      { "[T",          function() require("todo-comments").jump_prev() end, desc = "Prev TODO" },
      { "<leader>ft",  "<cmd>TodoTelescope<cr>",                            desc = "TODOs (telescope)" },
      { "<leader>xT",  "<cmd>Trouble todo toggle<cr>",                      desc = "TODOs (trouble)" },
    },
  },
}
