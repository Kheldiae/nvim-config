--
-- Extended configuration of Folke's Noice plugin.
--

-- Noice section
require'noice'.setup {
    presets = { command_palette = true },
    views = {
        cmdline_popup = {
            relative = "editor",
            position = { row = 5 }
        },
        cmdline_popupmenu = {
            relative = "editor",
            position = { row = 8 }
        },
    },
    messages = {
        view = "mini",
        view_warn = "mini",
        view_error = "notify"
    },
}
