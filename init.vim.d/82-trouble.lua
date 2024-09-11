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
            -- simpler formatting
            groups = {
                "filename",
                format = "{file_icon} {basename:Title} {count}"
            }
        }
    }
}
