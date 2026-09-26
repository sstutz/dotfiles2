-- Build hooks must be registered before vim.pack.add() so they fire on first install.
vim.api.nvim_create_autocmd("PackChanged", {
  desc = "Handle install and update events",
  group = vim.api.nvim_create_augroup("nvim-pack-install-update-handler", { clear = true }),
  callback = function(event)
    local name, kind = event.data.spec.name, event.data.kind
    if kind ~= "install" and kind ~= "update" then
      return
    end

    if name == "fff.nvim" and (kind == "install" or kind == "update") then
      if not event.data.active then
        vim.notify("fff loaded")
        vim.cmd.packadd("fff.nvim")
      end
      require("fff.download").download_or_build_binary()
      vim.notify("triggered")
    end

    if name == "telescope-fzf-native.nvim" then
      vim.system({ "make" }, { cwd = event.data.path }):wait()
    end
    if event.data.kind == "update" then
      local ok = pcall(vim.cmd, "TSUpdate")
      if ok then
        vim.notify("TSUpdate completed successfully!", vim.log.levels.INFO)
      else
        vim.notify("TSUpdate command not available yet, skipping", vim.log.levels.WARN)
      end
    end
  end,
})

require("plugins.gruvbox")
require("plugins.lualine")
require("plugins.blink")
require("plugins.conform")
require("plugins.surround")
require("plugins.git")
require("plugins.vim-tmux-navigator")
require("plugins.grug-far")
require("plugins.treesitter")
require("plugins.whichkey")
require("plugins.mason")
require("plugins.lspconfig")
require("plugins.undotree")
require("plugins.persisted")
require("plugins.tagbar")
require("plugins.telescope")
-- require("plugins.fff")

vim.cmd("runtime! grep.vim")
