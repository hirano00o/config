export LANG=ja_JP.UTF-8
export PATH="$HOME/bin:$PATH"
autoload -Uz colors
colors
autoload -Uz compinit
compinit
bindkey -e
setopt share_history
setopt histignorealldups
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt auto_pushd
setopt pushd_ignore_dups
alias ls='ls -G'
alias ll='ls -lG'
alias vi='vim'

# backspace,deleteキーを使えるように
stty erase ^H
bindkey "^[[3~" delete-char

# どこからでも参照できるディレクトリパス
cdpath=(~)

# 区切り文字の設定
autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars "_-./;@"
zstyle ':zle:*' word-style unspecified

# プロンプトを2行で表示、時刻を表示
PROMPT="%(?.%{${fg[green]}%}.%{${fg[red]}%})%n${reset_color}@${fg[blue]}%m${reset_color}(%*%) %~
%# "

# 補完後、メニュー選択モードになり左右キーで移動が出来る
zstyle ':completion:*:default' menu select=2

# 補完で大文字にもマッチ
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

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


export GOPATH=$HOME/go/third-party:$HOME/go/my-project
export PATH=$HOME/go/third-party/bin:$HOME/go/my-project/bin:$PATH

export AWS_ACCESS_KEY_ID="AKIAJJEA7ZOBPR5MBCTQ"
export AWS_SECRET_ACCESS_KEY="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"

export ANDROID_HOME=/Users/hirano00o/Library/Android/sdk
export ANDROID_NDK_HOME=/Users/hirano00o/Library/Android/sdk/ndk-bundle

export PATH=$PATH:$ANDROID_HOME:$ANDROID_NDK_HOME:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
