#
# ~/.zshrc
#

# path
typeset -U path
CONDA_PREFIX=$HOME/miniconda3
path=(~/bin ~/.local/bin $CONDA_PREFIX/bin $(ruby -r rubygems -e "puts Gem.user_dir")/bin $path)

# CMAKE prefix path
export CMAKE_PREFIX_PATH=/usr

# default programs
export EDITOR=vim
export BROWSER=chromium

# default parallel make
export MAKEFLAGS="-j$(nproc)"

# default less options
export LESS='-R -i'

# colored man pages
export LESS_TERMCAP_md=$'\E[34m'        # section headers, etc - blue
export LESS_TERMCAP_us=$'\E[36m'        # emphasized words - cyan
export LESS_TERMCAP_so=$'\E[07;33m'     # highlight, e.g. from searching - base color on yellow
export LESS_TERMCAP_me=$'\E[0m'         # reset
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'

# use GTK style for KDE/Qt apps (install qt5-styleplugins)
export QT_QPA_PLATFORMTHEME=gtk2

# ls colors
eval `dircolors ~/.dircolors`

# disable flow control
stty stop undef

# misc options
unsetopt beep
setopt auto_cd
setopt glob
setopt extended_glob
setopt correct

# useful modules
autoload -U zcalc zargs zmv

# print timing info for commands that run for longer than this number of seconds
REPORTTIME=10

# default command for a single input redirection
lessxf () { less -XF $@ }
READNULLCMD=lessxf


# history

# oh-my-zsh settings
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history


# completion
zmodload zsh/complist
autoload -U compinit

unsetopt menu_complete
unsetopt flow_control
setopt auto_menu
setopt complete_in_word
setopt always_to_end

zstyle ':completion:*' use-cache on
# approximate
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
# some lines from oh-my-zsh
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories

compinit


# prompt

autoload -U colors && colors
setopt prompt_subst

# left main prompt

# set color of username: root or normal user
if [[ $UID == 0 ]]; then
  user_color=$fg[red]
else
  user_color=$fg[blue]
fi

# set color of hostname: local or ssh
if [[ -n "$SSH_CLIENT" ]]; then
  host_color=$fg[yellow]
else
  host_color=$fg[blue]
fi

# other colors
sep_color=$reset_color
path_color=$fg[blue]
ret_color=$fg[red]
accent_color=$fg[green]

PROMPT="%{$user_color%}%n%{$sep_color%}@%{$host_color%}%m%{$sep_color%}:%{$path_color%}%~ %(?..%{$ret_color%}%? )%{$accent_color%}> %{$reset_color%}"

# right git prompt

# color and symbol settings
GIT_PROMPT_AHEAD="%{$fg[red]%}+"
GIT_PROMPT_BEHIND="%{$fg[cyan]%}-"
GIT_PROMPT_MERGING="%{$fg[magenta]%}⚡︎"
GIT_SYMBOL="▪"
GIT_PROMPT_UNTRACKED="%{$fg[red]%}$GIT_SYMBOL"
GIT_PROMPT_MODIFIED="%{$fg[yellow]%}$GIT_SYMBOL"
GIT_PROMPT_STAGED="%{$fg[green]%}$GIT_SYMBOL"
GIT_PROMPT_EMPTY="%{$fg[blue]%}$GIT_SYMBOL"


# find git branch/tag, or name-rev if on detached head
_git_branch () {
  (git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD) 2> /dev/null
}

# show different symbols as appropriate for various git states
_git_state () {
  local GIT_STATE=""

  local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
  [ "$NUM_AHEAD" -gt 0 ] && GIT_STATE=$GIT_STATE$GIT_PROMPT_AHEAD$NUM_AHEAD

  local NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
  [ "$NUM_BEHIND" -gt 0 ] && GIT_STATE=$GIT_STATE$GIT_PROMPT_BEHIND$NUM_BEHIND

  local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
  [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD && GIT_STATE=$GIT_STATE$GIT_PROMPT_MERGING

  [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]] && GIT_STATE=$GIT_STATE$GIT_PROMPT_UNTRACKED

  git diff --quiet 2> /dev/null || GIT_STATE=$GIT_STATE$GIT_PROMPT_MODIFIED

  git diff --cached --quiet 2> /dev/null || GIT_STATE=$GIT_STATE$GIT_PROMPT_STAGED

  [[ -n $GIT_STATE ]] || GIT_STATE=$GIT_PROMPT_EMPTY

  echo "$GIT_STATE"
}

# make prompt if inside a git repository
_git_prompt () {
  local git_where="$(_git_branch)"
  [ -n "$git_where" ] && echo "%{$path_color%}${git_where#(refs/heads/|tags/)}%{$sep_color%}:$(_git_state)%{$reset_color%}"
}

RPROMPT='$(_git_prompt)'

# aliases

# customized commands
alias ls="ls -ph --color=always --group-directories-first"
alias v="gvim"

function ok () { okular $@ &> /dev/null & }
function za () { zathura $@ &> /dev/null & }
function nose_cover () { nose --with-coverage --cover-erase --cover-package=$1 }
function nose_cov () { nose --with-cov --cov-report term-missing --cov=$1 }
function bf () {awk '/btrfs/ {print $2}' /proc/mounts | while read mnt; do echo $mnt; btrfs filesystem df $@ $mnt; echo; done}
