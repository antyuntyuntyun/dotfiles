# -------------------------------------
# env, zplug
# -------------------------------------

export PATH=$PATH:/usr/local/bin
export EDITOR=/usr/bin/vim

# zplug
#export ZPLUG_HOME=/usr/local/opt/zplug
if [[ ! -d ~/.zplug ]];then
  git clone https://github.com/zplug/zplug ~/.zplug
  find ~/.zplug/ -type d -exec chmod 755 {} +
fi

source ~/.zplug/init.zsh

# auto compile
if [ ~/.zshrc -nt ~/.zshrc.zwc ]; then
   zcompile ~/.zshrc
fi

zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "docker/cli", use:"contrib/completion/zsh/_docker"

# -------------------------------------
# zsh option
# -------------------------------------
fpath+=~/.zfunc

autoload bashcompinit
bashcompinit

## 補完機能の強化
autoload -U compinit
compinit -u

## sh-completionsの追加
fpath=(/usr/local/share/zsh-completions $fpath)

## zplugによるテーマの読み込み
zplug "yous/lime"

## 入力しているコマンド名が間違っている場合にもしかして：を出す。
setopt correct

# ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt auto_param_slash
# 補完候補を詰めて表示
setopt list_packed
# 補完候補一覧をカラー表示
# zstyle ':completion:*' list-colors ''
# 補完後、メニュー選択モードになり左右キーで移動が出来る
zstyle ':completion:*:default' menu select=2
# apt-getをキャッシュを使って高速化
zstyle ':completion:*' use-cache true

# ビープを鳴らさない
setopt nobeep

## 色を使う
setopt prompt_subst

## ^Dでログアウトしない。
setopt ignoreeof

## バックグラウンドジョブが終了したらすぐに知らせる。
setopt no_tify

## 直前と同じコマンドをヒストリに追加しない
setopt hist_ignore_dups

## 他のターミナルとヒストリーを共有
setopt share_history

## コマンド履歴に実行時間も記録する
setopt extended_history
HISTFILE=~/.zsh_history
HISTSIZE=10000 #メモリ上
SAVEHIST=100000

## コマンド中の余分なスペースは削除して履歴に記録する
setopt hist_reduce_blanks

# 補完
## タブによるファイルの順番切り替えをしない
unsetopt auto_menu

# cd -[tab]で過去のディレクトリにひとっ飛びできるようにする
setopt auto_pushd

# ディレクトリ名を入力するだけでcdできるようにする
setopt auto_cd

# cdr
# cdr, add-zsh-hook を有効にする
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
# cdr の設定
zstyle ':completion:*' recent-dirs-insert both
zstyle ':chpwd:*' recent-dirs-max 500
zstyle ':chpwd:*' recent-dirs-default true
zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/shell/chpwd-recent-dirs"
zstyle ':chpwd:*' recent-dirs-pushd true


## zplugのプラグインインストール
 if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
      echo; zplug install
    fi
  fi

zplug load

# -------------------------------------
# path
# -------------------------------------

# 重複する要素を自動的に削除
typeset -U path cdpath fpath manpath

path=(
    $HOME/bin(N-/)
    /usr/local/bin(N-/)
    /usr/local/sbin(N-/)
    $path
)

# -------------------------------------
# prompt
# -------------------------------------

autoload -U promptinit; promptinit
autoload -Uz colors; colors
autoload -Uz vcs_info
autoload -Uz is-at-least

#begin VCS
zstyle ":vcs_info:*" enable git svn hg bzr
zstyle ":vcs_info:*" formats "(%s)-[%b]"
zstyle ":vcs_info:*" actionformats "(%s)-[%b|%a]"
zstyle ":vcs_info:(svn|bzr):*" branchformat "%b:r%r"
zstyle ":vcs_info:bzr:*" use-simple true

zstyle ":vcs_info:*" max-exports 6

