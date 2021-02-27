# !/bin/sh

# cd to script
cd `dirname $0`

# Command Line Tools for Xcode
sudo xcode-select --install

# システム環境設定の変更
echo 'Changing System Preferences...'

# 全ての拡張子のファイルを表示する
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# USB やネットワークストレージに .DS_Store ファイルを作成しない
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
# Finder のタイトルバーにフルパスを表示する
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
# 名前で並べ替えを選択時にディレクトリを前に置くようにする
defaults write com.apple.finder _FXSortFoldersFirst -bool true
# 不可視ファイルを表示する
defaults write com.apple.finder AppleShowAllFiles YES
# 検索時にデフォルトでカレントディレクトリを検索する
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
# 拡張子変更時の警告を無効化する
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
# クイックルックでテキストを選択可能にする
defaults write com.apple.finder QLEnableTextSelection -bool true
# パスバーを表示する
defaults write com.apple.finder ShowPathbar -bool true
# ステータスバーを表示する
defaults write com.apple.finder ShowStatusBar -bool true
# タブバーを表示する
defaults write com.apple.finder ShowTabView -bool true
# ゴミ箱を空にする前の警告を無効化する
#defaults write com.apple.finder WarnOnEmptyTrash -bool false
# 未確認のアプリケーションを実行する際のダイアログを無効にする
# defaults write com.apple.LaunchServices LSQuarantine -bool false
# ファイル共有を有効にした時、共有先に自分の Mac を表示させる
#defaults write com.apple.NetworkBrowser ShowThisComputer -bool true
# # Safari の開発・デバッグメニューを有効にする
# defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
# # Safari の開発・デバッグメニューを有効にする
# defaults write com.apple.Safari IncludeDevelopMenu -bool true
# # Safari の開発・デバッグメニューを有効にする
# defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
echo "done"

# for cdr cache
mkdir -p ~/.cache/shell

# install Brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# ln dotfiles
./tools/ln_dotfiles.sh

# install software by brew
brew bundle --global
brew link docker

# using brew gcc
sudo ln -sf $(ls -d /usr/local/bin/* | grep "/g++-" | sort -r | head -n1) /usr/local/bin/g++
sudo ln -sf $(ls -d /usr/local/bin/* | grep "/gcc-" | sort -r | head -n1) /usr/local/bin/gcc

# for include <bits/stdc++.h> 
sudo mkdir -p /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include/c++/v1/bits
cd /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include/c++/v1/bits
sudo wget https://gist.githubusercontent.com/reza-ryte-club/97c39f35dab0c45a5d924dd9e50c445f/raw/47ecad34033f986b0972cdbf4636e22f838a1313/stdc++.h stdc++.h
cd

# vim
mkdir -p ~/.vim/undo

# anyenv
rm -rf ~/.anyenv
git clone https://github.com/anyenv/anyenv ~/.anyenv

# install firebase cli
curl -sL https://firebase.tools | sudo bash

# install flutter
rm -rf ~/.flutter
git clone https://github.com/flutter/flutter.git ~/.flutter

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

flutter doctor

# restart shell
exec $SHELL -l

# doctor
brew doctor
flutter doctor -v

# change setting manually
# 1. disable spotlight shortcut (To prevent a shortcut powerhouse.for vscode)
# 2. iterm2 setting from MacSetting/iTerm folder.