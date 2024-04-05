--
-- Extended configuration of Folke's Noice plugin.
--

-- Noice section
require'noice'.setup {
    presets = { command_palette = true },
    views = {
        cmdline_popup = { relative = "editor" },
        cmdline_popupmenu = { relative = "editor" },
    },
    messages = {
        view = "mini",
        view_warn = "mini",
        view_error = "notify"
    },
}
