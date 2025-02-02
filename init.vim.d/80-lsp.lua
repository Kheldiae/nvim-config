--
-- Language servers config, please look 81-dap.lua for debug adapters configs.
--

require 'nix'

local nix = Nix:new()
local pscan = require 'plenary.scandir'
local path = require 'plenary.path'

---

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local lsp = require 'lspconfig'
local util = require 'lspconfig/util'
local jdtls = require 'jdtls'
local coq = require 'coq'
local coql = require 'coq-lsp'
local fwatch = require 'fwatch'


-- Boost LSP using Coq_nvim
function lsp_with_coq(server, params)
    return server.setup(coq.lsp_ensure_capabilities(params))
end

local lsp_cmake_sessions = {}

-- Automatically set up CMake compile_commands.json
function setupCmakeIntegration()
    local op = { title = "CMake build lists integration" }
    local ppr = util.root_pattern('.ccls', '.git')(vim.fn.expand('%:p'))
    local bdir = "!!INVALID!!"
    local mybuf = vim.api.nvim_get_current_buf()

    if ppr == nil then
        return ""
    elseif lsp_cmake_sessions[ppr] ~= nil then
        return lsp_cmake_sessions[ppr]
    elseif path.new(ppr .. "/CMakeLists.txt"):exists() then
        cmls = pscan.scan_dir(ppr, {
            respect_gitignore = true,
            add_dirs = false,
            search_pattern = "CMakeLists.txt"
        })
        bdrs = pscan.scan_dir(ppr, {
            respect_gitignore = false,
            add_dirs = false,
            search_pattern = "CMakeCache.txt"
        })
        if bdrs[1] == nil then
            bdir = io.popen("mktemp -d --suffix=.cmake"):read()
        else
            bdir = bdrs[1]
            bdir = bdir:match("(.*/)")
        end

        local cmakecmd = "2>&1 >" .. bdir .. "/cmake.log " ..
            "cmake -B " .. bdir ..
            " -DCMAKE_EXPORT_COMPILE_COMMANDS=ON " .. ppr

        for _, el in pairs(cmls) do
            fwatch.watch(el, {
                on_event = function()
                    -- rebuild CMake then restart ccls
                    io.popen(cmakecmd)
                    vim.notify("Reloaded compile commands, restarting LSP...", "info", op)
                    vim.schedule(function()
                        lsp["ccls"].launch(mybuf)
                    end)
                end
            })
        end
        -- perform first CMake build
        io.popen(cmakecmd)
        lsp_cmake_sessions[ppr] = bdir
        return bdir
    else
        lsp_cmake_sessions[ppr] = ppr
        return ppr
    end
end

-- Python 3
lsp_with_coq(lsp.pylsp, {
    cmd = nix:shell("python3Packages.python-lsp-server", { "pylsp" })
})

-- Elm
lsp_with_coq(lsp.elmls, {
    cmd = nix:shell("elmPackages.elm-language-server", {
        "elm-language-server"
    })
})

-- Workaround for Rust LSP
for _, method in ipairs({
    'textDocument/diagnostic', 'workspace/diagnostic' }) do
    local default_handler = vim.lsp.handlers[method]
    vim.lsp.handlers[method] = function(err, result, context, config)
        if err ~= nil and err.code == -32802 then
            return -- stfu
        end
        return default_handler(err, result, context, config)
    end
end

-- Rust
lsp_with_coq(lsp.rust_analyzer, {
    cmd = nix:shell("rust-analyzer", { "rust-analyzer" }),
})

-- Haskell
lsp_with_coq(lsp.hls, {
    cmd = nix:shell("haskell-language-server", {
        "haskell-language-server-wrapper", "--lsp"
    }),
    root_dir = function(fname)
        return util.find_git_ancestor(fname)
            or util.root_pattern("*.cabal", "stack.yaml", "package.yaml", "default.nix", "shell.nix")(fname)
    end
})

