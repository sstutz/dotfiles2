vim.pack.add({
  {
    src = "https://github.com/nvim-telescope/telescope.nvim",
  },
  {
    src = "https://github.com/nvim-telescope/telescope-ui-select.nvim",
  },
  {
    src = "https://github.com/nvim-lua/plenary.nvim",
  },
  {
    src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    cond = function()
      return vim.fn.executable("make") == 1
    end,
  },
})

local builtin = require("telescope.builtin")
local actions = require("telescope.actions")
local telesc = require("telescope")
telesc.setup({
  defaults = {
    mappings = {
      i = {
        ["<C-u>"] = false,
        ["<esc>"] = actions.close,
        ["<c-d>"] = actions.delete_buffer + actions.move_to_top,
      },
    },
  },
  extensions = {
    fzf = {},
    ["ui-select"] = {},
    persisted = {},
  },
  pickers = {
    find_files = {
      hidden = true, -- Show hidden files
      find_command = {
        "fd",
        "--type",
        "f",
        "--hidden",
        "--follow",
        "--exclude",
        ".git",
      },
    },
  },
})

telesc.load_extension("persisted")
telesc.load_extension("fzf")
telesc.load_extension("ui-select")

vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "find files" })
vim.keymap.set("n", "<leader>fg", require("config.telescope.multi-ripgrep"), { desc = "find multi ripgrep" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "find help tags" })
vim.keymap.set("n", "<C-p>", builtin.git_files, { desc = "find git ls-files" })
vim.keymap.set("n", "gb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "qS", ":Telescope persisted<cr>", { desc = "Persisted sessions" })
