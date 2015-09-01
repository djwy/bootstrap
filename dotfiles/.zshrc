skip_global_compinit=1

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="doublend"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git osx docker docker-compose bundler brew zsh_reload)

source $ZSH/oh-my-zsh.sh

# User configuration

export PATH=$HOME/bin:/usr/local/bin:$PATH
# export MANPATH="/usr/local/man:$MANPATH"

# Example aliases
alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias box="ssh bfarah1@bfarah1-centos"
alias tools="ssh ber@bernardo-tools"
alias dfw="ssh app@10.247.192.197"
alias dal="ssh app@10.247.131.172"
alias dock="dal"
alias subl="open -a Sublime\ Text"
alias rmr="rm -r"
alias resource="source ~/.zshrc"
alias compose="docker-compose"

## For GO
export GOPATH="/Users/bfarah1/Code/golang"
export PATH="$PATH:$GOPATH/bin"
export PATH="/usr/local/sbin:$PATH"

eval "$(rbenv init -)"
eval "$(docker-machine env default 2>/dev/null)"

function ftp_start () {
  sudo -s launchctl load -w /System/Library/LaunchDaemons/ftp.plist
}

function ftp_stop () {
  sudo -s launchctl unload -w /System/Library/LaunchDaemons/ftp.plist
}
