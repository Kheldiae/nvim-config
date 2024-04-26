--
-- Extended configuration of Folke's Noice plugin.
--

local colPos = 39
local rowPos = 5

-- Noice section
require'noice'.setup {
    presets = { command_palette = true },
    views = {
        cmdline_popup = {
            relative = "editor",
            position = { row = rowPos, col = colPos }
        },
        cmdline_popupmenu = {
            relative = "editor",
            position = { row = rowPos + 3, col = colPos - 1 }
        }
    },
    messages = {
        view = "mini",
        view_warn = "mini",
        view_error = "notify"
    }
}
