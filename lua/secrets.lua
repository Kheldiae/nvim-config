--
-- Secrecy module, fetches secrets from system service.
--

require 'nix'
local nix = Nix:new()

Scr = {}

-- Change this path to match your configuration. File not included
local scr_path = os.getenv("HOME") .. "/.local/etc/scr/jirac-nvim.json.scr"

-- Ensuring we have sops available
vim.env['PATH'] = vim.env['PATH'] .. ':' .. nix:path("sops", "/bin")

function Scr:new()
    if _G.secrets then
        return _G.secrets -- Invoke global instance
    end
    local file = io.popen("sops decrypt " .. scr_path):read()
    local s = vim.json.decode(file)
    _G.secrets = s -- Global instance pinning
    return s
end

function Scr:fetch(entry)
    if not _G.secrets then
        return "" -- No secrets have been found
    end
    if self[entry] then
        return self[entry]
    else
        return ""
    end
end