if is-at-least 4.3.10; then
    zstyle ":vcs_info:git:*" check-for-changes true
     # commitしていないのをチェックリポジトリサイズによっては重くなる
    zstyle ":vcs_info:git:*" stagedstr "%F{yellow}"
    zstyle ":vcs_info:git:*" unstagedstr "%F{red}+"
    zstyle ":vcs_info:git:*" formats "%F{green}%c%u[%b]%f"
    zstyle ":vcs_info:git:*" actionformats "(%s)-[%b|%a] %c%u"
fi

function vcs_prompt_info() {
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && echo -n " %{$fg[yellow]%}$vcs_info_msg_0_%f"
}
# end VCS

function battery_charge {
  b_now=$(cat /sys/class/power_supply/BAT1/energy_now)
  b_full=$(cat /sys/class/power_supply/BAT1/energy_full)
  b_status=$(cat /sys/class/power_supply/BAT1/status)
  # I am displaying 10 chars -> charge is in {0..9}
  charge=$(expr $(expr $b_now \* 10) / $b_full)

  # choose the color according the charge or if we are charging then always green
  if [[ charge -gt 5 || "Charging" == $b_status ]]; then
    echo -n "%{$fg[green]%}"
  elif [[ charge -gt 2 ]]; then
    echo -n "%{$fg[yellow]%}"
  else
    echo -n "%{$fg[red]%}"
  fi

  # display charge * '▸' and (10 - charge) * '▹'
  i=0;
  while [[ i -lt $charge ]]
  do
    i=$(expr $i + 1)
    echo -n "▸"
  done
  while [[ i -lt 10 ]]
  do
    i=$(expr $i + 1)
    echo -n "▹"
  done

  # display a plus if we are charging
  if [[ "Charging" == $b_status ]]; then
    echo -n "%{$fg_bold[green]%} +"
  fi
  # and reset the color
  echo -n "%{$reset_color%} "
}

PROMPT+="
\$(vcs_prompt_info) # "

RPROMPT=""
RPROMPT+="[%*]"

# -------------------------------------
# alias
# -------------------------------------

#grep
alias gr="grep --color -n -I --exclude='*.svn-*' --exclude='entries' --exclude='*/cache/*'"

# ls
alias ls="ls -G" # color for darwin
alias l="ls -la"
alias la="ls -la"
alias l1="ls -1"
alias lg="ls | grep"
alias lag='ls -la | grep'
# alias rm="rm -i"

# mv,cp
alias mv='mv -i'
alias cp='cp -i'

# tree
# alias tree="tree -NC" # N: 文字化け対策, C:色をつける
alias tree="tree -NC -a -f -I '.git|.idea|resolution-cache|target/streams|node_modulesi'"

# vim
alias v='vim'

# historyに日付を表示
# ![history number] でコマンド実行
alias h='history -d'
alias hg='history | grep'

# cdr
alias d='cdr -l'

# tmux 
alias tmux-n='tmux nwe-session -s'

# sublime (windows)
alias sublime='/mnt/c/Program\ Files/Sublime\ Text\ 3/sublime_text.exe'

# nkf
## bomなし
alias toUTF8='nkf -Lu -w80 --in-place --overwrite'
## bom あり
alias toUTF8-bom='nkf -Lu -w8 --in-place --overwrite'
# Shift JIS にして改行コードCRLFにして上書き
alias toSJIS='nkf -Lw -s --in-place --overwrite'

# git
alias g='git'

# -------------------------------------
# key bind
# -------------------------------------

bindkey -e

#Ctlr-kで親ディレクトリに移動
function cdup() {
   echo
   cd ..
   zle reset-prompt
}
zle -N cdup
bindkey '^K' cdup

# -------------------------------------
# env
# -------------------------------------
if [ -d $HOME/.anyenv ]
then
    export PATH="$HOME/.anyenv/bin:$PATH"
    eval "$(anyenv init - zsh)"
fi
if [ -d $HOME/.flutter ]
then
    export PATH="$HOME/.flutter/bin:$PATH"
fi

export ANDROID_HOME="/Users/yuta/Library/Android/sdk"

# -------------------------------------
# python
# -------------------------------------

