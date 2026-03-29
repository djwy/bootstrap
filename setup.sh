#!/bin/bash

RUBY_VERSION="3.3.6"
NODE_VERSION="22.12.0"

# ─── Output helpers ──────────────────────────────────────────────────────────

BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

header()  { printf "\n${BOLD}${BLUE}▸ %s${RESET}\n" "$1"; }
success() { printf "  ${GREEN}✓${RESET} %s\n" "$1"; }
info()    { printf "  %s\n" "$1"; }

ask() {
  printf "${YELLOW}  ? %s [y/n] ${RESET}" "$1"
  read -r answer
  [[ "$answer" == "y" ]]
}

# ─── Utilities ───────────────────────────────────────────────────────────────

git_tar() {
  info "Downloading $1 from GitHub"
  mkdir -p "$2"
  curl -sL "https://github.com/$1/archive/master.tar.gz" | tar -xz -C "$2" --strip-components=1
}

# ═══════════════════════════════════════════════════════════════════════════════
# Xcode CLI Tools
# ═══════════════════════════════════════════════════════════════════════════════

if ask "Install Xcode command-line tools?"; then
  header "Xcode Command-Line Tools"
  xcode-select --install 2>/dev/null || info "Already installed"
  success "Done"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# Bootstrap repo
# ═══════════════════════════════════════════════════════════════════════════════

header "Gathering dependencies"
git_tar djwy/bootstrap "$HOME/bootstrap" && cd "$HOME/bootstrap"
success "Done"

# ═══════════════════════════════════════════════════════════════════════════════
# Homebrew
# ═══════════════════════════════════════════════════════════════════════════════

if ask "Install Homebrew and dependencies?"; then
  header "Homebrew"

  if ! command -v brew &>/dev/null; then
    info "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    info "Homebrew already installed"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  info "Installing Brewfile dependencies"
  brew bundle
  success "Homebrew dependencies installed"

  if ask "Install personal applications (Brewfile.personal)?"; then
    brew bundle --file=Brewfile.personal
    success "Personal applications installed"
  fi
fi

# ═══════════════════════════════════════════════════════════════════════════════
# Fonts
# ═══════════════════════════════════════════════════════════════════════════════

if ask "Install Nerd Font?"; then
  header "Nerd Font"
  brew install font-atkynson-mono-nerd-font
  success "Done"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# FZF
# ═══════════════════════════════════════════════════════════════════════════════

if ask "Install FZF shell extensions?"; then
  header "FZF Shell Extensions"
  "$(brew --prefix)/opt/fzf/install"
  success "Done"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# Languages & tools
# ═══════════════════════════════════════════════════════════════════════════════

if ask "Set up Ruby ($RUBY_VERSION), Node ($NODE_VERSION), and Yarn?"; then
  header "Languages & Tools"

  info "Setting up Ruby $RUBY_VERSION"
  mise use --global ruby@$RUBY_VERSION
  gem install --conservative bundler pry rubocop
  success "Ruby ready"

  info "Setting up Node $NODE_VERSION"
  mise use --global node@$NODE_VERSION
  success "Node ready"

  info "Setting up Yarn"
  mise use --global yarn@latest
  yarn global add eslint prettier
  success "Yarn ready"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# Dotfiles & shell
# ═══════════════════════════════════════════════════════════════════════════════

if ask "Install dotfiles and shell plugins?"; then
  header "Dotfiles & Shell"

  if [ ! -d "$HOME/dev/dotfiles" ]; then
    info "Cloning dotfiles"
    git clone https://github.com/djwy/dotfiles.git "$HOME/dev/dotfiles"
  else
    info "Dotfiles already cloned"
  fi
  "$HOME/dev/dotfiles/link.sh"
  success "Dotfiles linked"

  if [ ! -d "$HOME/.zgenom" ]; then
    info "Installing zgenom"
    git clone https://github.com/jandamm/zgenom.git "$HOME/.zgenom"
    success "zgenom installed"
  else
    info "zgenom already installed"
  fi

  info "Reloading zsh configuration"
  source "$HOME/.zshrc"
  success "Shell configured"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# Preferences
# ═══════════════════════════════════════════════════════════════════════════════

if ask "Copy old preferences from bootstrap repo?"; then
  header "Preferences"
  chmod 0600 ./Library/Preferences/*
  cp -R ./Library/ ~/Library/
  success "Preferences copied"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# Alfred
# ═══════════════════════════════════════════════════════════════════════════════

if ask "Enable Alfred iCloud sync?"; then
  header "Alfred Sync"
  killall Alfred &>/dev/null
  defaults write com.runningwithcrayons.Alfred-Preferences-3 syncfolder -string "~/Library/Mobile Documents/com~apple~CloudDocs/Alfred"
  success "Alfred sync enabled"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# macOS settings
# ═══════════════════════════════════════════════════════════════════════════════

if ask "Apply macOS settings?"; then
  ./macos.sh
fi

# ═══════════════════════════════════════════════════════════════════════════════
# Cleanup
# ═══════════════════════════════════════════════════════════════════════════════

if ask "Remove bootstrap directory?"; then
  header "Cleanup"
  rm -rf "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  success "Bootstrap directory removed"
fi

printf "\n${BOLD}${GREEN}All done!${RESET}\n"
