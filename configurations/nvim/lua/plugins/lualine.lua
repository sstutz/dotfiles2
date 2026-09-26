vim.pack.add({
  {
    src = "https://github.com/nvim-lualine/lualine.nvim",
  },
})

-- local theme = require("gruvbox-material.lualine").theme("hard")

require("lualine").setup({
  -- options = { theme = theme },
  sections = {
    lualine_x = { "encoding", "filetype", "lsp_status" },
  },
  tabline = {
    lualine_a = {
      {
        "tabs",
        mode = 2, -- 0=tab_nr,1=tab_name,2=tab_nr+tab_name
        use_mode_colors = true,
        path = 0,
        symbols = { modified = "+" },
        max_length = vim.o.columns - 1,
      },
    },
    lualine_z = {
      { workspace_name },
    },
  },
})
