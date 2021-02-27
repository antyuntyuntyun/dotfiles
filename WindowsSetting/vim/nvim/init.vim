set encoding=utf-8
set fileencodings=utf-8,cp932
set autoread
set paste

" row number
set number
" 行頭以外のtab表示幅
set tabstop=4
" 行頭でのtab表示幅
set shiftwidth=4
"set autoindent
set smartindent
syntax enable

set hlsearch
set incsearch
set ignorecase
set smartcase
set wrapscan

set smartindent
set wildmenu
""ファイル名表示
set statusline=%F
" 変更チェック表示
set statusline+=%m
" 読み込み専用かどうか表示
set statusline+=%r
" " ヘルプページなら[HELP]と表示
set statusline+=%h
" " プレビューウインドウなら[Preview]と表示
set statusline+=%w
" " これ以降は右寄せ表示
set statusline+=%=
" " file encoding
set statusline+=[enc=%{&fileencoding}]
" " 現在行数/全行数
set statusline+=[row=%l/%L]
" " 現在列数
set statusline+=[col=%c]
""ステータスラインを常に表示(0:表示しない、1:2つ以上ウィンドウがある時だけ表示)
set laststatus=2

inoremap( ()<LEFT>
inoremap" ""<LEFT>
inoremap' ''<LEFT>
inoremap[ []<LEFT>
inoremap{ {}<LEFT>
inoremap{ {}<LEFT>


" ------------------------------------------------------------
"  key bind
" ------------------------------------------------------------
" Normal Mode
cnoremap init :<C-u>edit $MYVIMRC<CR>                           " init.vim呼び出し
noremap <Space>s :source $MYVIMRC<CR>                           " init.vim読み込み
noremap <Space>w :<C-u>w<CR>                                    " ファイル保存

" Insert Mode
inoremap <silent> jj <ESC>:<C-u>w<CR>:" InsertMode抜けて保存
" Insert mode movekey bind
inoremap <C-d> <BS>
inoremap <C-h> <Left>
inoremap <C-l> <Right>
inoremap <C-k> <Up>
inoremap <C-j> <Down>

if &compatible
  set nocompatible
endif

" Add the dein installation directory into runtimepath
set runtimepath+=~/.vim/dein/repos/github.com/Shougo/dein.vim

if dein#load_state('~/.vim/dein')
  call dein#begin('~/.vim/dein')

  call dein#add('~/.vim/dein/repos/github.com/Shougo/dein.vim')
  call dein#add('Shougo/deoplete.nvim')
  if !has('nvim')
    call dein#add('roxma/nvim-yarp')
    call dein#add('roxma/vim-hug-neovim-rpc')
  endif

  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on