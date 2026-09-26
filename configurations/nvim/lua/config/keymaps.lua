local map = vim.keymap.set
local opts = { noremap = true, silent = true }

local imap_expr = function(lhs, rhs)
  vim.keymap.set("i", lhs, rhs, { expr = true })
end

-- write buffer with sudo permissions
map("c", "w!!", ":w !sudo tee % > /dev/null<CR>:edit!<CR>")

-- convenient window navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- smarter command-line history navigation
map("c", "<C-n>", "<down>")
map("c", "<C-p>", "<up>")

-- smarter popup-menu navigation
imap_expr("<CR>", [[ pumvisible() ? "\<C-y>" : "\<CR>"]])
imap_expr("<Tab>", [[ pumvisible() ? "\<C-n>" : "\<Tab>"]])
imap_expr("<Down>", [[ pumvisible() ? "\<C-n>" : "\<Down>"]])
imap_expr("<S-Tab>", [[ pumvisible() ? "\<C-p>" : "\<S-Tab>"]])
imap_expr("<Up>", [[ pumvisible() ? "\<C-p>" : "\<Up>"]])
imap_expr("<Esc>", [[ pumvisible() ? "\<C-e>" : "\<Esc>"]])
imap_expr("<PageDown>", [[ pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"]])
imap_expr("<PageUp>", [[ pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"]])

-- Better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Move Lines
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

-- Goto
map("n", "==", "gg<S-v>G")
map("n", "gl", "$", { desc = "Go to end of line" })
map("n", "gh", "^", { desc = "Go to start of line" })

-- buffers
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
map(
  "n",
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / Clear hlsearch / Diff Update" }
)

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

map("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
map("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

-- Close all fold except the current one.
map("n", "zv", "zMzvzz", {
  desc = "Close all folds except the current one",
})

-- Better paste
-- remap "p" in visual mode to delete the highlighted text without overwriting your yanked/copied text, and then paste the content from the unnamed register.
map("v", "p", '"_dP', opts)

-- goto previously pasted string
map("n", "gp", "`[v`]")

-- Clipboard functionality (paste from system)
map("v", "<leader>y", '"+y')
map("n", "<leader>y", '"+y')
map("n", "<leader>p", '"+p')
map("n", "<leader>P", '"+P')
map("v", "<leader>p", '"+p')
map("v", "<leader>P", '"+P')

-- [count matches] count the occurrences of the previously searched pattern
map("n", "<leader>cm", ":%s///gn<cr>")

--- convenient split hotkeys
map("n", "<leader>s", ":split<cr>")
map("n", "<leader>v", ":vsplit<cr>")
map("n", "<leader>q", ":close<cr>")
map("n", "<leader>fe", ":Lexplore<cr>")

-- Stay in indent mode
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- moving
map("n", "<A-Down>", ":m .+1<CR>", opts)
map("n", "<A-Up>", ":m .-2<CR>", opts)
map("i", "<A-Down>", "<Esc>:m .+1<CR>==gi", opts)
map("i", "<A-Up>", "<Esc>:m .-2<CR>==gi", opts)
map("v", "<A-Down>", ":m '>+1<CR>gv=gv", opts)
map("v", "<A-Up>", ":m '<-2<CR>gv=gv", opts)

-- Fix Spell checking
map("n", "z0", "1z=", {
  desc = "Fix world under cursor",
})

map("n", "zT", function()
  local current_state = vim.o.spell
  local bufnr = vim.api.nvim_get_current_buf()

  if current_state then
    local clients = vim.lsp.get_clients({ bufnr = bufnr, name = "harper_ls" })
    for _, client in ipairs(clients) do
      client:stop()
    end
    vim.o.spell = false
    vim.lsp.enable("harper_ls", false)
    vim.notify("Disabled Spell + Harper")
  else
    vim.o.spell = true
    vim.lsp.enable("harper_ls", true)
    vim.notify("Enabled Spell + Harper")
  end
end, { desc = "Toggle Spell + Harper" })

-- auto close pairs
-- map("i", "'", "''<left>")
-- map("i", "<", "<><left>")
map("i", "`", "``<left>")
map("i", '"', '""<left>')
map("i", "(", "()<left>")
map("i", "[", "[]<left>")
map("i", "{", "{}<left>")

-- vim.pack keymaps
map("n", "<leader>pu", "<cmd>lua vim.pack.update()<CR>")
