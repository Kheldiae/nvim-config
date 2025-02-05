" Jirac launcher script

if ! exists("g:configLoaded")
    " Do this only once before config is loaded
    runtime! jirac.vim.d/*.vim
    runtime! jirac.vim.d/*.lua

    let g:configLoaded = 1
endif
