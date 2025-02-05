if v:progname == "goyo" || exists("g:startgoyo")
    runtime! goyo.vim
elseif v:progname == "jirac" || exists("g:startjirac")
    runtime! jirac.vim
elseif ! exists("g:configLoaded")
    set guifont="Fira Code:h10"

    " Note: The line below loads all files in the "init.vim.d" directory.
    runtime! init.vim.d/*.vim
    runtime! init.vim.d/*.lua

    let g:configLoaded = 1
endif
