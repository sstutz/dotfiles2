---@type vim.lsp.config
return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = {
    ".git",
    ".luarc.json",
    ".luarc.jsonc",
  },
  settings = {
    Lua = {
      codeLens = { enable = true },
      hint = { enable = true, semicolon = "Disable" },
      diagnostics = {
        globals = { "vim", "require" },
        disable = { "inject-field", "undefined-field", "missing-fields" },
      },
      runtime = {
        version = "LuaJIT",
        pathStrict = false, -- This is where magic happens
      },
      workspace = {
        library = {
          vim.env.VIMRUNTIME,
          "${3rd}/luv/library",
        },
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
}
