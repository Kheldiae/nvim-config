" Set leader to bang
let mapleader = "!"

" Buffer navigation (in BarBar)
nnoremap <silent> bn                    :BufferNext<CR>
nnoremap <silent> bv                    :BufferPrevious<CR>
nnoremap <silent> mbn                   :BufferMoveNext<CR>
nnoremap <silent> mbv                   :BufferMovePrevious<CR>
nnoremap <silent> bd                    :BufferClose<CR>

nnoremap <silent> ty                    :tabnext<CR>
nnoremap <silent> tr                    :tabprev<CR>
nnoremap <silent> tn                    :tabnew<CR>

" stfu keybinds
nnoremap <silent> n                     <CR>
nnoremap <silent> <leader>q             :lua require"notify".dismiss()<CR>

nnoremap <silent> <leader>la            :set nornu<CR>
nnoremap <silent> <leader>lr            :set rnu<CR>

" Colorimetrics keybinds
nnoremap <silent> <leader>op            :PickColor<CR>

" LSP and code helping keybinds
nnoremap <silent> <leader>cD            :lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> <leader>cd            :lua vim.lsp.buf.definition()<CR>
nnoremap <silent> µ                     :lua vim.lsp.buf.references()<CR>
nnoremap <silent> <leader>ci            :lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> ?                     :lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <leader>?             :CodeActionMenu<CR>
nnoremap <silent> <leader>mv            :lua vim.lsp.buf.rename()<CR>
nnoremap <silent> <leader>c<left>       :lua vim.lsp.buf.incoming_calls()<CR>
nnoremap <silent> <leader>c<right>      :lua vim.lsp.buf.outgoing_calls()<CR>
nnoremap <silent> <leader>cf            :lua vim.lsp.buf.format()<CR>
nnoremap <silent> <leader>yp            :!yapf -i %<CR>
nnoremap <silent> <leader>!             :Trouble diagnostics toggle<CR>

nnoremap <silent> <leader>tt            :Vista<CR>

" Nvim filetree
nnoremap <silent> <leader>fr            :NvimTreeRefresh<CR>
nnoremap <silent> <leader>ft            :NvimTreeToggle<CR>

nnoremap <silent> <leader>td            :Ags TODO<CR>

" Sourcetrail helpers
nnoremap <silent> <leader>strt          :SourcetrailStartServer<CR>
nnoremap <silent> <leader>satk          :SourcetrailActivateToken<CR>
nnoremap <silent> <leader>stfr          :SourcetrailRefresh<CR>

nnoremap <silent> <leader>hw            :Http<CR>

" Debugger adapters
nnoremap <silent> <leader>db            :lua require"dap".toggle_breakpoint()<CR>
nnoremap <silent> <leader>dc            :lua require"dap".continue()<CR>
nnoremap <silent> <leader>dn            :lua require"dap".step_over()<CR>
nnoremap <silent> <leader>ds            :lua require"dap".step_into()<CR>
nnoremap <silent> <leader>dF            :lua require"dap.ui.widgets".centered_float(require"dap.ui.widgets".frames)<CR>
nnoremap <silent> <leader>dS            :lua require"dap.ui.widgets".centered_float(require"dap.ui.widgets".scopes)<CR>
nnoremap <silent> <leader>d?            :lua require"dap.ui.widgets".hover()<CR>

" Git keybinds
nnoremap <silent> <leader>go            :GitConflictChooseOurs<CR>
nnoremap <silent> <leader>gt            :GitConflictChooseTheirs<CR>
nnoremap <silent> <leader>gn            :GitConflictChooseNone<CR>
nnoremap <silent> <leader>gb            :GitConflictChooseBoth<CR>

" Moving between opened buffers
nnoremap <leader><left> <C-W><C-H>
nnoremap <leader><right> <C-W><C-L>
nnoremap <leader><up> <C-W><C-K>
nnoremap <leader><down> <C-W><C-J>

" Little hack to escape insertion mode
inoremap jk <ESC>
tnoremap jk <C-\><C-n>
