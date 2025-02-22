--
-- Configs for miscellaneous Lua-powered plugins
--

require 'nix'

local nix = Nix:new()

vim.env['PATH'] = vim.env['PATH'] .. ':' .. nix:path("universal-ctags", "/bin")

-- Custom notification popups
local vnotify = require 'notify'

vnotify.setup {
    background_colour = "#262626"
}

vim.notify = function(msg, ...)
    if msg:match("warning: multiple different client offset_encodings")
    then
        return
    end

    vnotify(msg, ...)
end

-- Light/dark theme watch
require 'fwatch'.watch(os.getenv("XDG_RUNTIME_DIR") .. "/theme",
    {
        on_event = function()
            vim.defer_fn(vim.fn.SetColor, 10)
        end
    })

-- Visual Git integration
require 'vgit'.setup {}

-- Color picker
require 'color-picker'.setup {
    border = "rounded",
    keymap = {
        ["p"] = "<Plug>ColorPickerSlider5Increase",
        ["i"] = "<Plug>ColorPickerSlider5Decrease"
    }
}

-- Git conflict markers
require 'git-conflict'.setup {
    default_mappings = false,
    disable_diagnostics = true,
}

-- Beautiful status column
function _diag(args)
    if args.button == "m" then
        vim.cmd("CodeActionMenu")
    else
        require "statuscol.builtin".diagnostic_click(args)
    end
end

function _git(args)
    if args.button == "l" then
        vim.cmd("VGit buffer_hunk_preview")
    elseif args.button == "m" then
        vim.cmd("VGit buffer_hunk_reset")
    elseif args.button == "r" then
        vim.cmd("VGit buffer_hunk_stage")
    end
end

require 'statuscol'.setup {
    relculright = false,
    clickhandlers = {
        DiagnosticSignError = _diag,
        DiagnosticSignHint = _diag,
        DiagnosticSignInfo = _diag,
        DiagnosticSignWarn = _diag,
        GitSignsTopdelete = _git,
        GitSignsUntracked = _git,
        GitSignsAdd = _git,
        GitSignsChange = _git,
        GitSignsChangedelete = _git,
        GitSignsDelete = _git,
        gitsigns_extmark_signs_ = _git,
    },
}

-- Indent blank line
local hooks = require 'ibl.hooks'

require 'ibl'.setup {
    indent = { char = '┊' },
    exclude = {
        filetypes = {
            "startify",
            "NvimTree", "vista_kind", "vista", "Trouble", "coq-goals"
        }
    }
}

-- Per-project secure exrc
require 'exrc'.setup {
    files = {
        ".nvimrc.lua",
        ".nvimrc",
        ".exrc.lua",
        ".exrc"
    }
}

-- TreeSitter config
vim.env['PATH'] = vim.env['PATH'] .. ':' .. nix:path("tree-sitter", "/bin")

require 'nvim-treesitter.configs'.setup {
    ensure_installed = {
        "c", "dot", "lua", "vim", "vimdoc", "query",
        "python", "markdown", "markdown_inline", "rust",
    },

    highlight = {
        enable = true,
        disable = {
            "c", "cpp", "pandoc", "rust",
            "markdown", "markdown_inline", "java"
        }
    }
}

vim.treesitter.language.register('c', 'c.doxygen')
vim.treesitter.language.register('cpp', 'cpp.doxygen')
vim.treesitter.language.register('cuda', 'cuda.doxygen')

-- TreeSitter Context config
require 'treesitter-context'.setup {
    enable = true,
    mode = 'cursor',
    max_lines = 10
}

-- Image.nvim config
require 'image'.setup {
    backend = "kitty",
    max_width = 300,
    max_height = 50,
    max_height_window_percentage = math.huge,
    max_width_window_percentage = math.huge,
    window_overlap_clear_enabled = true,
    integrations = {
        markdown = {
            enabled = true,
            clear_in_insert_mode = true,
            download_remote_images = true,
            only_render_image_at_cursor = false,
            filetypes = { "markdown", "vimwiki", "pandoc" }
        }
    }
}

-- img-clip config
if vim.env['XDG_SESSION_TYPE'] == 'wayland'
then
    vim.env['PATH'] = vim.env['PATH'] .. ':' .. nix:path("wl-clipboard-x11", "/bin")
else
    vim.env['PATH'] = vim.env['PATH'] .. ':' .. nix:path("wl-clipboard-x11", "/bin")
end

require 'img-clip'.setup {
    pandoc = {
        url_encode_path = true,
        template = "![$CURSOR]($FILE_PATH)",

        drag_and_drop = {
            download_images = false
        }
    }
}

-- kitty-scrollback config
require 'kitty-scrollback'.setup()
