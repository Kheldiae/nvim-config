set nofoldenable
set nolist

" Enable Coq completion engine
let g:coq_settings = { 'auto_start': 'shut-up' }

" Updated colorscheme
function SetGoyoColor()
    hi Normal       guibg=NONE ctermbg=NONE
    hi StatusLine   guibg=NONE ctermbg=NONE
    hi StatusLineNC guibg=NONE ctermbg=NONE
    hi VertSplit    guibg=NONE ctermbg=NONE

    silent! sh -c 'sleep 4; kitty @ set-background-opacity 1'

    " Noice modifications to read cmdline better
    hi NoiceCmdlinePopupBorder  guifg=#c0b194
    hi NoiceCmdlinePopupTitle   guifg=#c0b194
    hi NoiceCmdlineIcon         guifg=#918154
endfunction

call SetGoyoColor()

" set limelight conceal
let g:limelight_conceal_ctermfg=0xa

" Make goyo a bit wider
let g:goyo_width=100

let g:startify_disable_at_vimenter=1

let g:copilot_enabled = 0

autocmd vimenter * Goyo
autocmd vimenter * set nospell
