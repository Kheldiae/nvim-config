--
-- DAP configurations, splitted from LSPs for ease of use and changes.
--

local dap = require 'dap'

-- Debug Adapter Protocol
dap.adapters.lldb = {
    type = 'executable',
    command = '/usr/bin/lldb-vscode',
    name = 'lldb'
}

-- C family
dap.configurations.cpp = {
    {
        name = 'Debug - Launch',
        type = 'lldb',
        request = 'launch',
        program = function()
            return vim.fn.input(
                'Path to executable: ',
                vim.fn.getcwd() .. '/',
                'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = true,
        args = {}
    },
    {
        name = 'Debug (Attach) - Remote',
        type = 'lldb',
        request = "attach",
        cwd = '${workspaceFolder}',
        stopOnEntry = true
    }
}
dap.configurations.c = dap.configurations.cpp

-- Rust
dap.configurations.rust = dap.configurations.cpp

-- Java
dap.configurations.java = {
    {
        type = 'java',
        request = 'attach',
        name = "Debug (Attach) - Remote",
        hostName = "127.0.0.1",
        port = 5005
    }
}

-- Python
require'dap-python'.setup('python')