alias pp="pipenv run python"
alias pj="pipenv run jupyter notebook"
export PIPENV_VENV_IN_PROJECT=1

# poetry
export PATH="$PATH:/home/yuta/.local/bin"
export PATH="$HOME/.poetry/bin:$PATH"

# pipx
export PATH="$PATH:/Users/yuta/.local/bin"

# -------------------------------------
# go
# -------------------------------------
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# -------------------------------------
# gh(git hub)
# -------------------------------------
alias brew="env PATH=${PATH//$(pyenv root)\/shims:/} brew"

# -------------------------------------
# gh(git hub)
# -------------------------------------
eval "$(gh completion -s zsh)"

# -------------------------------------
# atcorder
# -------------------------------------
atcoder-login(){
    oj login https://atcoder.jp/  
}

atcoder-test(){
    src=$1
    contest_id=$2 # urlの/atcorder/contest/xxxxxx/tasks/... のxxxxxの部分
    problem_id=$3 # urlの末尾。おそらく基本a,b,c,d
    if [ -z "$src" -o -z "$contest_id" -o -z "$problem_id" ]; then
        echo '\e[35mcommand Error \e[m'
        echo 'src(.cpp)) and contest id and problem id must be specified.'
        echo 'type a command like "atcorder-test $src $contest_id" $problem'
        echo 'url consists of /atcorder/contest/[$contest_id]/tasks/[$contest_id]_[$problem_id]'
        return
    fi

    echo '\e[35m----------------- downlad test input ----------------- \e[m' 
    oj d "https://atcoder.jp/contests/${contest_id}/tasks/${contest_id}_${problem_id}"
    g++ -Wall -std=gnu++17 ./$1
    echo '\n\e[35m------------ test src:' $src 'contest id:' $contest_id 'problem_id:' $problem_id '------------ \e[m\n' 
    oj test
    echo ''
    echo '\e[35mrm test file ...\e[m'
    rm -f a.out
    rm -rf test 
}

atcoder-submit(){
    src=$1
    contest_id=$2 # urlの/atcorder/contest/xxxxxx/tasks/... のxxxxxの部分
    problem_id=$3 # urlの末尾。おそらく基本a,b,c,d
    if [ -z "$src" -o -z "$contest_id" -o -z "$problem_id" ]; then
        echo '\e[35mcommand Error \e[m'
        echo 'src(.cpp)) and contest id and problem id must be specified.'
        echo 'type a command like "atcorder-test $src $contest_id" $problem'
        echo 'url consists of /atcorder/contest/[$contest_id]/tasks/[$contest_id]_[$problem_id]'
        return
    fi

    echo '\e[35m----------------- submit code ----------------- \e[m' 
    oj s "https://atcoder.jp/contests/${contest_id}/tasks/${contest_id}_${problem_id}" $src
}

# -------------------------------------
# fzf
# -------------------------------------

# 下記はシェル読み込みで一度実行できればよい
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

function select-history() {
  BUFFER=$(history -n -r 1 | fzf --no-sort +m --query "$LBUFFER" --prompt="History > ")
  CURSOR=$#BUFFER
}
zle -N select-history
bindkey '^r' select-history

# fzf-cdr
alias cdd='fzf-cdr'
function fzf-cdr() {
    target_dir=`cdr -l | sed 's/^[^ ][^ ]*  *//' | fzf`
    target_dir=`echo ${target_dir/\~/$HOME}`
    if [ -n "$target_dir" ]; then
        cd $target_dir
    fi
}
zle -N fzf-cdr
bindkey '^[' fzf-cdr

# fbr - checkout git branch
fbr() {
  local branches branch
  branches=$(git branch -vv) &&
  branch=$(echo "$branches" | fzf +m) &&
  git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}
# zle -N fbr
# bindkey "^b" fbr

fbrm() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}
zle -N fbrm
bindkey "^b" fbrm

# fshow - git commit browser
fshow() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}
zle -N fshow
bindkey "^g^l" fshow

# fd - cd to selected directory
fd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

