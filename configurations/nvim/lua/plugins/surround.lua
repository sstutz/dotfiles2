vim.pack.add({
  "https://github.com/nvim-mini/mini.surround",
})

require("mini.surround").setup({
  mappings = {
    add = "ys", -- Add surrounding in Normal and Visual modes
    delete = "ds", -- Delete surrounding
    replace = "cs", -- Replace surrounding
  },
})
