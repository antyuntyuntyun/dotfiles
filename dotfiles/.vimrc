colorscheme jellybeans

set encoding=utf-8
set fileencodings=utf-8,cp932
set autoread
" set paste
" set paste しているとinoremapが効かないのでコメントアウト

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
set history=5000
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
" 不可視文字を可視化(タブが「▸-」と表示される)
set list listchars=tab:\▸\-
" 行末の1文字先までカーソルを移動できるように
set virtualedit=onemore
" 記号表記で崩れないようにする
set ambiwidth=double


" undo 永続化
" mkdir -p ~/.vim/undo
if has('persistent_undo')
  set undodir=~/.vim/undo
  set undofile
endif

inoremap ( ()<LEFT>
inoremap " ""<LEFT>
inoremap ' ''<LEFT>
inoremap [ []<LEFT>
inoremap { {}<LEFT>
inoremap { {}<LEFT>
inoremap < <><LEFT>

inoremap {<Enter> {}<Left><CR><CR><BS><Up><Right>

" To use fzf in Vim, add the following line to your .vimrc:
set rtp+=/usr/local/opt/fzf