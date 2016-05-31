# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="bernardo"

plugins=(git rails ruby osx brew zsh-syntax-highlighting sublime last-working-dir docker)

source $ZSH/oh-my-zsh.sh
source ~/.iterm2_shell_integration.zsh

alias flushdns='dscacheutil -flushcache;sudo killall -HUP mDNSResponder'
alias resource='source ~/.zshrc'

# VIM
alias vi="mvim -v"
alias vim="mvim -v"

# Node
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/local/git/bin:/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin:/usr/local/share/npm/bin:$PATH"
export NODE_PATH="/usr/local/lib/node"

# Ruby
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)" 2> /dev/null

# Docker
# eval "$(docker-machine env default)"

# GO
export GOPATH="$HOME/Code/golang"
export PATH="$GOPATH/bin:$PATH:/usr/local/opt/go/libexec/bin"

