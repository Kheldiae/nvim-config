--
-- Secrecy module, fetches secrets from system service.
--

require 'nix'

Secrets = {}

local nix = Nix:new() -- TODO find sops path

function Secrets:new()
    if _G.secrets then
        return _G.secrets -- Invoke global instance
    end
    -- TODO fetch secrets file
    -- TODO find sops use
    return {}
end

-- TODO fetch function
