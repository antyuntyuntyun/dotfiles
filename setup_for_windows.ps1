# スクリプトの場所にcd
$scriptPath = $MyInvocation.MyCommand.Path
cd (Split-Path -Parent $scriptPath)

# -------------------------------------
# Install-Module
# -------------------------------------
Install-Module ZLocation -Scope CurrentUser
Install-Module PSFzf -Scope CurrentUser
Install-Module posh-git -Scope CurrentUser
Install-Module oh-my-posh -Scope CurrentUser
Install-Module -Name PSReadLine -AllowPrerelease -Scope CurrentUser -Force -SkipPublisherCheck
Install-Module -Name Terminal-Icons
Install-Module -Name MicrosoftTeams

# -------------------------------------
# wsl
# -------------------------------------
# setup follow by document
# https://docs.microsoft.com/ja-jp/windows/wsl/install-win10

# -------------------------------------
# scoop
# -------------------------------------
# scoopのインストール
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
iwr -useb get.scoop.sh | iex
# 基本パッケージインストール
scoop install git
scoop install 7zip
# バケット追加
scoop bucket add extras
scoop bucket add github-gh
scoop bucket add versions
scoop bucket add nonportable
# パッケージインストール
scoop install cacert
scoop install cowsay
scoop install everything
scoop install figlet
scoop install fzf
scoop install gawk
scoop install gh
scoop install ghq
scoop install aws
scoop install gow
scoop install graphviz
scoop install gzip
scoop install innounp
scoop install less
scoop install lsd
scoop install neofetch
scoop install neovim
scoop install notion
scoop install pwsh
scoop install r
scoop install ripgrep
scoop install rstudio
scoop install sed
scoop install slack
scoop install sublime-text
scoop install sudo
scoop install tar
scoop install vim
scoop install vscode
scoop install wget
scoop install win32-openssh
scoop install windows-terminal
scoop install winscp
scoop install youtube-dl
scoop install imagemagick
coop install zoom
scoop install vmware-horizon-client-np

scoop alias add reinstall "scoop uninstall $*; scoop install $*"
scoop alias add up "scoop update; scoop update *"
scoop alias add cl "scoop cache rm *;scoop cleanup *"

# -------------------------------------
# fonts
# -------------------------------------
cd ./WindowsSetting/fonts/powerline
pwsh install.sh

# -------------------------------------
# make symlink of setting file (※overwrite)
# -------------------------------------
# windows terminal
New-Item -Force -Value (Resolve-Path ("./WindowsSetting/WindowsTerminal/settings.json")) -Path "~/AppData/Local/Microsoft/Windows Terminal" -Name settings.json -ItemType SymbolicLink
# powershell
New-Item -Force -Value (Resolve-Path ("./WindowsSetting/PowerShell/Microsoft.PowerShell_profile.ps1")) -Path $PROFILE -ItemType SymbolicLink
# my posh-theme
New-Item -Force -Value (Resolve-Path ("./WindowsSetting/PowerShell/Themes/StarY.psm1")) -Path $ThemeSettings.MyThemesLocation -Name StarY.psm1 -ItemType SymbolicLink
New-Item -Force -Value (Resolve-Path ("./WindowsSetting/PowerShell/Themes/ParadoxY.psm1")) -Path $ThemeSettings.MyThemesLocation -Name ParadoxY.psm1 -ItemType SymbolicLink
# vim
New-Item -Force -Value (Resolve-Path ("./dotfiles/.vimrc")) -Path ~ -Name .vimrc -ItemType SymbolicLink
# nvim
New-Item -Force -Value (Resolve-Path ("./WindowsSetting/vim/nvim/init.vim")) -Path ~/AppData/Local/nvim -Name init.vim -ItemType SymbolicLink
New-Item -Force -Value (Resolve-Path ("./WindowsSetting/vim/nvim/init.vim")) -Path ~/.config/nvim -Name init.vim -ItemType SymbolicLink
New-Item -Force -Value (Resolve-Path ("./WindowsSetting/vim/nvim/dein.toml")) -Path ~/.config/nvim -Name dein.toml -ItemType SymbolicLink
New-Item -Force -Value (Resolve-Path ("./WindowsSetting/vim/nvim/lazy.toml")) -Path ~/.config/nvim -Name lazy.toml -ItemType SymbolicLink
# gitconfig
New-Item -Force -Value (Resolve-Path ("./dotfiles/.gitconfig")) -Path ~ -Name .gitconfig -ItemType SymbolicLink
# R
New-Item -Force -Value (Resolve-Path ("./WindowsSetting/R/.Rprofile")) -Path ~/Documents/ -Name .Rprofile -ItemType SymbolicLink

# -------------------------------------
# WindowsTerminal
# -------------------------------------
mkdir -p ~/.WindowsTerminal
mkdir -p ~/.WindowsTerminal/PowerShell/
mkdir -p ~/.WindowsTerminal/PowerShellCore/
mkdir -p ~/.WindowsTerminal/wsl/

New-Item -Force -Value (Resolve-Path ("./WindowsSetting/WindowsTerminal/PowerShell/img0.jpg")) -Path "~/.WindowsTerminal/PowerShell/" -Name img0.jpg -ItemType SymbolicLink
New-Item -Force -Value (Resolve-Path ("./WindowsSetting/WindowsTerminal/PowerShellCore/CoolWindows.jpg")) -Path "~/.WindowsTerminal/PowerShellCore/" -Name CoolWindows.jpg -ItemType SymbolicLink
New-Item -Force -Value (Resolve-Path ("./WindowsSetting/WindowsTerminal/wsl/ubuntu_14143.png")) -Path "~/.WindowsTerminal/wsl/" -Name ubuntu_14143.png -ItemType SymbolicLink

# -------------------------------------
# nvim
# -------------------------------------
mkdir ~/.vim/dein
cd ~/.vim/dein
Invoke-WebRequest https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.ps1 -OutFile installer.ps1
./installer.ps1 ~/.vim/dein

# -------------------------------------
# VScode
# -------------------------------------
# 右クリックメニューに追加
~\scoop\apps\vscode\current\vscode-install-context.reg