-- C/C++
lsp_with_coq(lsp.ccls, {
    cmd = nix:shell("ccls", { "ccls" }),
    init_options = {
        highlight = { lsRanges = true },
        compilationDatabaseDirectory = setupCmakeIntegration()
    },
    filetypes = {
        "c", "cpp", "objc", "objcpp",
        "cuda", "c.doxygen", "cpp.doxygen", "cuda.doxygen"
    }
})
-- CMake
lsp_with_coq(lsp.cmake, {
    cmd = nix:shell("cmake-language-server", { "cmake-language-server" })
})

-- JSonnet
lsp_with_coq(lsp.jsonnet_ls, {
    cmd = nix:shell("jsonnet-language-server", { "jsonnet-language-server" })
})

-- OCaML
lsp_with_coq(lsp.ocamllsp, {
    cmd = nix:shell("ocamlPackages.ocaml-lsp", { "ocamllsp" }),
    cmd_env = { OCAMLLSP_SEMANTIC_HIGHLIGHTING = "full/delta" }
})

-- Vimscript
lsp_with_coq(lsp.vimls, {
    cmd = nix:shell("nodePackages.vim-language-server", {
        "vim-language-server", "--stdio"
    })
})

-- PureScript
lsp_with_coq(lsp.purescriptls, {
    cmd = nix:shell("nodePackages.purescript-language-server", {
        "purescript-language-server", "--stdio"
    })
})

-- Shell
lsp_with_coq(lsp.bashls, {
    cmd = nix:shell("bash-language-server", {
        "bash-language-server", "start"
    }),
    filetypes = { "bash", "sh", "zsh" }
})

-- Nix
lsp_with_coq(lsp.nixd, { cmd = nix:shell("nixd", { "nixd" }) })

-- LaTeX
lsp_with_coq(lsp.texlab, { cmd = nix:shell("texlab", { "texlab" }) })

-- Javascript and TypeScript
lsp_with_coq(lsp.ts_ls, {
    cmd = nix:shell("nodePackages.typescript-language-server", {
        "typescript-language-server", "--stdio"
    })
})

-- CSS
lsp_with_coq(lsp.cssls, {
    cmd = nix:shell("nodePackages.vscode-langservers-extracted", {
        "vscode-css-language-server", "--stdio"
    })
})

-- HTML
lsp_with_coq(lsp.html, {
    cmd = nix:shell("nodePackages.vscode-langservers-extracted", {
        "vscode-html-language-server", "--stdio"
    })
})

-- PHP support
lsp_with_coq(lsp.phpactor, {
    cmd = nix:shell("phpactor", { "phpactor", "language-server" })
})

-- Eslint
lsp_with_coq(lsp.eslint, {
    cmd = nix:shell("nodePackages.vscode-langservers-extracted", {
        "vscode-eslint-language-server", "--stdio"
    }),
    filetypes = {
        "javascript", "javascriptreact", "javascript.jsx",
        "typescript", "typescriptreact", "typescript.tsx"
    },
    root_dir = util.root_pattern('.git', '.estls'),
    settings = {
        codeAction = { showDocumentation = { enable = true } },
        format = true,
        useESLintClass = false,
        workingDirectory = { mode = "location" },
        run = "onType"
    }
})

-- Swagger LSP integration
lsp_with_coq(lsp.spectral, {
    cmd = nix:shell("spectral-language-server", {
        "spectral-language-server", "--stdio"
    }),
    filetypes = { "json", "yml", "yaml" },
    settings = {
        enable = true,
        run = "onType",
        validateLanguages = { "yaml", "json", "yml" }
    }
})

-- Marksman knowledge base
lsp_with_coq(lsp.marksman, {
    cmd = nix:shell("marksman", { "marksman", "server" }),
    filetypes = { "markdown", "markdown.mdx", "pandoc" }
})

