-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

local servers = { 
  "tsserver",       -- TypeScript & JavaScript
  "omnisharp",      -- C#
  "dartls",         -- Dart & Flutter
  "html",           -- HTML
  "cssls",          -- CSS
  "tailwindcss",    -- Tailwind CSS (if needed)
  "lua_ls",         -- Lua
  "angularls",      -- Angular
  "astro",          -- Astro
  "ltex",           -- Spell Checker
  "pyright"         -- Python
}

local nvlsp = require "nvchad.configs.lspconfig"

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-- typescript
-- lspconfig.tsserver.setup {
--   on_attach = on_attach,
--   on_init = on_init,
--   capabilities = capabilities,
-- }
