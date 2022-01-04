# TODO(guswynn): investigate what this is
export CLICOLOR=true

# History stuff
export HISTFILE="$HOME/.zsh-history"
export HISTSIZE=SAVEHIST=10240
export LESSHISTFILE="-" # disable less history

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

# vim mode
# set -o vi
# TODO(guswynn): why is this off
bindkey -v

# Fix some buttons
bindkey '^[[Z' reverse-menu-complete
bindkey "${terminfo[khome]}" beginning-of-line
bindkey "${terminfo[kend]}" end-of-line
export TERMINFO=~/.terminfo
# see https://unix.stackexchange.com/questions/20298/home-key-not-working-in-terminal

# TODO(guswynn): investigate what this is
autoload colors; colors

# nice
cwd () {
  dir="${PWD/#$HOME/~}"
  dir="${dir//\/data\/users\/$USER/~}"
  echo "$dir"
}

# just prompt stuff
# hg prompt (TODO(guswynn): git
function extra_prompt_info {
  local d hg fmt
  fmt="(%s)"
  d=$PWD
  while : ; do
      if test -d "$d/.hg" ; then
          hg=$d
          break
      fi
      test "$d" = / && break
      d=$(cd -P "$d/.." && echo "$PWD")
  done

  local dirstate=$(
      test -f "$hg/.hg/dirstate" && \
      cat "$hg/.hg/dirstate" | \
      hexdump -vn 20 -e '1/1 "%02x"' || \
      echo "empty"\
  )
  if [ "$dirstate" = "empty" ]; then
      return
  fi
  local current="$hg/.hg/bookmarks.current"
  if  [[ -f "$current" ]]; then
      br=$(cat "$current")
  else
      br=$(echo $dirstate | cut -c 1-7)
  fi
  if [ -n "$br" ]; then
      printf "$fmt" "$br"
  fi
}

# Get the mode for vi mode
function vi_mode() {
	local mode
	mode="${${KEYMAP/vicmd/N}/(main|viins)/I}"
	if [ -z "$mode" ]; then
		echo -n "I"
	else
		echo -n "$mode"
	fi
}

PROMPT='%{$fg[magenta]%}%n@mac %{$fg[green]%}Helping %{$fg[blue]%}$(cwd) %{$fg[yellow]%} $(extra_prompt_info)
%{$fg[cyan]%}%D{%F} %* $(vi_mode) > %{$reset_color%}'

# reset prompt in vi mode
function zle-line-init zle-keymap-select {
	zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

# I still want reverse search mode
bindkey '^R' history-incremental-search-backward

# vim multiple files opens in vsplits
# and other vim related things
alias vim='nvim -O'
export EDITOR=nvim

# More history stuff
export HISTSIZE=100000


# local binaries
export PATH=$PATH:$HOME/bin
export PATH=$PATH:$HOME/.local/bin

# TODO(guswynn): investigate this
unset USERNAME

# hg shorthands
alias allyourrebase="hg pull && hg rebase -r 'draft()' -d master"
alias hgupall="hg pull && allyourrebase && hg up master"
alias hgeverything="allyourrebase && arc feature --cleanup"
alias master="hg up master"
alias hum="hg up master"
alias hinf="hg show --stat"

# git shorthands are in the git config

# make time look like bash (almost)
export TIMEFMT=$'\nreal\t%*E\nuser\t%*U\nsys\t%*S'

# oopsie
alias ack="echo use ag you dum dum"
alias ag="echo use rg you dum dum"

# pipe utils
alias H="awk '{print \$2}'"
alias C1="awk '{print \$1}'"
alias C2="awk '{print \$2}'"
alias C3="awk '{print \$3}'"
alias C4="awk '{print \$4}'"
alias C5="awk '{print \$4}'"
# Get text before and after a substring
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

# cargo-installed command
export PATH="$HOME/.cargo/bin:$PATH"

# TODO(guswynn): ls -a is like ls -A, and you need ls -aa with this, so disabling for now
# ls and colors
# alias ls="exa"
# export EXA_COLORS="di=34:dotfiles=32:config_stuff=32"

# movement
alias code="cd ~/work || cd ~/repos"
alias repos="cd ~/repos"
alias rust="cd ~/repos/rust"
alias rust2="cd ~/repos/rust2"
alias dotfile="cd ~/repos/dotfiles"
alias dotfiles="cd ~/repos/dotfiles"
alias x="~/repos/rust/x.py"
alias x2="~/repos/rust2/x.py"

# shorthand to reload this file
alias reloadprof='source ~/.zshrc'

# arduino path
export PATH=$PATH:$HOME/Library/Arduino15/packages/arduino/tools/bossac/1.7.0-arduino3

# ruby just to get my blog to work
export PATH="/usr/local/opt/ruby@2.7/bin:$PATH"
export PATH="$HOME/.gem/ruby/2.7.0/bin:$PATH"

export RUST_BACKTRACE=1

# brew on silicon macs
export PATH="/opt/homebrew/bin:$PATH"

# confluent path (cli is in `~/bin`)
export CONFLUENT_HOME=/Users/gus/confluent

# materialize
alias mat="cd ~/work/materialize"
alias timely="cd ~/work/timely-dataflow"

# Created by `pipx` on 2021-12-06 22:48:19
export PATH="$PATH:/Users/gus/.local/bin"

# git stuff
#
# try this out to clean up githup better
# current notes: checkout main and pull upstream main first
# (well, trying to have main track upstream/main to not have to do this)
# effort 3 is because of squashed-and-merged pr's
# you have still have to manually delete the remote branches
alias git-dmb="git-delete-merged-branches --effort 3"
# TODO: figure out if this can be a git alias
alias git-show="git show HEAD...$(git merge-base HEAD main)"

# cargo/rust stuff
alias cargo-config="cargo +nightly -Zunstable-options config get"
