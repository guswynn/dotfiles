export CLICOLOR=true

export HISTFILE="$HOME/.zsh-history"
export HISTSIZE=SAVEHIST=10240
export LESSHISTFILE="-" # disable less history

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

# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

zstyle ':completion:*' menu select

bindkey -v
bindkey '^[[Z' reverse-menu-complete
bindkey "${terminfo[khome]}" beginning-of-line
bindkey "${terminfo[kend]}" end-of-line
export TERMINFO=~/.terminfo
# see https://unix.stackexchange.com/questions/20298/home-key-not-working-in-terminal

autoload colors; colors

# shorthand to reload this file
alias reloadprof='source ~/.zshrc'

# nice
cwd () {
  dir="${PWD/#$HOME/~}"
  dir="${dir//\/data\/users\/$USER/~}"
  echo "$dir"
}

# new
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

set -o vi

PROMPT='%{$fg[magenta]%}%n@${HOSTNAME//.facebook.com} %{$fg[green]%}Helping %{$fg[blue]%}$(cwd) %{$fg[yellow]%} $(extra_prompt_info)
%{$fg[cyan]%}%D{%F} %* $(vi_mode) > %{$reset_color%}'

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

# reset prompt in vi mode
function zle-line-init zle-keymap-select {
	zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

# I still want reverse search mode
bindkey '^R' history-incremental-search-backward


export EDITOR=nvim
export PATH=$PATH:$HOME/bin
export PATH=$PATH:$HOME/.local/bin
export HISTSIZE=100000

unset USERNAME

# vim multiple files opens in vsplits
# and other vim related things
alias vim='nvim -O'
alias regen-ctags='pcode;ctags -R -L ~/ctags.list --python-kinds=-i;p;pfig;ctags -R -L ~/ctags.list --python-kinds=-i;p'


alias allyourrebase="hg pull && hg rebase -r 'draft()' -d master"
alias hgupall="hg pull && allyourrebase && hg up master"
alias hgeverything="allyourrebase && arc feature --cleanup"
alias master="hg up master"
alias hum="hg up master"

alias hinf="hg show --stat"

# oopsie
alias ack="echo use ag you dum dum"
alias ag="echo use rg you dum dum"
function rg() {
    if [ -t 1 ]; then
        command rg -p "$@" | less -RFX
    else
        command rg "$@"
    fi
}


alias H="awk '{print \$2}'"
alias P="awk '{print \$2 \":22\"}'"
alias P1="awk '{print \$1 \":22\"}'"
alias C1="awk '{print \$1}'"
alias C2="awk '{print \$2}'"
alias C3="awk '{print \$3}'"
alias C4="awk '{print \$4}'"
alias C5="awk '{print \$4}'"
alias S="awk -F: '{print \$1}'"

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

# rust
export PATH="$HOME/.cargo/bin:$PATH"

# ls
alias ls="exa"
export EXA_COLORS="di=34:dotfiles=32:config_stuff=32"

# movement
alias code="cd ~/repos"
alias repos="cd ~/repos"
alias dot="cd ~/repos/dotfiles"
alias dotfile="cd ~/repos/dotfiles"
alias dotfiles="cd ~/repos/dotfiles"
