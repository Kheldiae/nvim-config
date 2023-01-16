-- Broadcast snippets
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
local lsp  = require 'lspconfig'
local coq  = require 'coq'
local util = require 'lspconfig/util'
local tree = require 'nvim-tree'
local trouble = require 'trouble'
local vgit = require 'vgit'
local fwatch = require 'fwatch'
local vnotify = require 'notify'
local picker = require 'color-picker'
local sig = require 'lsp_signature'

vim.notify = function(msg, ...)
    if msg:match("warning: multiple different client offset_encodings")
    then
        return
    end

    vnotify(msg, ...)
end

---

local has_nix = false

local f = io.open('/nix')
if f then
    f:close()
    has_nix = true
end

local nixsh_fetch = {}

function nixsh(pkg, cmd)
    if has_nix and vim.call('executable', cmd:match("%S+")) == 0
    then                        -- Generate nix-shell wrapper
        table.insert(nixsh_fetch, pkg)
        return { "nix-shell", "-p", pkg, "--run", cmd }
    else
        local bits = {}         -- Split command argument for direct use
        for substring in cmd:gmatch("%S+") do
            table.insert(bits, substring)
        end
        return bits
    end
end


function _G.nixsh_prefetch()
    local op = {title="LSP Servers over Nix Shell"}
    if not has_nix then
        vim.notify("Auto-installing language servers requires Nix.", "error", op)
        return
    end
    local args = { "--run", "echo" }
    for key, value in pairs(nixsh_fetch) do
        table.insert(args, "-p")
        table.insert(args, value)
    end
    vim.notify("Prefetching language servers, hang tight...", "info", op)
    vim.loop.spawn("nix-shell", { args = args },
        function()
            vim.notify("Done!", "info", op)
        end)
end

-- Boost LSP using Coq_nvim
function lsp_with_coq(server, params)
    return server.setup(coq.lsp_ensure_capabilities(params))
end


-- Python 3
lsp_with_coq(lsp.jedi_language_server,
                                { cmd = nixsh("python3Packages.jedi-language-server", "jedi-language-server") })
-- Elm
lsp_with_coq(lsp.elmls,         { cmd = nixsh("elmPackages.elm-language-server", "elm-language-server") })
-- Rust
lsp_with_coq(lsp.rust_analyzer, { cmd = nixsh("rust-analyzer", "rust-analyzer") })
-- Haskell
lsp_with_coq(lsp.hls,           { cmd = nixsh("haskellPackages.haskell-language-server", "haskell-language-server --lsp")
                                , root_dir = function(fname)
                                    return util.find_git_ancestor(fname)
                                        or util.root_pattern("*.cabal", "stack.yaml", "package.yaml", "default.nix", "shell.nix")(fname)
                                  end
                                })
-- C/C++
lsp_with_coq(lsp.ccls,          { cmd = nixsh("ccls", "ccls") })
-- Java
lsp_with_coq(lsp.java_language_server,
                                { cmd = nixsh("java-language-server", "java-language-server")
                                , root_dir = util.root_pattern('build.gradle', 'build.gradle.kt', 'pom.xml', '.git', '.javals')
                                })
-- CMake
lsp_with_coq(lsp.cmake,         { cmd = nixsh("cmake-language-server", "cmake-language-server") })
-- Dhall
lsp_with_coq(lsp.dhall_lsp_server,
                                { cmd = nixsh("dhall-lsp-server", "dhall-lsp-server") })
-- OCaML
lsp_with_coq(lsp.ocamllsp,      { cmd = nixsh("ocamlPackages.ocaml-lsp", "ocamllsp") })
-- Vimscript
lsp_with_coq(lsp.vimls,         { cmd = nixsh("nodePackages.vim-language-server", "vim-language-server --stdio") })
-- PureScript
lsp_with_coq(lsp.purescriptls,  { cmd = nixsh("nodePackages.purescript-language-server", "purescript-language-server --stdio") })


vim.lsp.handlers['textDocument/codeAction']     = require'lsputil.codeAction'.code_action_handler
vim.lsp.handlers['textDocument/definition']     = require'lsputil.locations'.definition_handler
vim.lsp.handlers['textDocument/declaration']    = require'lsputil.locations'.declaration_handler
vim.lsp.handlers['textDocument/typeDefinition'] = require'lsputil.locations'.typeDefinition_handler
vim.lsp.handlers['textDocument/implementation'] = require'lsputil.locations'.implementation_handler
vim.lsp.handlers['textDocument/documentSymbol'] = require'lsputil.symbols'.document_handler
vim.lsp.handlers['workspace/symbol']            = require'lsputil.symbols'.workspace_handler

-- stfu
vim.lsp._unsupported_method = function(m) end


-- Nvim-Tree config
tree.setup {
    hijack_netrw = true,
    sync_root_with_cwd = true,

    diagnostics =
    { enable = true },

    renderer = {
        group_empty = true,
        indent_markers = { enable = true },
        icons = { show = { file = true, folder = true, folder_arrow = true, git = true } }
    },

    filters = {
        dotfiles = true,
        custom = { '.git', '.cache', 'build', '_secrets.yaml' }
    },

    git =
    { ignore = true, },

    view = {
        width = 30,
        side = 'left',
        adaptive_size = false
    }
}

-- Trouble diagnostics list config
trouble.setup {}

-- Visual Git integration
vgit.setup {}

-- Light/dark theme watch
fwatch.watch(os.getenv("XDG_RUNTIME_DIR") .. "/theme",
    { on_event = function()
                    vim.defer_fn(vim.fn.SetColor, 10)
                end
    })

-- Custom notification popups
vnotify.setup {
    background_colour="#000000"
}

-- Color picker
picker.setup {
    border = "rounded",
    keymap = { ["p"] = "<Plug>ColorPickerSlider5Increase",
               ["i"] = "<Plug>ColorPickerSlider5Decrease"
             }
}

-- Function signature auto-complete
sig.setup {
    bind = true,
    always_trigger = true,
    handler_opts = {
        border = "shadow"
    }
}