# ctrl-d でdiff, Enterでadd
fadd() {
  local out q n addfiles
  while out=$(
      git status --short |
      awk '{if (substr($0,2,1) !~ / /) print $2}' |
      fzf-tmux --multi --exit-0 --expect=ctrl-d); do
    q=$(head -1 <<< "$out")
    n=$[$(wc -l <<< "$out") - 1]
    addfiles=(`echo $(tail "-$n" <<< "$out")`)
    [[ -z "$addfiles" ]] && continue
    if [ "$q" = ctrl-d ]; then
      git diff --color=always $addfiles | less -R
    else
      git add $addfiles
    fi
  done
}
zle -N fadd
bindkey "^a" fadd

alias gcd='ghq look `ghq list |fzf --preview "bat --color=always --style=header,grid --line-range :80 $(ghq root)/{}/README.*"`'

function ghq-fzf() {
  local src=$(ghq list | fzf --preview "ls -laTp $(ghq root)/{} | tail -n+4 | awk '{print \$9\"/\"\$6\"/\"\$7 \" \" \$10}'")
  if [ -n "$src" ]; then
    BUFFER="cd $(ghq root)/$src"
    zle accept-line
  fi
  zle -R -c
}
zle -N ghq-fzf
bindkey '^]' ghq-fzf

# docker psからdocker log見ながらnameを選ぶ
function select_docker_process(){
    LBUFFER+=$(docker ps -a --format 'table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Command}}\t{{.CreatedAt}}\t{{.Ports}}\t{{.Networks}}' | \
      fzf --preview-window=down --preview 'f() {
          set -- $(echo -- "$@")
          if [[ $3 != "ID" ]]; then
            docker logs --tail 300 $3
          fi
        }; f {}' | \
      awk -F '\t' '{ print $2 }' | \
      tr "\n" " ")
    CURSOR=$#LBUFFER
    zle reset-prompt
}
zle -N select_docker_process
bindkey "^g^d^h" select_docker_process

# git statusで対象となるファイルのgit diffみながらファイルを選択する
function select_file_from_git_status() {
  git status -u --short | \
    fzf -m --ansi --reverse --preview 'f() {
      local original=$@
      set -- $(echo "$@");
      if [ $(echo $original | grep -E "^M" | wc -l) -eq 1 ]; then # staged
        git diff --color --cached $2
      elif [ $(echo $original | grep -E "^\?\?" | wc -l) -eq 0 ]; then # unstaged
        git diff --color $2
      elif [ -d $2 ]; then # directory
        ls -la $2
      else
        git diff --color --no-index /dev/null $2 # untracked
      fi
    }; f {}' |\
    awk -F ' ' '{print $NF}' |
    tr '\n' ' '
}

# ↑の関数で選んだファイルを入力バッファに入れる
function insert_selected_git_files(){
    LBUFFER+=$(select_file_from_git_status)
    CURSOR=$#LBUFFER
    zle reset-prompt
}
zle -N insert_selected_git_files
bindkey "^g^s" insert_selected_git_files

# ↑の関数で選んだファイルをgit addする
function select_git_add() {
    local selected_file_to_add="$(select_file_from_git_status)"
    if [ -n "$selected_file_to_add" ]; then
      BUFFER="git add $(echo "$selected_file_to_add" | tr '\n' ' ')"
      CURSOR=$#BUFFER
    fi
    zle accept-line
}
zle -N select_git_add
bindkey "^g^a" select_git_add

# git branchとgit tagの結果からgit logを見ながらbranch/tagを選択する
function select_from_git_branch() {
  local list=$(\
    git branch --sort=refname --sort=-authordate --color --all \
      --format='%(color:red)%(authordate:short)%(color:reset) %(objectname:short) %(color:green)%(refname:short)%(color:reset) %(if)%(HEAD)%(then)* %(else)%(end)'; \
    git tag --color -l \
      --format='%(color:red)%(creatordate:short)%(color:reset) %(objectname:short) %(color:yellow)%(align:width=45,position=left)%(refname:short)%(color:reset)%(end)')

  echo $list | fzf --preview 'f() {
      set -- $(echo -- "$@" | grep -o "[a-f0-9]\{7\}");
      [ $# -eq 0 ] || git --no-pager log --oneline -100 --pretty=format:"%C(red)%ad%Creset %C(green)%h%Creset %C(blue)%<(15,trunc)%an%Creset: %s" --date=short --color $1;
    }; f {}' |\
    sed -e 's/\* //g' | \
    awk '{print $3}'  | \
    sed -e "s;remotes/;;g" | \
    perl -pe 's/\n/ /g'
}

