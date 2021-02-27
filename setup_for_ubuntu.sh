# !/bin/sh

# cd to script
cd `dirname $0`

# for cdr cache
mkdir -p ~/.cache/shell

# ln dotfiles
./tools/ln_dotfiles.sh
rm ~/.Brewfile

# apt
sudo apt update -y && sudo apt upgrade -y
sudo update-locale LANG=ja_sudoJP.UTF8
sudo apt install locales-all -y
sudo apt install manpages-ja manpages-ja-dev -y
sudo apt install -y make gdb build-essential clang-format gfortran libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev sl figlet cmatrix tree unzip postgresql zsh nkf git openjdk-11-source libglu1-mesa 
sudo dpkg-reconfigure tzdata liblzma-dev lzma

# install gh
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0
sudo apt-add-repository https://cli.github.com/packages
sudo apt update -y
sudo apt install gh -y

# install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# install zsh autosuggestion
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions

# install aws cli
mkdir -o ~/awscli/
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "~/awscli/awscliv2.zip"
unzip ~/awscli/awscliv2.zip
sudo ~/awscli/aws/install

# intall anyenv
rm -r -f ~/.anyenv
git clone https://github.com/anyenv/anyenv ~/.anyenv

# install azure cli
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# install firebase cli
curl -sL https://firebase.tools | sudo bash

# install flutter cli
git clone https://github.com/flutter/flutter.git ~/.flutter

# chsh zsh
chsh -s $(which zsh)
mkdir -p ~/.cache/shell

exec zsh -l

# vim
mkdir -p ~/.vim/undo

# anyenv
rm -rf ~/.anyenv
git clone https://github.com/anyenv/anyenv ~/.anyenv

# install firebase cli
curl -sL https://firebase.tools | sudo bash

# install flutter
# rm -rf ~/.flutter
# git clone https://github.com/flutter/flutter.git ~/.flutter

# zsh
sudo sh -c "echo /usr/local/bin/zsh >> /etc/shells"
chsh -s /usr/local/bin/zsh
mkdir -p ~/.cache/shell

# restart shell
exec /usr/local/bin/zsh -l

# anyenv
rm -rf $(anyenv root)/plugins
mkdir -p $(anyenv root)/plugins
git clone https://github.com/znz/anyenv-update.git $(anyenv root)/plugins/anyenv-update

# install envs
anyenv install pyenv
anyenv install nodenv
anyenv install goenv
anyenv install jenv
anyenv install rbenv

# restart shell
exec $SHELL -l

# set up envs
# pyenv
pyenv install 3.7.9
pyenv global 3.7.9
# python package
pip install --upgrade pip
pip install pycaret
pip install autopep8 black

# install pip packages
pip install online-judge-tools jupyter jupyterlab jupyterthemes jupyter-contrib-nbextensions jupyter-nbextensions-configurator 

# setup jupyter notebook
jupyter nbextensions_configurator enable --user
jt -t monokai -f hack -fs 100 -tfs 100 -ofs 80 -T -N -cellw 80%
jupyter contrib nbextension install --user
jupyter nbextensions_configurator enable --user
jupyter nbextension enable code_prettify/autopep8 
jupyter nbextension enable codefolding/main
jupyter nbextension enable hinterland/hinterland
jupyter nbextension enable spellchecker/main
jupyter nbextension enable snippets_menu/main
jupyter nbextension enable toggle_all_line_numbers/main
# jupyter nbextension enable ruler/main
jupyter nbextension enable execute_time/ExecuteTime
jupyter nbextension enable toc2/main
jupyter nbextension enable varInspector/main
# jupyter nbextension enable code_prettify/code_prettify
jupyter nbextension enable code_font_size/code_font_size
jupyter nbextension enable highlighter/highlighter
jupyter nbextension enable table_beautifier/main

# poetry
poetry config virtualenvs.in-project true
mkdir -p ~/.zfunc
poetry completions zsh > ~/.zfunc/_poetry

# nodenv
nodenv install 13.14.0
nodenv install 12.16.0
nodenv global 13.14.0

# goenv
goenv install 1.15.5
goenv global 1.15.5

# jenv
jenv add $(/usr/libexec/java_home)
jenv add `/usr/libexec/java_home -v "1.8"`
jenv global 1.8
jenv enable-plugin export

# rbenv
rbenv install 3.0.0
rbenv global 3.0.0

# restart shell
exec $SHELL -l

# npm package 
npm install -g @vue/cli eslint prettier eslint-config-prettier

# flutter develop setting
flutter precache
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch
sudo gem install -v1.10.0 cocoapods
pod setup
# install android-sdk from andoid-studio manually
# https://qiita.com/oekazuma/items/92e9bae4268fea107efa

# restart shell
exec $SHELL -l
