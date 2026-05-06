return {
  {
    "nvim-telescope/telescope.nvim",
    version = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-ui-select.nvim",
    },
    config = function()
      local telescope = require("telescope")
      local actions   = require("telescope.actions")

      telescope.setup({
        defaults = {
          prompt_prefix  = "  ",
          selection_caret = " ",
          path_display   = { "smart" },
          sorting_strategy = "ascending",
          layout_config  = {
            horizontal   = { prompt_position = "top", preview_width = 0.55 },
            vertical     = { mirror = false },
            width        = 0.87,
            height       = 0.80,
          },
          mappings = {
            i = {
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
              ["<esc>"] = actions.close,
            },
          },
        },
        pickers = {
          find_files       = { hidden = true },
          live_grep        = { additional_args = { "--hidden" } },
          git_files        = { show_untracked = true },
        },
        extensions = {
          fzf = {
            fuzzy                   = true,
            override_generic_sorter = true,
            override_file_sorter    = true,
            case_mode               = "smart_case",
          },
        },
      })

      telescope.load_extension("fzf")
      telescope.load_extension("ui-select")

      -- Keymaps
      local map = vim.keymap.set
      local b   = require("telescope.builtin")

      map("n", "<leader>ff", b.find_files,                    { desc = "Find files" })
      map("n", "<leader>fg", b.live_grep,                     { desc = "Live grep" })
      map("n", "<leader>fb", b.buffers,                       { desc = "Buffers" })
      map("n", "<leader>fr", b.oldfiles,                      { desc = "Recent files" })
      map("n", "<leader>fw", b.grep_string,                   { desc = "Grep word under cursor" })
      map("n", "<leader>fs", b.lsp_document_symbols,          { desc = "Document symbols" })
      map("n", "<leader>fS", b.lsp_dynamic_workspace_symbols, { desc = "Workspace symbols" })
      map("n", "<leader>fd", b.diagnostics,                   { desc = "Diagnostics" })
      map("n", "<leader>fk", b.keymaps,                       { desc = "Keymaps" })
      map("n", "<leader>fc", b.commands,                      { desc = "Commands" })

      -- Git pickers
      map("n", "<leader>gc", b.git_commits,                   { desc = "Git commits" })
      map("n", "<leader>gb", b.git_branches,                  { desc = "Git branches" })
      map("n", "<leader>gs", b.git_status,                    { desc = "Git status" })

      -- Search from arbitrary root (useful for reviewing multi-project)
      map("n", "<leader>fF", function()
        local dir = vim.fn.input("Search dir: ", vim.fn.getcwd(), "dir")
        if dir ~= "" then b.find_files({ cwd = dir }) end
      end, { desc = "Find files (custom root)" })
      map("n", "<leader>fG", function()
        local dir = vim.fn.input("Grep dir: ", vim.fn.getcwd(), "dir")
        if dir ~= "" then b.live_grep({ cwd = dir }) end
      end, { desc = "Live grep (custom root)" })
    end,
  },
}
