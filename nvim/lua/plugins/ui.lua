return {
  -- ── Theme ──────────────────────────────────────────────────────────────────
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
      transparent_background = false,
      integrations = {
        telescope     = { enabled = true, style = "nvchad" },
        harpoon       = true,
        gitsigns      = true,
        treesitter    = true,
        render_markdown = true,
        mini          = { enabled = true },
        which_key     = true,
        lsp_trouble   = true,
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- ── Status line ────────────────────────────────────────────────────────────
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "catppuccin",
        globalstatus = true,
        section_separators   = { left = "", right = "" },
        component_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { { "mode", icon = "" } },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },  -- relative path
        lualine_x = { "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  -- ── Bufferline ─────────────────────────────────────────────────────────────
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        offsets = {
          { filetype = "NvimTree", text = "Files", highlight = "Directory" },
        },
      },
    },
    config = function(_, opts)
      require("bufferline").setup(opts)
    end,
  },

  -- ── Which-key (discoverability) ────────────────────────────────────────────
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      spec = {
        { "<leader>f", group = "find/telescope" },
        { "<leader>g", group = "git" },
        { "<leader>s", group = "splits" },
        { "<leader>x", group = "trouble/diagnostics" },
        { "<leader>l", group = "lsp" },
        { "<leader>m", group = "markdown" },
      },
    },
  },

  -- ── Indent guides ──────────────────────────────────────────────────────────
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = { char = "│" },
      scope  = { enabled = true },
    },
  },

  -- ── Dashboard ──────────────────────────────────────────────────────────────
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    opts = {
      theme = "hyper",
      config = {
        header = {
          "",
          "  ██╗  ██╗███████╗██╗     ██╗      ██████╗ ",
          "  ██║  ██║██╔════╝██║     ██║     ██╔═══██╗",
          "  ███████║█████╗  ██║     ██║     ██║   ██║",
          "  ██╔══██║██╔══╝  ██║     ██║     ██║   ██║",
          "  ██║  ██║███████╗███████╗███████╗╚██████╔╝",
          "  ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝ ╚═════╝ ",
          "",
        },
        shortcut = {
          { desc = " Find file",    group = "@property", action = "Telescope find_files", key = "f" },
          { desc = " Recent",       group = "@property", action = "Telescope oldfiles",   key = "r" },
          { desc = " Grep",         group = "@property", action = "Telescope live_grep",  key = "g" },
          { desc = "󱂬 Lazy",         group = "@property", action = "Lazy",                 key = "l" },
          { desc = " Quit",         group = "@property", action = "qa",                   key = "q" },
        },
        footer = function()
          local stats = require("lazy").stats()
          return { "⚡ " .. stats.count .. " plugins loaded" }
        end,
      },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  -- ── Notifications ──────────────────────────────────────────────────────────
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search        = true,
        command_palette      = true,
        long_message_to_split = true,
        inc_rename           = false,
      },
    },
  },

  -- ── Icons ──────────────────────────────────────────────────────────────────
  { "nvim-tree/nvim-web-devicons", lazy = true },
}
