if v:progname == "goyo" || exists("g:startGoyo")
    runtime! goyo.vim
elseif ! exists("g:configLoaded")
    set guifont="Fira Code:h10"

    " Note: The line below loads all files in the "init.vim.d" directory.
    runtime! init.vim.d/*.vim
    runtime! init.vim.d/*.lua

    let g:configLoaded = 1
endif
