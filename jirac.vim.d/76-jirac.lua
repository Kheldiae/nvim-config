--
-- Jirac configuration
--

require 'secrets'
local scr = Scr:new()

-- Jirac IDE integration
require 'jirac'.setup {
    email = scr:fetch("email"),
    domain = scr:fetch("jiracdom"),
    api_key = scr:fetch("api_key"),
    config = {
        keymaps = {}
        -- TODO more advanced options
        -- TODO test launch first
    }
}