# ↑の関数で選んだbranch/tagを入力バッファに入れる
function select_to_insert_branch() {
    LBUFFER+=$(select_from_git_branch)
    CURSOR=$#LBUFFER
    zle reset-prompt
}
zle -N select_to_insert_branch
bindkey "^g^o" select_to_insert_branch

# ↑の関数で選んだbranch/tagにgit checkoutする
function select_git_checkout() {
    local selected_file_to_checkout=`select_from_git_branch | sed -e "s;origin/;;g"`
    if [ -n "$selected_file_to_checkout" ]; then
      BUFFER="git checkout $(echo "$selected_file_to_checkout" | tr '\n' ' ')"
      CURSOR=$#BUFFER
    fi
    zle accept-line
}
zle -N select_git_checkout
bindkey "^g^o" select_git_checkout

# -------------------------------------
# docker
# -------------------------------------
docker-start() {
  local container
  container="$(docker ps -a -f status=exited | sed -e '1d' | fzf --height 40% --reverse | awk '{print $1}')"
  if [ -n "${container}" ]; then
    echo 'starting container...'
    docker start ${container}
  fi
}

docker-stop() {
  local container
  container="$(docker ps -a -f status=running | sed -e '1d' | fzf --height 40% --reverse | awk '{print $1}')"
  if [ -n "${container}" ]; then
    echo 'stopping container...'
    docker stop ${container}
  fi
}

docker-exec-bash() {
  local container
  container="$(docker ps -a -f status=running | sed -e '1d' | fzf --height 40% --reverse | awk '{print $1}')"
  if [ -n "${container}" ]; then
    docker exec -it ${container} /bin/bash
  fi
}

docker-logs() {
  local container
  container="$(docker ps -a -f status=running | sed -e '1d' | fzf --height 40% --reverse | awk '{print $1}')"
  if [ -n "${container}" ]; then
    docker logs -f --tail 100 ${container}
  fi
}

docker-rm() {
  local container
  container="$(docker ps -a -f status=exited | sed -e '1d' | fzf --height 40% --reverse | awk '{print $1}')"
  if [ -n "${container}" ]; then
    echo 'removing container...'
    docker rm ${container}
  fi
}

docker-rmi() {
  local image
  image="$(docker images -a | sed -e '1d' | fzf --height 40% --reverse | awk '{print $3}')"
  if [ -n "${image}" ]; then
    echo 'removing container image...'
    docker rmi ${image}
  fi
}

# -------------------------------------
# ghq
# -------------------------------------
function ghq-new() {
    echo '\e[32mPlease Select "Yes" for ALL\e[m'
    local REPONAME=$1

    if [ -z "$REPONAME" ]; then
        echo 'Repository name must be specified.'
        echo 'type a command like $ghq-new-repo-gh repo-name'
        return
    fi

    local TMPDIR=/tmp/ghq_new
    local TMPREPODIR=$TMPDIR/$REPONAME

    mkdir -p $TMPREPODIR
    cd $TMPREPODIR

    git init -q
    gh repo create $1

    local REPOURL=$(git remote get-url origin) 
    local REPOPATH=$(echo $REPOURL | sed -e 's/^https:\/\///' -e 's/^git@//' -e 's/\.git$//' -e 's/github.com:/github.com\//')
    local USER_REPO_NAME=$(echo $REPOPATH | sed -e 's/^github\.com\///')

    ghq get $USER_REPO_NAME
    cd $(ghq root)/$REPOPATH

    rm -rf $TMPREPODIR

}
