-- ── plugins/coding.lua ───────────────────────────────────────────────────────
return {

  -- ── nvim-cmp — completion ─────────────────────────────────────────────────
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp    = require("cmp")
      local luasnip = require("luasnip")

      require("luasnip.loaders.from_vscode").lazy_load()
      luasnip.config.setup({})

      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"]    = cmp.mapping.select_next_item(),
          ["<C-p>"]    = cmp.mapping.select_prev_item(),
          ["<C-b>"]    = cmp.mapping.scroll_docs(-4),
          ["<C-f>"]    = cmp.mapping.scroll_docs(4),
          ["<C-Space>"]= cmp.mapping.complete(),
          ["<C-e>"]    = cmp.mapping.abort(),
          ["<CR>"]     = cmp.mapping.confirm({ select = true }),
          ["<Tab>"]    = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"]  = cmp.mapping(function(fallback)
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
          { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip",  priority = 750 },
          { name = "buffer",   priority = 500 },
          { name = "path",     priority = 250 },
        }),
        formatting = {
          format = function(entry, vim_item)
            local kind_icons = {
              Text          = "󰉿", Method        = "󰆧", Function      = "󰊕",
              Constructor   = "",  Field         = "󰜢", Variable      = "󰀫",
              Class         = "󰠱", Interface     = "",  Module        = "",
              Property      = "󰜢", Unit          = "󰑭", Value         = "󰎠",
              Enum          = "",  Keyword       = "󰌋", Snippet       = "",
              Color         = "󰏘", File          = "󰈙", Reference     = "󰈇",
              Folder        = "󰉋", EnumMember    = "",  Constant      = "󰏿",
              Struct        = "󰙅", Event         = "",  Operator      = "󰆕",
              TypeParameter = "",
            }
            vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind] or "", vim_item.kind)
            vim_item.menu = ({
              nvim_lsp = "[LSP]",
              luasnip  = "[Snip]",
              buffer   = "[Buf]",
              path     = "[Path]",
            })[entry.source.name]
            return vim_item
          end,
        },
        window = {
          completion    = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        experimental = { ghost_text = true },
      })

      -- Cmdline completions
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "buffer" } },
      })
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources(
          { { name = "path" } },
          { { name = "cmdline" } }
        ),
      })
    end,
  },

  -- ── autopairs ─────────────────────────────────────────────────────────────
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
      require("nvim-autopairs").setup({ check_ts = true })
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- ── comments ──────────────────────────────────────────────────────────────
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    config = function()
      require("Comment").setup({
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })
    end,
  },

  -- ── surround ──────────────────────────────────────────────────────────────
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    opts  = {},
  },

  -- ── lazygit ───────────────────────────────────────────────────────────────
  {
    "kdheepak/lazygit.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
  },

  -- ── todo comments ─────────────────────────────────────────────────────────
  {
    "folke/todo-comments.nvim",
    event        = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = true },
    keys = {
      { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Find TODOs" },
    },
  },

  -- ── flash — fast navigation ────────────────────────────────────────────────
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts  = {},
    keys  = {
      { "s",     function() require("flash").jump() end,              desc = "Flash jump",           mode = { "n", "x", "o" } },
      { "S",     function() require("flash").treesitter() end,        desc = "Flash treesitter",     mode = { "n", "x", "o" } },
      { "r",     function() require("flash").remote() end,            desc = "Flash remote",         mode = "o" },
      { "<c-s>", function() require("flash").toggle() end,            desc = "Toggle flash search",  mode = "c" },
    },
  },
}
