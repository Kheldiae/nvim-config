--
-- Extended configuration of Folke's Noice plugin. This does not cover any
-- form of readability setting, those are handled in 11-colorscheme.
--

-- Some constants, to rule the cmdline.
-- Make sure they match the way you personnaly use this editor.
local colPos = 39
local rowPos = 5
local blending = 1

-- Noice section
require 'noice'.setup {
    presets = { command_palette = true },
    views = {
        cmdline_popup = {
            relative = "editor",
            position = { row = rowPos, col = colPos }
        },
        cmdline_popupmenu = {
            relative = "editor",
            position = { row = rowPos + 3, col = colPos - 1 }
        },
        mini = { win_options = { winblend = blending } }
    },
    messages = {
        view = "mini",
        view_warn = "mini",
        view_error = "notify"
    },
    format = {
        filter = {
            pattern = "^:%s*!",
            icon = "$",
            lang = "zsh" -- make sure this matched your favorite shell
        }
    },
    lsp = {
        override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true
        }
    },
    routes = {
        filter = {
            event = "msg_show",
            kind = ""
        },
        opts = { skip = true } -- jdtls, please stfu
    }
}
