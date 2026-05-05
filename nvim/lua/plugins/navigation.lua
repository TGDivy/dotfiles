-- ── plugins/navigation.lua ───────────────────────────────────────────────────
return {

  -- ── telescope ──────────────────────────────────────────────────────────────
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local telescope = require("telescope")
      local actions   = require("telescope.actions")

      telescope.setup({
        defaults = {
          prompt_prefix   = " ",
          selection_caret = " ",
          path_display    = { "truncate" },
          sorting_strategy = "ascending",
          layout_config = {
            horizontal = { prompt_position = "top", preview_width = 0.55 },
          },
          mappings = {
            i = {
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<Esc>"] = actions.close,
            },
          },
          file_ignore_patterns = {
            "%.git/", "node_modules/", "%.cache/", "build/", "%.o$", "%.a$",
          },
        },
        pickers = {
          find_files = { hidden = true },
        },
      })

      telescope.load_extension("fzf")
    end,
  },

  -- ── harpoon 2 — global file marks across projects ─────────────────────────
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup({
        settings = {
          save_on_toggle = true,
          sync_on_ui_close = true,
          -- Store marks in data dir keyed by project root (git root or cwd)
          key = function()
            return vim.loop.cwd()
          end,
        },
      })

      local map = function(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, { noremap = true, silent = true, desc = desc })
      end

      -- Add / menu
      map("<leader>ha", function() harpoon:list():add() end,    "Harpoon add")
      map("<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, "Harpoon menu")

      -- Jump to mark 1-5
      for i = 1, 5 do
        map("<leader>" .. i, function() harpoon:list():select(i) end, "Harpoon → " .. i)
      end

      -- Navigate prev/next
      map("<leader>hn", function() harpoon:list():next() end, "Harpoon next")
      map("<leader>hp", function() harpoon:list():prev() end, "Harpoon prev")

      -- Telescope integration — fuzzy across all marks
      map("<leader>hf", function()
        local conf = require("telescope.config").values
        local mark_list = {}
        for _, item in ipairs(harpoon:list().items) do
          table.insert(mark_list, item.value)
        end
        require("telescope.pickers").new({}, {
          prompt_title  = "Harpoon",
          finder = require("telescope.finders").new_table({ results = mark_list }),
          previewer = conf.file_previewer({}),
          sorter    = conf.generic_sorter({}),
        }):find()
      end, "Harpoon fuzzy")
    end,
  },

  -- ── oil — file explorer as editable buffer ─────────────────────────────────
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
      keymaps = {
        ["<CR>"]   = "actions.select",
        ["<C-v>"]  = "actions.select_vsplit",
        ["<C-s>"]  = "actions.select_split",
        ["-"]      = "actions.parent",
        ["_"]      = "actions.open_cwd",
        ["`"]      = "actions.cd",
        ["gs"]     = "actions.change_sort",
        ["gx"]     = "actions.open_external",
        ["g."]     = "actions.toggle_hidden",
        ["?"]      = "actions.show_help",
        ["q"]      = "actions.close",
      },
      view_options = {
        show_hidden = true,
      },
      float = {
        padding = 2,
        max_width  = 100,
        max_height = 40,
      },
    },
  },

  -- ── diffview — code review UI ──────────────────────────────────────────────
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      enhanced_diff_hl = true,
      view = {
        default = {
          layout = "diff2_horizontal",
          winbar_info = true,
        },
        merge_tool = {
          layout = "diff3_horizontal",
          disable_diagnostics = true,
        },
      },
      file_panel = {
        listing_style = "tree",
        win_config = { width = 35 },
      },
      hooks = {
        diff_buf_read = function(bufnr)
          -- No wrap, no spell in diff buffers
          vim.opt_local.wrap  = false
          vim.opt_local.spell = false
        end,
      },
    },
  },

  -- ── gitsigns — inline git info ─────────────────────────────────────────────
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add          = { text = "│" },
        change       = { text = "│" },
        delete       = { text = "" },
        topdelete    = { text = "‾" },
        changedelete = { text = "~" },
        untracked    = { text = "┆" },
      },
      current_line_blame = false,  -- toggle with <leader>gB
      current_line_blame_opts = {
        delay = 500,
        virt_text_pos = "eol",
      },
    },
  },

  -- ── render-markdown — markdown renders inline ──────────────────────────────
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown", "md" },
    opts = {
      enabled = true,
      heading = {
        enabled = true,
        sign    = true,
        icons   = { "󰉫 ", "󰉬 ", "󰉭 ", "󰉮 ", "󰉯 ", "󰉰 " },
      },
      code = {
        enabled   = true,
        style     = "full",
        left_pad  = 1,
        right_pad = 1,
        border    = "thin",
      },
      bullet = { enabled = true },
      checkbox = {
        enabled  = true,
        unchecked = { icon = "󰄱" },
        checked   = { icon = "󰱒" },
      },
      table = { enabled = true },
      link  = { enabled = true },
    },
  },

  -- ── trouble — diagnostics panel ────────────────────────────────────────────
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      modes = {
        diagnostics = {
          auto_open   = false,
          auto_close  = true,
          auto_preview = true,
        },
      },
    },
  },

  -- ── treesitter — syntax + folding ─────────────────────────────────────────
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "c", "cpp", "python", "lua", "vim", "vimdoc",
          "bash", "fish", "markdown", "markdown_inline",
          "json", "yaml", "toml", "cmake", "regex",
        },
        auto_install = true,
        highlight    = { enable = true },
        indent       = { enable = true },
        textobjects  = {
          select = {
            enable = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
          move = {
            enable = true,
            goto_next_start     = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
            goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
          },
        },
      })
    end,
  },
}
