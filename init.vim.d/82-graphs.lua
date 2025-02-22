--
-- Graph plugin configuration file.
--

require 'nix'
local nix = Nix:new()

-- pathing fix
vim.env['PATH'] = vim.env['PATH'] .. ':' .. nix:path("mermaid-cli", "/bin")

-- Plugin setup
require 'diagram'.setup {
    integrations = {
        require 'diagram.integrations.markdown'
    },
    renderer_options = {
        mermaid = { theme = "dark", background = "transparent" },
        plantuml = { charset = "utf-8" },
        d2 = { theme_id = 1, dark_theme_id = 1 },
        gnuplot = { theme = "dark", size = "400,200" }
    }
}
