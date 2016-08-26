# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="bernardo"

plugins=(git rails ruby osx brew zsh-syntax-highlighting gitfast zsh-autosuggestions)

bindkey '^ ' autosuggest-accept

source $ZSH/oh-my-zsh.sh

alias flushdns='dscacheutil -flushcache;sudo killall -HUP mDNSResponder'
alias resource='source ~/.zshrc'
alias cdc='cd ~/Code'
alias gcane="git commit --amend --no-edit"
alias gpc="git push origin HEAD"
alias gpcu="git push --set-upstream origin HEAD"
alias gpf="git push --force"
alias gds="git diff --staged"

# Vim
export VISUAL="nvim"
export EDITOR=$VISUAL
alias vim="nvim"
alias vi="nvim"

# FZF
export FZF_DEFAULT_COMMAND='ag -g ""'

# Node
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/local/git/bin:/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin:/usr/local/share/npm/bin:$PATH"
export NODE_PATH="/usr/local/lib/node"

# Ruby
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)" 2> /dev/null

# GO
export GOPATH="$HOME/Code/golang"
export PATH="$GOPATH/bin:$PATH:/usr/local/opt/go/libexec/bin"

# Add my scripts to path
SCRIPTS_PATH="$HOME/Code/scripts"
export PATH="$PATH:$SCRIPTS_PATH"

