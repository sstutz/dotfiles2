vim.pack.add({ "https://github.com/dmtrKovalenko/fff.nvim" })

vim.g.fff = {
  lazy_sync = true,
  debug = { enabled = true, show_scores = true },
}

vim.keymap.set("n", "ff", function()
  require("fff").find_files()
end, { desc = "FFFind files" })

vim.keymap.set("n", "ff", function()
  require("fff").find_files()
end, { desc = "FFFind files" })

vim.keymap.set("n", "fg", function()
  require("fff").live_grep()
end, { desc = "FFFind grep" })

-- require('fff').live_grep_under_cursor()            -- grep <cword> in normal, selection in visual
-- require('fff').scan_files()                        -- force rescan
-- require('fff').refresh_git_status()                -- refresh git status
-- require('fff').find_files_in_dir(path)             -- find in a specific dir
-- require('fff').change_indexing_directory(new_path) -- change root
--
-- vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "find files" })
-- vim.keymap.set("n", "<leader>fg", require("config.telescope.multi-ripgrep"), { desc = "find multi ripgrep" })
-- vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "find help tags" })
-- vim.keymap.set("n", "<C-p>", builtin.git_files, { desc = "find git ls-files" })
-- vim.keymap.set("n", "gb", builtin.buffers, { desc = "Telescope buffers" })
-- vim.keymap.set("n", "qS", ":Telescope persisted<cr>", { desc = "Persisted sessions" })
