" Vim configuration startup file
" Author : David Blanchet

" Do not use mswin shortcuts and mouse behavior.
behave xterm
set selectmode=mouse

" Set a few options.
set nocompatible                    " Use Vim improvements over Vi
set backspace=indent,eol,start      " Go over indent, eol, whatever
set history=50                      " Keep 50 lines of command line history
set title                           " Show title in console title bar

set nostartofline                   " Avoid moving cursor to BOL when jumping
set ruler                           " Show the cursor position all the time
set showcmd                         " Display incomplete commands
set number                          " Shown line number
"set cursorline                      " A line indicate the cursor location
set showmatch                       " Briefly jump to balanced paren
set nowrap                          " Don't wrap text
set linebreak                       " Don't wrap text in the middle of a word
set autoindent                      " Always set autoindenting on
"set expandtab                       " Use spaces for autoindent/tab key
set shiftround                      " Rounds indent to shiftwidth
set colorcolumn=79                  " Show 79th column

set incsearch                       " Show incremental search
set hlsearch                        " Hilight search results
set ignorecase                      " Case insensitive searches,
set smartcase                       " Unless uppercase letters are used

set scrolloff=1                     " Keep a little context
set visualbell                      " No sound, use visual bell
set nobackup                        " No backup file
set tabstop=8                       " 8 cells for a real tab char
set softtabstop=4                   " Work with reduced tabs
set shiftwidth=4                    " Indent with reduced tabs
set smartindent                     " Smart indentation
set splitbelow                      " Split below current window
set ssop+=winpos,winsize,resize     " Nicer session restauration
set nrformats=hex                   " Exclude octal from CTRL-A / CTRL-X
set nojoinspaces                    " A single space when joining lines

set wildmenu                        " Menu completion in command mode on <Tab>
set wildmode=full                   " <Tab> cycles all matching choices.
set wildignore+=*.o,*.obj,.git,*.pyc
set wildignore+=eggs/**
set wildignore+=*.egg-info/**
set completeopt=menuone,longest,preview
set pumheight=6                     " Keep a small completion window

" Reading/Writing.
set noautowrite                     " Never write a file unless I request it
set noautowriteall                  " NEVER.
set noautoread                      " Don't automatically read changed files
set ffs=unix,dos,mac                " Try recognizing line endings.

" Messages, Info, Status.
set laststatus=2                    " allways show status line
set confirm                         " Prompt if closing with unsaved changes
set report=0                        " Commands always print changed line count
set shortmess+=a                    " Show modified/readonly/written.
set statusline=[%l,%v\ %P%M]\ %f\ %r%h%w\ (%{&ff})%=%1*%{fugitive#statusline()}%*

" Various global variables.
let Rq_Auteur = "David Blanchet <david.blanchet@free.fr>"
let Rq_Initiales = "DB"

" Load pathogen with docs for all plugins.
filetype off
call pathogen#infect()
" This one should not be unconditional,
" only when new bundles are installed.
"call pathogen#helptags()

" I want all those lovely colors!
syntax on
if has("gui_running")
    colorscheme morning
else
    colorscheme desert
endif
highlight User1 guifg=Yellow guibg=Black

" Let's go.
au BufRead,BufNewFile *.go set filetype=go
set rtp+=/usr/local/go/misc/vim

" Enable file type detection.
filetype on
filetype plugin indent on

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif

autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

autocmd FileType text setlocal textwidth=78

" Simple key mappings.
let mapleader=","             " change the leader to be a comma vs slash

" Do not outdent hashes.
inoremap # #

" Simplify french quotation marks insertion.
imap <> «  »<C-O>h

" Fast identation.
map <Tab> >>
map <S-Tab> <<

" Easier jump to tag on fr-latin1 keyboard.
nnoremap ù <C-]>
nnoremap gù g]

" Taglist mappings.
nnoremap <silent> <F8> :Tlist<CR>
nnoremap <silent> <F9> :TlistSync<CR>

nnoremap <F2> :split %.rq<CR>

" Open/close the quickfix window.
nnoremap <leader>c :copen<CR>
nnoremap <leader>cc :cclose<CR>

nnoremap <leader><space> :nohlsearch<cr>

" Set working directory
nnoremap <leader>. :lcd %:p:h<CR>

" Remove trailing whitespace on <leader>S.
nnoremap <leader>S :%s/\s\+$//<cr>:let @/=''<CR>

" Select the item in the list with enter.
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Clever completion key.
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>

" Open omni-completion menu closing previous if open
" and open new menu without changing the text.
inoremap <expr> <S-Space> (pumvisible() ? (col('.') > 1 ? '<Esc>i<Right>' : '<Esc>i') : '') .
            \ '<C-x><C-o><C-r>=pumvisible() ? "\<lt>C-n>\<lt>C-p>\<lt>Down>" : ""<CR>'

" Python.

au FileType python set omnifunc=pythoncomplete#Complete
au FileType python setlocal expandtab cinwords=if,elif,else,for,while,try,except,finally,def,class,with
au BufRead *.py set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m

" Add the virtualenv's site-packages to vim path.
py << EOF
import os.path
import sys
import vim
if 'VIRTUALENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    sys.path.insert(0, project_base_dir)
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))
EOF

" Load up virtualenv's vimrc if it exists
if filereadable($VIRTUAL_ENV . '/.vimrc')
    source $VIRTUAL_ENV/.vimrc
endif

" Use tab to scroll through autocomplete menus.
autocmd VimEnter * imap <expr> <Tab> pumvisible() ? "<C-N>" : "<Tab>"
autocmd VimEnter * imap <expr> <S-Tab> pumvisible() ? "<C-P>" : "<S-Tab>"

" Show preview window when using autocomplpop.
let g:acp_completeoptPreview=1

" Run Flake8.
autocmd FileType python map <buffer> <leader>8 :call Flake8()<CR>

" Open NerdTree.
map <leader>n :NERDTreeToggle<CR>

" Run command-t file search.
map <leader>f :CommandT<CR>

" Load the Gundo window
map <leader>g :GundoToggle<CR>

" Highligh trailing spaces as errors.
highlight ExtraWhitespace ctermbg=darkred guibg=red
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
" Prevent too much flashing.
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/

