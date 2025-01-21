" Enable Coq completion engine
let g:coq_settings = { 'auto_start': 'shut-up' }

" Disable Coqtail to let coq-lsp work
let g:loaded_coqtail = 1
let g:coqtail#supported = 0

let g:csv_autocmd_arrange=1

" Tell BarBar to wait for Lua setup
let g:barbar_auto_setup=0

" Tell Vista to use LSP by default
let g:vista_default_executive='nvim_lsp'

" Deoplete preview
let g:float_preview#docked = 0

" DevIcons settings
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:DevIconsEnableFoldersOpenClose = 1
let g:DevIconsEnableNERDTreeRedraw = 0

" Find our runtime dir to obtain our flake lock
let config_root = split(&runtimepath, ',')[0]

" GitHub Copilot Node command
if isdirectory('/nix')
    let g:copilot_node_command = ['nix', '--extra-experimental-features', 'nix-command flakes', 'run', config_root . '#nodejs', '--']
endif

" Disable Copilot by default
let g:copilot_enabled = 0

" Set PList editor settings
let g:plist_display_format = 'json'

" Disable Unicode conceal from PureScript syntax
let g:purescript_unicode_conceal_enable = 0

" Enable semantic highlight on Doxygen files as well
let g:lsp_cxx_hl_ft_whitelist = ['c', 'cpp', 'objc', 'objcpp', 'cc', 'cuda', 'c.doxygen', 'cpp.doxygen', 'cuda.doxygen' ]

" Fix for idiotic VGit "optimization"
set signcolumn=yes

" Manually invoke Startify when auto-tree on empty buffer
function StartAndTree()
    if !argc()
        Startify
    endif
    NvimTreeOpen
    wincmd w
endfunction

autocmd VimEnter *
    \ if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
    \ |   PlugInstall --sync | q
    \ | endif

" Small windows don't need NvimTree
" Also don't open NvimTree in kitty-scrollback.nvim
if &columns > 100 && $KITTY_SCROLLBACK_NVIM == ''
    autocmd VimEnter *
        \ call StartAndTree()
    autocmd BufEnter *
        \ ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr()
        \ |   quit
        \ | endif
endif

" Remove numbers column in terminals
autocmd TermOpen * setlocal nonumber signcolumn=no

" Comfort settings
autocmd VimEnter * set nospell
autocmd VimEnter * set nofoldenable

" EPUB support
let g:VimEPUB_EPUB_Version = "2,3"
