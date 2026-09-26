local default_keymaps = {
  { keys = "<leader>ca", func = vim.lsp.buf.code_action, desc = "Code Actions" },
  { keys = "<leader>cr", func = vim.lsp.buf.rename, desc = "Code Rename" },
  { keys = "<leader>cl", func = vim.lsp.codelens.run, desc = "Code Lens" },
  { keys = "<leader>cv", func = "<cmd>vsplit | lua vim.lsp.buf.definition()<cr>", desc = "Definition in vsplit" },
  {
    keys = "K",
    func = function()
      vim.lsp.buf.hover({ border = "rounded", max_height = 25, max_width = 120 })
    end,
    desc = "Hover",
    has = "hoverProvider",
  },
  { keys = "gd", func = vim.lsp.buf.definition, desc = "Goto definition ", has = "definitionProvider" },
  { keys = "gD", func = vim.lsp.buf.declaration, desc = "Goto declaration ", has = "declarationProvider" },
  { keys = "gs", func = vim.lsp.buf.document_symbol, desc = "Goto Document Symbol ", has = "documentSymbolProvider" },
  {
    keys = "gS",
    func = vim.lsp.buf.workspace_symbol,
    desc = "Goto Workspace Symbol ",
    has = "workspaceSymbolProvider",
  },
  { keys = "gi", func = vim.lsp.buf.implementation, desc = "Goto implementation", has = "implementationProvider" },
  { keys = "gr", func = vim.lsp.buf.references, desc = "find references", has = "referencesProvider" },
  { keys = "gt", func = vim.lsp.buf.type_definition, desc = "Goto type definition", has = "typeDefinitionProvider" },
  { keys = "<c-k>", mode = "i", func = vim.lsp.buf.signature_help, desc = "Signature Help" },
}

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local buf = args.buf
    if client then
      if client:supports_method("textDocument/inlayHint") then
        vim.lsp.inlay_hint.enable(true, { bufnr = buf })
        vim.notify("inlayHint enabled")

        if not vim.b[buf].inlay_hints_autocmd_set then
          vim.api.nvim_create_autocmd("InsertEnter", {
            buffer = buf,
            callback = function()
              vim.lsp.inlay_hint.enable(false, { bufnr = buf })
            end,
          })

          vim.api.nvim_create_autocmd("InsertLeave", {
            buffer = buf,
            callback = function()
              vim.lsp.inlay_hint.enable(true, { bufnr = buf })
            end,
          })

          -- vim.keymap.set("n", "<leader>ch", function()
          --   vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ 0 }), { 0 })
          -- end)

          vim.b[buf].inlay_hints_autocmd_set = true
        end
      end
      if client:supports_method("textDocument/codeLens") then
        vim.lsp.codelens.enable(true, {
          bufnr = buf,
        })
        vim.notify("codeLens enabled")
      end

      if client:supports_method("textDocument/documentColor") then
        vim.lsp.document_color.enable(true, {
          bufnr = buf,
          style = "virtual",
        })
        vim.notify("documentColor enabled")
      end

      for _, km in ipairs(default_keymaps) do
        if not km.has or client.server_capabilities[km.has] then
          vim.keymap.set(
            km.mode or "n",
            km.keys,
            km.func,
            { buffer = buf, desc = "LSP: " .. km.desc, nowait = km.nowait }
          )
        end
      end
    end
  end,
})

-- Enable LSP servers for Neovim 0.11+
vim.lsp.enable({
  "vtsls",
  "oxlint", -- Priority linter
  -- "eslint", -- Fallback linter
  "lua_ls",
  "gopls",
  -- "intelephense",
  "phpantom_lsp",
  "jsonls",
})
