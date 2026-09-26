vim.pack.add({
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    version = "main",
  },
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
    version = "main",
  },
})

require("nvim-treesitter").install({
  "bash",
  "blade",
  "c",
  "comment",
  "css",
  "diff",
  "dockerfile",
  "gitcommit",
  "gitignore",
  "go",
  "gomod",
  "gosum",
  "gowork",
  "html",
  "javascript",
  "jsdoc",
  "json",
  "lua",
  "luadoc",
  "luap",
  "make",
  "markdown",
  "markdown_inline",
  "nginx",
  "php",
  "python",
  "query",
  "regex",
  "scss",
  "sql",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "xml",
  "yaml",
})

require("nvim-treesitter-textobjects").setup({
  select = {
    enable = true,
    lookahead = true,
    selection_modes = {
      ["@parameter.outer"] = "v", -- charwise
      ["@function.outer"] = "V", -- linewise
      ["@class.outer"] = "<c-v>", -- blockwise
    },
    include_surrounding_whitespace = false,
  },
  move = {
    enable = true,
    set_jumps = true,
  },
})

-- SELECT keymaps
local sel = require("nvim-treesitter-textobjects.select")
for _, map in ipairs({
  { { "x", "o" }, "af", "@function.outer" },
  { { "x", "o" }, "if", "@function.inner" },
  { { "x", "o" }, "ac", "@class.outer" },
  { { "x", "o" }, "ic", "@class.inner" },
  { { "x", "o" }, "aa", "@parameter.outer" },
  { { "x", "o" }, "ia", "@parameter.inner" },
  { { "x", "o" }, "ad", "@comment.outer" },
  { { "x", "o" }, "as", "@statement.outer" },
}) do
  vim.keymap.set(map[1], map[2], function()
    sel.select_textobject(map[3], "textobjects")
  end, { desc = "Select " .. map[3] })
end

local SKIP_FT = {
  [""] = true,
  qf = true,
  help = true,
  man = true,
  noice = true,
  notify = true,
  dapui_scopes = true,
  dapui_breakpoints = true,
  dapui_stacks = true,
  dapui_watches = true,
  dapui_console = true,
  dap_repl = true,
  gitcommit = true,
  gitrebase = true,
  lazy = true,
  lspinfo = true,
  checkhealth = true,
  startuptime = true,
  TelescopePrompt = true,
  TelescopeResults = true,
  spectre_panel = true,
  ["grug-far"] = true,
  trouble = true,
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "*" },
  callback = function()
    local ft = vim.bo.filetype
    if SKIP_FT[ft] then
      return
    end

    local ok = pcall(vim.treesitter.start)
    if not ok then
      return
    end

    -- Only set expr folds when treesitter successfully started
    vim.wo[0].foldmethod = "expr"
    vim.wo[0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
