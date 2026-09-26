vim.pack.add({
  "https://github.com/preservim/tagbar",
})

vim.g.tagbar_position = "topleft vertical"

vim.keymap.set("n", "<c-t>", ":TagbarToggle<cr>")
