--
-- Trouble.nvim specific configuration file.
--

require'trouble'.setup {
    modes = {
        -- project errors
        proj_errs = {
            mode = "diagnostics",
            filter = { any = {
                buf = 0, {
                    severity = vim.diagnostic.severity.ERROR,
                    function(item)
                        return item.filename:find(
                            (vim.loop or vim.uv).cwd(), 1, true)
                    end
                }
            } },
            -- Simpler formatting, from simpler times
            groups = {
                "filename",
                format = "{file_icon} {basename:Title} {count}"
            },
            -- Preview display, it might be useful
            preview = {
                type = "split",
                relative = "win",
                position = "right",
                size = 0.4
            }
        }
    }
}
