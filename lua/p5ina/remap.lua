local wk = require("which-key")
local mappings = {
  { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find File", mode = "n" },
  { "<leader>e", vim.cmd.Ex, desc = "Open file explorer", mode = "n" },
}

wk.add(mappings)

