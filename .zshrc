export LANG=ja_JP.UTF-8
# ${fg[blue]}等で色が利用できるようにする
autoload -Uz colors
colors
# 補完を利用
autoload -Uz compinit
compinit
bindkey -v # vimキーバインド
setopt share_history # 他ターミナルとヒストリを共有
setopt histignorealldups # ヒストリを重複表示しない
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
HISTTIMEFORMAT="[%Y/%M/%D %H:%M:%S] "

setopt auto_param_slash # ディレクトリ名の補完で末尾に / を付加
setopt magic_equal_subst # コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる

setopt auto_pushd # 遷移したディレクトリをスタックする
setopt pushd_ignore_dups # 重複したディレクトリはスタックしない

# backspace,deleteキーを使えるように
# stty erase ^H
# bindkey "^[[3~" delete-char

# 区切り文字の設定
autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars "_-./;@"
zstyle ':zle:*' word-style unspecified

# プロンプトを2行で表示、時刻を表示
PROMPT="%(?.%{${fg[green]}%}.%{${fg[red]}%})%n${reset_color}@${fg[blue]}%m${reset_color}(%*%) %~
%# "

local DEFAULT=$'%{^[[m%}'$
local RED=$'%{^[[1;31m%}'$
local YELLOW=$'%{^[[1;33m%}'$

zstyle ':completion:*:default' menu select=2 # 補完後、メニュー選択モードになり左右キーで移動が出来る
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # 補完で大文字にもマッチ
zstyle ':completion:*' verbose true # 補完を詳細に表示
zstyle ':completion:*' use-cache true # キャッシュによる補完の高速化
zstyle ':completion:*' completer _expand _complete _history _prefix # 補完の出し方
zstyle ':completion:*:messages' format '%F{YELLOW}%d%F{DEFAULT}'
zstyle ':completion:*:warnings' format '%F{RED}No matches for:''%F{YELLOW} %d%F{DEFAULT}'
zstyle ':completion:*:descriptions' format '%F{YELLOW}completing %B%d%b%F{DEFAULT}'
zstyle ':completion:*:corrections' format '%F{YELLOW}%B%d ''%F{RED}(errors: %e)%b%F{DEFAULT}'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*' group-name ''

export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} # 補完候補に色を付ける
alias ls='ls --color'
alias ll='ls -l'

# 複数ファイルのmv 例　zmv *.txt *.txt.bk
autoload -Uz zmv
alias zmv='noglob zmv -W'

# git設定
RPROMPT="%{${fg[blue]}%}[%~]%{${reset_color}%}"
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
zstyle ':vcs_info:*' formats "%F{green}%c%u[%b]%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd () { vcs_info }
RPROMPT=$RPROMPT'${vcs_info_msg_0_}'

function is_exists() { type "$1" >/dev/null 2>&1; return $?; }
function is_osx() { [[ $OSTYPE == darwin* ]]; }
function is_screen_running() { [ ! -z "$STY" ]; }
function is_tmux_runnning() { [ ! -z "$TMUX" ]; }
function is_screen_or_tmux_running() { is_screen_running || is_tmux_runnning; }
function shell_has_started_interactively() { [ ! -z "$PS1" ]; }
function is_ssh_running() { [ ! -z "$SSH_CONECTION" ]; }

# zsh起動時にtmuxをattach
function tmux_automatically_attach_session()
{
  if is_screen_or_tmux_running; then
    ! is_exists 'tmux' && return 1

    if is_tmux_runnning; then
      echo "${fg_bold[red]} _____ __  __ _   ___  __ ${reset_color}"
      echo "${fg_bold[red]}|_   _|  \/  | | | \ \/ / ${reset_color}"
      echo "${fg_bold[red]}  | | | |\/| | | | |\  /  ${reset_color}"
      echo "${fg_bold[red]}  | | | |  | | |_| |/  \  ${reset_color}"
      echo "${fg_bold[red]}  |_| |_|  |_|\___//_/\_\ ${reset_color}"
    elif is_screen_running; then
      echo "This is on screen."
    fi
  else
    if shell_has_started_interactively && ! is_ssh_running; then
      if ! is_exists 'tmux'; then
        echo 'Error: tmux command not found' 2>&1
        return 1
      fi
      if tmux has-session >/dev/null 2>&1 && tmux list-sessions | grep -qE '.*]$'; then
        # detached session exists
        tmux list-sessions
        echo -n "Tmux: attach? (y/N/num) "
        read
        if [[ "$REPLY" =~ ^[Yy]$ ]] || [[ "$REPLY" == '' ]]; then
          tmux attach-session
          if [ $? -eq 0 ]; then
            echo "$(tmux -V) attached session"
            return 0
          fi
        elif [[ "$REPLY" =~ ^[0-9]+$ ]]; then
          tmux attach -t "$REPLY"
          if [ $? -eq 0 ]; then
            echo "$(tmux -V) attached session"
            return 0
          fi
        fi
      fi
      if is_osx && is_exists 'reattach-to-user-namespace'; then
        # on OS X force tmux's default command
        # to spawn a shell in the user's namespace
        tmux_config=$(cat $HOME/.tmux.conf <(echo 'set-option -g default-command "reattach-to-user-namespace -l $SHELL"'))
        tmux -f <(echo "$tmux_config") new-session && echo "$(tmux -V) created new session supported OS X"
      else
        tmux new-session && echo "tmux created new session"
      fi
    fi
  fi
}
tmux_automatically_attach_session

# hyper用設定
title() { export TITLE_OVERRIDDEN=1; echo -en "\e]0;$*\a"}
autotitle() { export TITLE_OVERRIDDEN=0 }; autotitle
overridden() { [[ $TITLE_OVERRIDDEN == 1 ]]; }
gitDirty() { [[ $(git status 2> /dev/null | grep -o '\w\+' | tail -n1) != ("clean"|"") ]] && echo "*" }

tabtitle_precmd() {
   if overridden; then return; fi
   pwd=$(pwd) # Store full path as variable
   cwd=${pwd##*/} # Extract current working dir only
   print -Pn "\e]0;$cwd$(gitDirty)\a" # Replace with $pwd to show full path
}
[[ -z $precmd_functions ]] && precmd_functions=()
precmd_functions=($precmd_functions tabtitle_precmd)

tabtitle_preexec() {
   if overridden; then return; fi
   printf "\033]0;%s\a" "${1%% *} | $cwd$(gitDirty)" # Omit construct from $1 to show args
}
[[ -z $preexec_functions ]] && preexec_functions=()
preexec_functions=($preexec_functions tabtitle_preexec)

# 個別環境設定
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin
export TERM="cygwin"
export PATH=$PATH:$HOME/.yarn/bin


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
