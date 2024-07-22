# Basic configs

# TODO(guswynn): investigate what this is
export CLICOLOR=true

# History stuff
export HISTFILE="$HOME/.zsh-history"
export HISTSIZE=SAVEHIST=10240
export LESSHISTFILE="-" # disable less history
export HISTSIZE=100000

# TODO(guswynn): investigate each of these
setopt APPEND_HISTORY
setopt AUTO_CD
setopt COMPLETE_ALIASES
setopt COMPLETE_IN_WORD
setopt CORRECT
unset EXTENDED_GLOB
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt LOCAL_OPTIONS # allow functions to have local options
setopt LOCAL_TRAPS # allow functions to have local traps
setopt NO_HUP
setopt NO_LIST_BEEP
setopt PROMPT_SUBST
setopt interactivecomments
unsetopt CASE_GLOB
KEYTIMEOUT=1
zle -N newtab


# Zsh completion style

# required for the following zstyles to work
#
# Also required when using homebrew
# https://stackoverflow.com/questions/13762280/zsh-compinit-insecure-directories
# basically, g-w the compaudit files
autoload -Uz compinit
compinit -z

# nice selection menu
zstyle ':completion:*' menu select
# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending


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


# TODO(guswynn): investigate what this is
autoload colors; colors


# Prompt

# Used below
cwd () {
  dir="${PWD/#$HOME/~}"
  dir="${dir//\/data\/users\/$USER/~}"
  echo "$dir"
}

# vcs stuff.
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

# reset prompt in vi mode
function zle-line-init zle-keymap-select {
	zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select


# Vim

# vim multiple files opens in vsplits
alias vim='nvim -O'
export EDITOR=nvim


# `PATH`
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


# TODO(guswynn): investigate this
unset USERNAME


# Mercurial/hg shorthands
alias allyourrebase="hg pull && hg rebase -r 'draft()' -d master"
alias hgupall="hg pull && allyourrebase && hg up master"
alias hgeverything="allyourrebase && arc feature --cleanup"
alias master="hg up master"
alias hum="hg up master"
alias hinf="hg show --stat"


# git shorthands are in the git config


# `time` formatting
export TIMEFMT=$'\nreal\t%*E\nuser\t%*U\nsys\t%*S'


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


# Rust
export PATH="$HOME/.cargo/bin:$PATH"
export RUST_BACKTRACE=1
# cargo/rust stuff
alias cargo-config="cargo +nightly -Zunstable-options config get"

# Moving around my repos.
alias repos="cd ~/repos"
alias work="cd ~/work"
alias rust="cd ~/repos/rust"
alias dotfiles="cd ~/repos/dotfiles"


# Git stuff
# TODO(guswynn): clean this all up.
#
# try this out to clean up githup better
# current notes: checkout main and pull upstream main first
# (well, trying to have main track upstream/main to not have to do this)
# effort 3 is because of squashed-and-merged pr's
# you have still have to manually delete the remote branches
#alias git-dmb="git-delete-merged-branches --effort 3"
# git-shows () {
#  git show HEAD...$(git merge-base HEAD main)
# }
# for git-fixup
export GIT_INSTAFIX_UPSTREAM=main
export GIT_INSTAFIX_REQUIRE_NEWLINE=y
rebaserino () {
  git rebase -i `git merge-base HEAD ${1:-main}`
}


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


# Zsh 

# shorthand to reload this file
alias reloadprof='source ~/.zshrc'

# work-specific
if test -f ~/.zshrc-work; then
  source ~/.zshrc-work
fi
