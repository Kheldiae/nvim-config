--
-- Nvim-Tree specific lua configuration and readability update, for better
-- differences between file types (.feature, I'm looking at you).
--

-- Nvim-Tree config
require'nvim-tree'.setup {
    hijack_netrw = true,
    sync_root_with_cwd = true,
    diagnostics = { enable = true },
    renderer = {
        group_empty = true,
        indent_markers = { enable = true },
        icons = {
            show = {
                file = true, folder = true, folder_arrow = true, git = true
            }
        }
    },
    filters = {
        dotfiles = true,
        custom = { '^\\.git$', '^\\.cache$', '_secrets.yaml' }
    },
    git = { ignore = true, },
    view = {
        width = 30,
        side = 'left',
        adaptive_size = false
    }
}

-- Nvim-Web-Devicons configuration
require'nvim-web-devicons'.set_icon {
    -- Cucumber feature books
    feature = {
        icon = "󱚊",
        color = "#23d96c",
        cterm_color = "118",
        name = "Feature"
    },
    -- Template files of all types
    template = {
        icon = "",
        color = "#b2b2b2",
        cterm_color = "247",
        name = "Template"
    },
    -- Snippets files
    snippets = {
        icon = "󰆏",
        color = "#926c4c",
        cterm_color = "130",
        name = "Snippets"
    },
    -- Cambalache and GUI files
    cmb = {
        icon = "",
        color = "#00d7ff",
        cterm_color = "75",
        name = "Cmb"
    },
    ui = {
        icon = "",
        color = "#5fafff",
        cterm_color = "45",
        name = "Ui"
    }
}
