--
-- Extended configuration of Folke's Noice plugin.
--

local colPos = 40

-- Noice section
require'noice'.setup {
    presets = { command_palette = true },
    views = {
        cmdline_popup = {
            relative = "editor",
            position = { row = 5, col = colPos }
        },
        cmdline_popupmenu = {
            relative = "editor",
            position = { row = 8, col = colPos - 1 }
        },
    },
    messages = {
        view = "mini",
        view_warn = "mini",
        view_error = "notify"
    },
}
