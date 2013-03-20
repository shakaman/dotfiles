" Options globales {{{

syntax on       " active la coloration syntaxique
filetype on
filetype indent on
filetype plugin on
set number

set guioptions-=L " remove tree scrollbar
set guioptions-=r " remove contet scrollbar
set guioptions-=T " remove toolbar
set guioptions-=m " remove toobar

set foldenable
set foldmethod=indent
set foldnestmax=5
set foldlevel=1

set ai          " indente automatiquement
set bs=2        " tout supprimer avec backspace
set dir-=.      " ne pas mettre de fichiers temporaires dans le répertoire courant
set ek          " utiliser les touches fléchées en mode insertion
set ff=unix     " fin de ligne au format UNIX
set is          " recherche incrémentale
set ls=2        " avoir en permanence la barre de status
set lz          " ne pas rafraîchir l'écran pendant une macro
set magic       " utiliser les motifs magiques dans les expressions rationnelles
set mouse=h     " n'utiliser la souris que dans l'aide
set noea        " ne pas redimensionner automatiquement les vues après un découpage
set nocp        " ne limite pas Vim aux fonctionnalités de VI
set noet        " ne pas transformer les tabs en spaces
set nohls       " ne pas mettre en surbrillance les termes recherchés
set noic        " tenir compte de la casse lors des recherches
set nojs        " pas 2 espaces après '.', '?' et '!' pour la commande J(oin)
set noml        " pas de modelines (trou de sécu dans les anciennes versions de Vim)
set nows        " ne pas retourner au début du fichier lorsqu'une recherche atteint la fin du fichier
set pt=<F11>    " pour coller du code sans avoir une double indentation (celle de départ + celle de Vim)
set si          " indentation intelligente (enfin presque)
set ruler       " affiche la position du curseur dans la barre d'état
set so=3        " toujours afficher au moins 3 lignes au-dessus et en dessous du curseur
set siso=2      " toujours afficher au moins 2 caractères à coté du curseur
set sm          " Afficher la parenthèse correspondante
set sw=4        " les tabulations s'arrêtent toujours sur une colonne multiple de 4
set ts=2        " les tabulations font 2 caractères (à l'affichage)
set tw=0        " ne pas couper les lignes
set title       " affiche le nom du fichier dans la barre de titre du term
set ve=block
set nowrap      " ne pas afficher sur plusieurs lignes les lignes trop longues
set nospell     " pas de correction orthographique par défaut
set spl=fr,en   " utiliser le français et l'anglais pour la correction orthographique
set sps=best,10 " afficher seulement les 10 meilleures propositions pour la correction orthographique
set spf=~/.vim/spell/perso.add " dictionnaire supplémentaire pour la correction orthographique
set tags+=../tags
set shell=/bin/bash
set wildmenu
set wildignore+=*.o,*.so,*.a,.svn
" set ballooneval
set omnifunc=syntaxcomplete#Complete
set cot=menuone
" set encoding=latin-1
" set fileencoding=latin-1
set encoding=utf8
set termencoding=macroman
set fileencoding=utf8
set colorcolumn=80

set mouse=a
set guifont=Monospace\ 8

set list listchars=tab:❘-,trail:·,extends:»,precedes:«,nbsp:×

autocmd FileType ruby      setlocal ts=2 sts=2 sw=2 expandtab

" }}}
" Mappings {{{

nmap <F1> K
map <F2> <C-T>
map <F3> <C-]>
nmap <F4> :silent make<CR>:cw<CR>
nmap <F5> :cp<CR>
nmap <F6> :cn<CR>
nmap <F7> :AV<CR>
" nmap <F8> :AS<CR>
nmap <F8> :set spell!<CR>

" Don't make a # force column zero.
inoremap # X<BS>#

" Control + touches fléchées pour naviguer entre les vues
noremap <C-Up> <C-W><Up>
noremap <C-Down> <C-W><Down>
noremap <C-Right> <C-W><Right>
noremap <C-Left> <C-W><Left>

" Shift + touches fléchées pour naviger entre les tabs
noremap <S-Left> :tabprev<CR>
noremap <S-Right> :tabnext<CR>
noremap <S-Up> :tabnew<CR>

