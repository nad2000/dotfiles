" vim: foldmethod=marker

" enter the current millenium
set nocompatible
set autoread
set encoding=utf-8
set ignorecase
set smartcase
" hybrid line number mode
set relativenumber
set number

"Switch between buffers without saving
set hidden

""" Disable arrow keys
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

"
"python with virtualenv support
py << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
  project_base_dir = os.environ['VIRTUAL_ENV']
  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
  execfile(activate_this, dict(__file__=activate_this))
EOF

filetype plugin on
filetype plugin indent on  " required
" https://github.com/junegunn/vim-plug
call plug#begin('~/.vim/plugged')

" General
Plug 'lucc/vim-tip'
Plug 'scrooloose/nerdtree'
Plug 'w0rp/ale'  " Syntax Checking
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer --gocode-completer' }
"Plug 'SirVer/ultisnips'
Plug 'tpope/vim-surround'
Plug 'fntlnz/atags.vim' " helps you creating and updating your tag files
Plug 'AndrewRadev/splitjoin.vim'  " gS - split; gJ - join
Plug 'christoomey/vim-tmux-navigator'
" Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary' " gc - toggle, gcap - comments out paragraph
" Plug 'ctrlpvim/ctrlp.vim' " active fork of 'kien/ctrlp.vim'
Plug 'jalvesaq/vimcmdline'
"Plug 'SirVer/ultisnips'
"Plug 'davidhalter/jedi-vim' " replaced with 'Valloric/YouCompleteMe'
"Plug 'msanders/snipmate.vim'
"Plug 'honza/vim-snippets'
"Plug 'mkitt/tabline.vim'
"Plug 'tpope/vim-markdown'
"Plug 'nelstrom/vim-markdown-folding'
"Plug 'bfredl/nvim-ipy' " :( doesn't support 4.x
"Plug 'ivanov/vim-ipython' " :( doesn't support 4.x
"Plug 'bling/vim-bufferline' " airline has buffer list feature
"Plug 'git://git.wincent.com/command-t.git'
"Plug 'benekastah/neomake'

" Themeing
Plug 'wikitopian/hardmode'  " disable arrow keys and other vim-smells
Plug 'jnurmine/Zenburn'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'majutsushi/tagbar' " provides an easy way to browse the tags of the current file and get an overview of its structure

" C
Plug 'vivien/vim-linux-coding-style'

" HTML
Plug 'alvan/vim-closetag'
Plug 'lepture/vim-jinja'  " Jinja2 template support

" JavaScript and stuff
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx' " React JSX support

" GO
Plug 'fatih/vim-go'

" Git
Plug 'airblade/vim-gitgutter'

" Python
Plug 'google/yapf', { 'rtp': 'plugins/vim', 'for': 'python' }
Plug 'integralist/vim-mypy'

" Rust..
Plug 'rust-lang/rust.vim'
Plug 'racer-rust/vim-racer'

" Generic
Plug 'editorconfig/editorconfig-vim'
call plug#end()            " required

let g:atags_build_commands_list = [
    \"[[ $PWD != $HOME ]] && ctags --exclude=$HOME --exclude='*.html' --exclude='*.js' --exclude='*.pxd' -R -f tags.tmp",
    \"[[ $PWD != $HOME ]] && awk 'length($0) < 400' tags.tmp > tags",
    \"[[ $PWD != $HOME ]] && rm tags.tmp"
    \]
let g:closetag_filenames = "*.html,*.xhtml,*.phtml" " for 'alvan/vim-closetag'

" Turn on powerline fonts:
"""let g:airline_powerline_fonts = 1
" Enable the list of buffers
"let g:airline#extensions#tabline#enabled = 1

" Style:
colorscheme zenburn
set nosmd " short for 'showmode'
syntax enable
set cursorline
set showmatch   " show mattching part of the pair for [] {} and ()

let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree
" Open NERDTree automatically when vim starts up if no files were specified:
autocmd vimenter * if !argc() | NERDTree | endif
" Give a shortcut key to NERD Tree
map <F2> :NERDTreeToggle<CR>
"Show hidden files in NerdTree
let NERDTreeShowHidden=1

" Folding ----------------------------------------------------------------- {{{
" from: https://bitbucket.org/sjl/dotfiles
"
set foldcolumn=3	" increases gutter width for folding indicator
set foldlevelstart=0

" Space to toggle folds.
nnoremap <Space> za
vnoremap <Space> za

" Make zO recursively open whatever top level fold we're in, no matter where the
" cursor happens to be.
nnoremap zO zCzO

