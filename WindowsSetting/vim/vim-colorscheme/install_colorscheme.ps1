# download colorscheme
# git clone https://github.com/tomasr/molokai
# fatalしちゃう
git clone https://github.com/sickill/vim-monokai.git

# vim
# mkdir -p ~/.vim
# mkdir -p ~/.vim/colors

# TODO: if文が動かないので書き直し
# if(!(Test-Path ~/.vim))
#     mkdir ~/.vim
# if(!(Test-Path ~/.vim/colors))
#     mkdir ~/.vim/colors

# New-Item -Value ./vim-monokai/colors/monokai.vim -Path ~/.vim/colors/ -Name monokai.vim -ItemType SymbolicLink -Force
# cp ./vim-monokai/colors/monokai.vim ~/.vim/colors/
# cpできないめんどくさくなったのでやめる



# nvim
# mkdir -p ~/.config
# mkdir -p ~/.cofig/nvim
# mkdir -p ~/.cofig/nvim/colors

# TODO: if文が動かないので書き直し
# if(!(Test-Path ~/.config))
#     mkdir ~/.config
# if(!(Test-Path ~/.cofig/nvim))
#     mkdir ~/.cofig/nvim
# if(!(Test-Path ~/.cofig/nvim/colors))
#     mkdir ~/.cofig/nvim/colors

# New-Item -Value ./vim-monokai/colors/monokai.vim -Path ~/.cofig/nvim/colors/ -Name monokai.vim -ItemType SymbolicLink -Force
# cp ./vim-monokai/colors/monokai.vim ~/.cofig/nvim/colors/