" Complétion
inoremap <C-@> <C-P>

" exporter en html
let html_use_css = 1
let use_xhtml = 1
map <F12> :runtime! syntax/2html.vim<CR>

let maplocalleader=','
let mapleader=','
map <C-c> ,ci<CR>


" }}}
" Autodetect filetypes {{{ "

au BufRead,BufNewFile bip.conf set ft=bip
au BufRead,BufNewFile arpalert.conf set ft=arpalert
au BufRead,BufNewFile haproxy.cfg set ft=haproxy
au BufRead,BufNewFile *.dc  set ft=dotclear
au BufRead,BufNewFile *.wiki  set ft=moin
au BufRead,BufNewFile README,INSTALL,ChangeLog set ft=txt
au BufRead,BufNewFile *.t2t set ft=txt2tags
au BufRead,BufNewFile *.tmpl,*.html,*.send,*.ok,*.form,*.visu,*.txt
    \ if (version < 700) |
	\     set ft=templeet |
	\ elseif (getline(2) =~? "^<rss ") |
    \     set ft=xml.templeet |
    \ else |
    \     set ft=html.templeet nospell |
    \ endif
au BufRead,BufNewFile ~/.vim/doc/*.txt set ft=help nospell


" }}}
" Plugins {{{ "

" Alternate :
" http://www.vim.org/scripts/script.php?script_id=31
let g:alternateSearchPath = '../src,../include'
let g:alternateNoDefaultAlternate = 1

" LoadHeader :
set path+=include,src
set path+=**
nmap <F9>  :call LoadHeader(getline("."),0)<cr>
nmap <F10> :call LoadHeader(getline("."),1)<cr>

" Increment Column :
" vnoremap <c-a> :call IncrementColumn()<cr>

" Doxygen
let g:load_doxygen_syntax = 1

" SuperTab
" http://www.vim.org/scripts/script.php?script_id=182
let g:SuperTabRetainCompletionType = 2
let g:SuperTabDefaultCompletionType = "<C-P>"

" Molokai theme "
colorscheme molokai
let g:molokai_original = 1

" Solarized theme
"colorscheme solarized
set background=dark
let g:solarized_termcolors=256

"CSApprox plugin "
"let g:CSApprox_loaded = 1
" }}}
" Autres {{{ "

"		views-selector	: '.change-views',
" Abréviations
" source $HOME/.vim/abbrev.vim

" Commentaires
" vmap / :s#^#//\ #<CR>gv:s#^//\ //\ ##<CR>
" vmap # :s/^/#\ /<CR>gv:s/^#\ #\ //<CR>


" Tags
" set tags+=../tags


" }}}
set tabstop=2               " a tabulation is shown a 4 'spaces'
set shiftwidth=2            " number of spaces for each (auto)indent
set backspace=2             " backspace over eol/start/indent
set expandtab               " fill tabs with spaces (holy-war inside)
set softtabstop=2           " a tab = 4 spaces most of the time

" Pathogen
set wildignore+=*.swp,*.swo,.git,.svn,front/**,tmp/**
call pathogen#infect()
nmap <silent> <C-F> :CommandT<CR>
nmap <silent> <C-B> :CommandTBuffer<CR>
let g:CommandTMaxFiles=20000
let g:CommandTMaxDepth=40
let g:CommandTMatchWindowAtTop=0
let g:CommandTMaxHeight=20
let g:CommandTAcceptSelectionMap='<CR>'
let g:CommandTAcceptSelectionTabMap='<C-t>'
let g:CommandTAcceptSelectionSplitMap='<C-s>'
let g:CommandTAcceptSelectionVSplitMap='<C-v>'

autocmd FileType python setlocal ts=2 sw=2 noexpandtab
autocmd FileType haml setlocal cursorcolumn cursorline
autocmd FileType sass setlocal cursorcolumn cursorline
autocmd FileType jade setloca cursorcolumn cursorline
autocmd FileType arduino setloca cursorcolumn cursorline

au BufNewFile,BUfRead *.ino set filetype=arduino
