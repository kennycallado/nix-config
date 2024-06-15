--[[
-- This file is meant to be a reference, it will not be linked by home-manager
--]]

local harpoon = {
  "ThePrimeagen/harpoon",
  event = "VeryLazy",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
  },
}

lvim.keys.normal_mode["<S-m>"] = "<cmd>lua require('harpoon.mark').add_file()<cr>"
lvim.keys.normal_mode["<TAB>"] = "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>"

-- this way you can add multiple plugins
-- without overwriting the plugins table
table.insert(lvim.plugins, harpoon)
