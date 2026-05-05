return {
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
        },
      })

      local map = vim.keymap.set

      -- Add current file to harpoon
      map("n", "<leader>a", function() harpoon:list():add() end,
        { desc = "Harpoon: add file" })

      -- Toggle quick menu
      map("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
        { desc = "Harpoon: menu" })

      -- Jump to mark 1-4
      for i = 1, 4 do
        map("n", "<C-" .. i .. ">", function() harpoon:list():select(i) end,
          { desc = "Harpoon: jump to " .. i })
      end

      -- Navigate prev/next in list
      map("n", "<C-S-p>", function() harpoon:list():prev() end, { desc = "Harpoon: prev" })
      map("n", "<C-S-n>", function() harpoon:list():next() end, { desc = "Harpoon: next" })

      -- Telescope integration — browse harpoon list
      map("n", "<leader>fh", function()
        local conf = require("telescope.config").values
        local file_paths = {}
        for _, item in ipairs(harpoon:list().items) do
          table.insert(file_paths, item.value)
        end
        require("telescope.pickers").new({}, {
          prompt_title  = "Harpoon",
          finder  = require("telescope.finders").new_table({ results = file_paths }),
          previewer = conf.file_previewer({}),
          sorter  = conf.generic_sorter({}),
        }):find()
      end, { desc = "Harpoon: telescope" })
    end,
  },
}
