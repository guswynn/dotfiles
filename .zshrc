# Full terminal support
export CLICOLOR=true
export TERM=xterm-256color
autoload colors; colors


# History, shared across splits
export HISTFILE="$HOME/.zsh-history"
export HISTSIZE=10000000
export SAVEHIST=10000000
export LESSHISTFILE="-" # disable less history
setopt APPEND_HISTORY
setopt share_history
setopt inc_append_history
setopt hist_ignore_dups
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS


# Various tiny settings that can be left here.
unset EXTENDED_GLOB
setopt AUTO_CD
setopt COMPLETE_ALIASES
setopt COMPLETE_IN_WORD
setopt CORRECT
setopt LOCAL_OPTIONS
setopt LOCAL_TRAPS
setopt NO_HUP
setopt NO_LIST_BEEP
setopt PROMPT_SUBST
setopt interactivecomments
unsetopt CASE_GLOB
KEYTIMEOUT=1
zle -N newtab


# Disabled, to use basic completion stylw
# autoload -Uz compinit
# compinit -z

autoload colors; colors
# Nice selection menu
zstyle ':completion:*' menu select
# Matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# {asting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

autoload colors; colors
# Vim mode
bindkey -v
# ^R reverse search
bindkey '^R' history-incremental-search-backward


# Fix some buttons
# see https://unix.stackexchange.com/questions/20298/home-key-not-working-in-terminal
bindkey '^[[Z' reverse-menu-complete
bindkey "${terminfo[khome]}" beginning-of-line
bindkey "${terminfo[kend]}" end-of-line
export TERMINFO=~/.terminfo


# Prompt support:
cwd () {
  dir="${PWD/#$HOME/~}"
  dir="${dir//\/data\/users\/$USER/~}"
  echo "$dir"
}

# TODO(guswynn): find something to make this general purpose
autoload -Uz vcs_info
zstyle ':vcs_info:git*:*' get-revision true
zstyle ':vcs_info:git*' formats "%b (%12.12i)"
# zstyle ':vcs_info:git*' branchformat "%b:%i"
precmd() {
    vcs_info
}

# vi mode status for prompt
function vi_mode() {
	local mode
	mode="${${KEYMAP/vicmd/N}/(main|viins)/I}"
	if [ -z "$mode" ]; then
		echo -n "I"
	else
		echo -n "$mode"
	fi
}

PROMPT='%{$fg[magenta]%}%n@mac %{$fg[green]%}Helping %{$fg[blue]%}$(cwd) %{$fg[yellow]%} ${vcs_info_msg_0_}
%{$fg[cyan]%}%D{%F} %* $(vi_mode) > %{$reset_color%}'

# Reset prompt in vi mode
function zle-line-init zle-keymap-select {
	zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select


# Shorthand to reload this file
alias reloadprof='source ~/.zshrc'


# Neovim support
# vim multiple files opens in vsplits
alias vim='nvim -O'
export EDITOR=nvim


# ls support
alias ls='ls --color'


# `time` formatting
export TIMEFMT=$'\nreal\t%*E\nuser\t%*U\nsys\t%*S'


# Rust support
export PATH="$HOME/.cargo/bin:$PATH"
export RUST_BACKTRACE=1
# cargo/rust stuff
alias cargo-config="cargo +nightly -Zunstable-options config get"
# Moving around my repos.
alias repos="cd ~/repos"
alias work="cd ~/work"
alias rust="cd ~/repos/rust"
alias dotfiles="cd ~/repos/dotfiles"


# Mercurial/hg shorthands
alias allyourrebase="hg pull && hg rebase -r 'draft()' -d master"
alias hgupall="hg pull && allyourrebase && hg up master"
alias hgeverything="allyourrebase && arc feature --cleanup"
alias master="hg up master"
alias hum="hg up master"
alias hinf="hg show --stat"


# Git
# most git shorthands are in the git config
rebaserino () {
  git rebase -i `git merge-base HEAD ${1:-main}`
}


# Utilities for piping.
function after {
    perl -pe "s|.*?$1||"
}
function before {
    sed "s|$1.*||"
}
function prepend {
    sed "s|^|$1|"
}
function append {
    sed "s|$|$1|"
}
alias stripcolors="sed $'s,\x1b\\[[0-9;]*[a-zA-Z],,g'"


# replace/sed/rg stuff
replacerino() {
  rg $1 -l | xargs -I{} sed -i '' "s/$1/$2/g" {}
}
replacerinofile() {
  sed -i '' "s/$1/$2/g" $3
}
deleterino() {
  rg $1 -l | xargs -I{} sed -i '' "/$1/d" {}
}


# Other `PATH` additions
export PATH=$PATH:$HOME/bin
export PATH=$PATH:$HOME/.local/bin
# arduino path
export PATH=$PATH:$HOME/Library/Arduino15/packages/arduino/tools/bossac/1.7.0-arduino3
# ruby just to get my blog to work
export PATH="/usr/local/opt/ruby@2.7/bin:$PATH"
export PATH="$HOME/.gem/ruby/2.7.0/bin:$PATH"
# brew on silicon macs
export PATH="/opt/homebrew/bin:$PATH"
# Created by `pipx` on 2021-12-06 22:48:19
export PATH="$PATH:/Users/gus/.local/bin"
# kubernetes
export PATH="/opt/homebrew/opt/kubernetes-cli@1.22/bin:$PATH"
# Pulumi
export PATH=$PATH:$HOME/.pulumi/bin
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
export PATH="$HOME/go:$PATH"
# go for karpenter and stuff
export PATH="$PATH:${GOPATH:-$HOME/go}/bin"
# jdk
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
# scale
export PATH="$PATH:/Users/gus/Library/Application Support/Coursier/bin"


# work-specific
# TODO(guswynn): figure this out!
if test -f ~/.zshrc-work; then
  source ~/.zshrc-work
fi
# work-specific
# TODO(guswynn): figure this out!
if test -f ~/.zshrc-work; then
  source ~/.zshrc-work
fi
