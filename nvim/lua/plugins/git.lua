return {
  -- ── Gitsigns: inline git blame + hunk actions ─────────────────────────────
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    opts  = {
      signs = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "" },
        topdelete    = { text = "" },
        changedelete = { text = "▎" },
        untracked    = { text = "▎" },
      },
      on_attach = function(bufnr)
        local gs  = package.loaded.gitsigns
        local map = function(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end

        -- Navigation
        map("n", "]h", gs.next_hunk,                      "Next hunk")
        map("n", "[h", gs.prev_hunk,                      "Prev hunk")

        -- Hunk actions
        map("n", "<leader>hs", gs.stage_hunk,             "Stage hunk")
        map("n", "<leader>hr", gs.reset_hunk,             "Reset hunk")
        map("v", "<leader>hs", function() gs.stage_hunk({vim.fn.line("."), vim.fn.line("v")}) end, "Stage hunk")
        map("n", "<leader>hS", gs.stage_buffer,           "Stage buffer")
        map("n", "<leader>hu", gs.undo_stage_hunk,        "Undo stage hunk")
        map("n", "<leader>hR", gs.reset_buffer,           "Reset buffer")
        map("n", "<leader>hp", gs.preview_hunk,           "Preview hunk")
        map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
        map("n", "<leader>hd", gs.diffthis,               "Diff this")

        -- Toggle
        map("n", "<leader>tb", gs.toggle_current_line_blame, "Toggle blame")
        map("n", "<leader>td", gs.toggle_deleted,            "Toggle deleted")
      end,
    },
  },

  -- ── Diffview: full code review UI ─────────────────────────────────────────
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>",           desc = "Diffview: open" },
      { "<leader>gD", "<cmd>DiffviewClose<cr>",          desc = "Diffview: close" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>",  desc = "Diffview: file history" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>",    desc = "Diffview: repo history" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        default          = { layout = "diff2_horizontal" },
        merge_tool       = { layout = "diff3_horizontal", disable_diagnostics = true },
        file_history     = { layout = "diff2_horizontal" },
      },
    },
  },

  -- ── Lazygit ───────────────────────────────────────────────────────────────
  {
    "kdheepak/lazygit.nvim",
    cmd  = "LazyGit",
    keys = {
      { "<leader>gl", "<cmd>LazyGit<cr>", desc = "Lazygit" },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
  },
}