-- Java
lsp_with_coq(lsp.jdtls, {
    cmd = nix:shell("jdt-language-server", {
        "jdtls", "-configuration",
        os.getenv("HOME") .. "/.cache/jdtls/config", "-data",
        os.getenv("HOME") .. "/.cache/jdtls/workspace",
        "-Dlog.level=ERROR >&2 /dev/null"
    }),
    filetypes = { "java" },
    cmd_env = { GRADLE_HOME = os.getenv("GRADLE_HOME") },
    root_dir = util.root_pattern('build.gradle', 'pom.xml', '.git', '.jdtls'),
    init_options = {
        bundles = {
            nix:path("vscode-extensions.vscjava.vscode-java-debug",
                "/share/vscode/extensions/vscjava.vscode-java-debug/server/com.microsoft.java.debug.plugin-0.44.0.jar")
        }
    },
    handlers = {
        ['$/progress'] = function(_, _, _)
            -- Nothing here, it's just to capture jdtls useless logs
            -- Just treat this handler as another stfu handler
        end,
        ['language/status'] = function(_, _, _) end,
        ['window/logMessage'] = function(_, _, _) end
    },
    on_attach = function(_, _)
        jdtls.setup_dap({ hotcodereplace = 'auto' })
    end
})

-- Kotlin
lsp_with_coq(lsp.kotlin_language_server, {
    cmd = nix:shell("kotlin-language-server", { "kotlin-language-server" }),
    root_dir = util.root_pattern('build.gradle.kts', '.ktls')
})

-- Coq (the theorem language)
coql.setup {
    lsp = {
        cmd = nix:shell("coqPackages_8_16.coq-lsp", { "coq-lsp" }),
        init_options = {
            show_notices_as_diagnostics = true
        }
    }
}

-- DOT graph language server
vim.api.nvim_create_autocmd({ "BufEnter" }, {
    pattern = { "*.dot" },
    callback = function()
        vim.lsp.start({
            name = "dot",
            cmd = nix:shell("dot-language-server", {
                "dot-language-server", "--stdio"
            })
        })
    end
})

-- Lua language server
lsp_with_coq(lsp.lua_ls, {
    cmd = nix:shell("lua-language-server", { "lua-language-server" })
})

-- Postgres language server
lsp_with_coq(lsp.postgres_lsp, {
    cmd = nix:shell("postgres-lsp", { "postgres_lsp" })
})

-- Dockerfile language server
lsp_with_coq(lsp.dockerls, {
    cmd = nix:shell("dockerfile-language-server-nodejs", {
        "docker-langserver", "--stdio"
    })
})

-- Docker-compose support
lsp_with_coq(lsp.docker_compose_language_service, {
    cmd = nix:shell("docker-compose-language-service", {
        "docker-compose-langserver", "--stdio"
    })
})

-- Third-party Coq (the completion engine) providers
require 'coq_3p' {
    { src = "ultisnips", short_name = "US" },
    { src = "repl",
        sh = "zsh",
        max_lines = 99,
        deadline = 500,
        unsafe = { "rm", "poweroff", "shutdown", "mv", "sudo" }
    },
    { src = "nvimlua",
        short_name = "nLUA",
        conf_only = true
    },
    { src = "bc",        short_name = "MATH", precision = 6 },
    { src = "dap",       short_name = "DBG" }
}

-- Fancy lsputil popups
vim.lsp.handlers['textDocument/codeAction']     = require 'lsputil.codeAction'.code_action_handler
vim.lsp.handlers['textDocument/definition']     = require 'lsputil.locations'.definition_handler
vim.lsp.handlers['textDocument/declaration']    = require 'lsputil.locations'.declaration_handler
vim.lsp.handlers['textDocument/typeDefinition'] = require 'lsputil.locations'.typeDefinition_handler
vim.lsp.handlers['textDocument/implementation'] = require 'lsputil.locations'.implementation_handler
vim.lsp.handlers['textDocument/documentSymbol'] = require 'lsputil.symbols'.document_handler
vim.lsp.handlers['workspace/symbol']            = require 'lsputil.symbols'.workspace_handler

-- stfu
vim.lsp._unsupported_method                     = function(_) end
