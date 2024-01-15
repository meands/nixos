''
colorscheme palenight

hi Normal ctermbg=NONE

let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='bubblegum'
let g:airline#extensions#tabline#buffer_nr_show = 1

set mouse=a
set clipboard=unnamedplus

set hidden

set shiftwidth=4

set tabstop=4
set softtabstop=4

set spelllang=en
set spellfile=$HOME/.config/vim/spell.en.utf-8.add

set conceallevel=1

let g:auto_save_events = ["InsertLeave", "TextChanged"]
let g:auto_save_silent = 0

" https://jeffkreeftmeijer.com/vim-number/
:set number

:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
:  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
:augroup END

autocmd TermOpen * startinsert

luafile ${./nvim.lua}

nmap ZA :cquit<Enter>
''