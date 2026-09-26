-- vim.g.gruvbox_contrast_dark = "hard"
-- vim.g.gruvbox_material_enable_italic = true
vim.cmd.colorscheme("gruvbox")

vim.g.background = "dark"
require("vim._core.ui2").enable({
  enable = true, -- Whether to enable or disable the UI.
})