" "Focus" the current line.  Basically:
"
" 1. Close all folds.
" 2. Open just the folds containing the current line.
" 3. Move the line to a little bit (15 lines) above the center of the screen.
" 4. Pulse the cursor line.  My eyes are bad.
"
" This mapping wipes out the z mark, which I never use.
"
" I use :sus for the rare times I want to actually background Vim.
nnoremap <c-z> mzzMzvzz15<c-e>`z:Pulse<cr>

function! MyFoldText() " {{{
    let line = getline(v:foldstart)

    let nucolwidth = &fdc + &number * &numberwidth
    let windowwidth = winwidth(0) - nucolwidth - 3
    let foldedlinecount = v:foldend - v:foldstart

    " expand tabs into spaces
    let onetab = strpart('          ', 0, &tabstop)
    let line = substitute(line, '\t', onetab, 'g')

    let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
    let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
    return line . '…' . repeat(" ",fillcharcount) . foldedlinecount . '…' . ' '
endfunction " }}}
set foldtext=MyFoldText()

" }}}

" Tab settings:
"
" autoindent - indent when moving to the next line while writing code
" expandtab - expand tabs into spaces
" shiftwidth=n - when using the >> or << commands, shift lines by n spaces
augroup FileTypes
  au!
  au BufNewFile,BufRead *.html,*.htm,*.shtml,*.stm set ft=jinja
  au BufWritePre *.py,*.c,*.php,*.html :%s/ \+$//ge
  au BufWritePost * call atags#generate()
  au FileType html setl sw=2 sts=2 et
  au FileType jinja setl sw=2 sts=2 et
  au Filetype python set ts=8 sts=4 sw=4 sr et ai | iabbrev <buffer> iff if:<esc>i
  au Filetype python nnoremap <LocalLeader>i :!isort %<CR><CR>  " Import re-sorting (https://github.com/timothycrosley/isort)
  au FileType python nnoremap <LocalLeader>= :0,$!yapf<CR>  " Code formating with YAPF (https://github.com/google/yapf)
  au FileType python map <C-Y> :call yapf#YAPF()<cr>
  au FileType python imap <C-Y> <c-o>:call yapf#YAPF()<cr>
  au FileType python let g:ale_linters = {'python': ['flake8']}
  au FileType javascript setlocal sw=2 | iabbrev <buffer> iff if ()<esc>i
  au Filetype sh set ts=8 sts=2 sw=2 sr et ai nowrap
  au Filetype vim set ts=8 sts=2 sw=2 sr et ai nowrap
  au Filetype go set ts=4 sts=4 sw=4 sr noet
  au FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
  au FileType go nmap <Leader>r <Plug>(go-run)
  au FileType go nmap <Leader>b <Plug>(go-build)
  au FileType go nmap <Leader>t <Plug>(go-test)
  au FileType go nmap <Leader>c <Plug>(go-coverage)
  au FileType go nmap <Leader>gb <Plug>(go-doc-browser)
  au FileType go nmap <Leader>s <Plug>(go-implements)
  au FileType go nmap <Leader>i <Plug>(go-info)
augroup END

" Jump to the last cursor position in the file:
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

nmap <F8> :TagbarToggle<CR>

" Leaders:
let mapleader = ","
let maplocalleader = "\\"

" Remember the last open terminal buffer ID:
augroup Terminal
  au!
  au TermOpen * let g:last_terminal_job_id = b:terminal_job_id
augroup END

function! REPLSend(lines)
  call jobsend(g:last_terminal_job_id, add(a:lines, ''))
endfunction

command! REPLSendLine call REPLSend([getline('.')])
command! REPLSendSelectedLines call REPLSend(getline("'<", "'>" ))

nnoremap <Silent> <F6> :REPLSendLine<cr>
vnoremap <Silent> <F5> :REPLSendSelectedLines<cr>


nnoremap <Leader>- ddp
nnoremap <Leader>_ ddkP
inoremap <Leader><C-U> <ESC>viwUi
nnoremap <Leader><C-U> viwU

iabbrev adn and
iabbrev waht what
iabbrev tehn then
iabbrev @@  nad2000@gmail.com
iabbrev ccopy Copyright 2017 Rad Cirskis, all rights reserved.
iabbrev ssig -- <cr>Rad Cirskis<cr>nad2000@gmail.com

" Golang support (vim-go):
let g:go_fmt_command = "goimports"
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_build_constraints = 1
"let g:go_fmt_fail_silently = 1
let g:go_fmt_autosave = 1


" Disable mouse (for clipboard support install xsel and/or xclip)
set mouse=cn

" Why YCM is so user unfiendly:
let g:ycm_confirm_extra_conf = 0

" Cipboard for all operations 
"" set clipboard+=unnamedplus  " better to user '*' or '+' register

" CTRL-S for saveing:
noremap <silent> <C-S>          :update<CR>
vnoremap <silent> <C-S>         <C-C>:update<CR>
inoremap <silent> <C-S>         <C-O>:update<CR>
function! PLAY()
  normal /mysql
endfunction
