# 個別環境設定
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin
export TERM="cygwin"
export PATH=$PATH:$HOME/.yarn/bin

export PYENV_ROOT=$HOME/.pyenv
export PATH=$PATH:$PYENV_ROOT/bin

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
