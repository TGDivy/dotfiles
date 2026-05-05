return {
  -- ── render-markdown: renders markdown inline in nvim (no browser needed) ───
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft   = { "markdown", "Avante" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = {
      enabled  = true,
      -- Render inside normal buffers (great for plan files)
      render_modes = { "n", "c", "t" },  -- normal + command + terminal
      heading = {
        enabled    = true,
        sign       = true,
        icons      = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
        backgrounds = {
          "RenderMarkdownH1Bg", "RenderMarkdownH2Bg", "RenderMarkdownH3Bg",
          "RenderMarkdownH4Bg", "RenderMarkdownH5Bg", "RenderMarkdownH6Bg",
        },
      },
      code = {
        enabled      = true,
        sign         = true,
        style        = "full",   -- full block highlight
        border       = "thin",
        language_pad = 1,
        min_width    = 40,
      },
      bullet = {
        enabled = true,
        icons   = { "●", "○", "◆", "◇" },
      },
      checkbox = {
        enabled   = true,
        unchecked = { icon = "󰄱 " },
        checked   = { icon = "󰱒 " },
      },
      table = {
        enabled = true,
        style   = "full",
      },
      link = {
        enabled = true,
        image   = "󰥶 ",
        email   = "󰀓 ",
        hyperlink = "󰌹 ",
      },
      sign = { enabled = true },
      win_options = {
        conceallevel = { default = 2, rendered = 3 },
        concealcursor = { default = "", rendered = "nvic" },
      },
    },
  },

  -- ── Peek: quick floating markdown preview (if you ever want browser-style) ─
  -- Disabled by default — use render-markdown instead
  -- {
  --   "toppair/peek.nvim",
  --   build = "deno task --quiet build:fast",
  --   keys = { { "<leader>mP", function() require("peek").open() end, desc = "Peek markdown" } },
  --   opts = { theme = "dark", app = "browser" },
  -- },
}
