set title

filetype plugin on
syntax on
set mouse= " No more mouse
set number
set linebreak
set breakindent
set breakindentopt=shift:2

set autoread

" Fold shennanigans, we don't want them by default
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldlevel=99
set conceallevel=3

set completeopt-=preview

set list
set listchars=tab:⇥\ ,trail:␣,nbsp:⍽

set fillchars=eob:\ ,vert:▎,fold:,foldclose:,foldopen:,foldsep:░
