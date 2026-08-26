# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return;;
esac


# if test -z ${TMUX} && which tmux &>/dev/null; then
#   ID="`tmux ls | grep -vm1 attached | cut -d: -f1`" # get the id of a deattached session
#   if [[ -z ${ID} ]] ;then # if not available create a new one
#     exec tmux -2 new-session
#   else
#     exec tmux -2 attach-session -t ${ID} # if available attach to it
#   fi
#   # # when quitting tmux, try to attach
#   # while test -z ${TMUX}; do
#   #   exec tmux -2 attach || break
#   # done
# fi


shopt -s autocd  # Allows you to cd into directory merely by typing the directory name.

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
# HISTSIZE=10000
# HISTFILESIZE=20000
HISTSIZE= HISTFILESIZE=  # Infinite histroy

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# Source the git bash completion file
if [ -f ~/.git-completion.bash ]; then
    source ~/.git-completion.bash
    # GIT_PS1_SHOWDIRTYSTATE=true
    # GIT_PS1_SHOWSTASHSTATE=true
    # GIT_PS1_SHOWUPSTREAM="auto"
    # PS1='\t:\[\033[32m\]$(__git_ps1 " (%s)")\[\033[00m\] \W$ '
fi

[ -f ~/.git-prompt.sh ] && source ~/.git-prompt.sh

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    # PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ 'TH
    # PS1='\[\033[0;32m\]\u\[\033[0;36m\] @ \h \w\[\033[0;32m\]$(__git_ps1)\n└─ ▶\[\033[0m\] '
    PS1='${debian_chroot:+($debian_chroot)}\[\033[0;36m\]\w\[\033[0;32m\]$(__git_ps1)\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

[ -f ~/.aliases ] && source ~/.aliases
if which nvim &>/dev/null ; then
  export EDITOR='nvim'
  export MANPAGER="nvim --cmd 'let is_view=1' -c 'set ft=man ts=8 nomod nolist nonu noma' +Man!"
else
  export EDITOR='vim'
fi
which most &>/dev/null && export PAGER="most"

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
#if [ -f ~/.local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh ]; then
#    source ~/.local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh
#    export PATH="$HOME/.local/bin:$PATH"
#    export POWERLINE_COMMAND=powerline
#    export POWERLINE_CONFIG_COMMAND=powerline-config
#    powerline-daemon -q
#    POWERLINE_BASH_CONTINUATION=1
#    POWERLINE_BASH_SELECT=1
#fi
[ -d $HOME/.local ] && PATH=$HOME/.local/bin:$PATH

## export sudo apt-get install most
which most &>/dev/null && export PAGER="most"

## GO:
export GOPATH=$HOME
if ! which go &>/dev/null && [ -d $HOME/go ] ; then
  export GOROOT=$HOME/go
  PATH="$PATH:$GOROOT/bin"
fi
export PATH="$PATH:$GOPATH/bin"
export GO111MODULE=on

[ -s "/home/nad2000/.dnx/dnvm/dnvm.sh" ] && . "/home/nad2000/.dnx/dnvm/dnvm.sh" # Load dnvm


## Android Studio:
export ANDROID_HOME=~/Android/Sdk
export ANDROID_STUDIO
if [ -d $ANDROID_HOME ] ; then
  PATH=${PATH}:${ANDROID_HOME}/tools
fi
[ -d ~/android-studio/jre/bin ] && PATH=~/android-studio/jre/bin:$PATH
[ -d ~/spark-2.0.1-bin-hadoop2.7 ] && PATH=~/spark-2.0.1-bin-hadoop2.7/bin:$PATH
## [ -d $HOME/.cargo/bin ] && PATH=$HOME/.cargo/bin:$PATH
[ -d /snap ] && PATH=/snap/bin:$PATH

which kubectl &>/dev/null && source <(kubectl completion bash)

# AWS completion:
[ -f aws_bash_completer ] && . aws_bash_completer

# Orcid Hub environments:
export ENV=dev
# export ENV=test
# export POSTGRES_PASSWORD=<...>
# export POSTGRES_USER=<...>
# export PGPASSWORD=<...>
# export PGUSER=<...>
# export PGHOST=
# export PGDATABASE=<...>

export P12_PASSWORD=p455w0rd
export SHIB_SP_DOMAINNAME=${ENV}.orcidhub.org.nz
export SHIB_IDP_DOMAINNAME=directory.test.tuakiri.ac.nz
export METADATA_CERT_FILE=tuakiri-test-metadata-cert.pem
export TOKEN_PASSWORD_SALT=testsalt
export TOKEN_SECRET_KEY=testsecret
export FLASK_APP=orcid_hub

export MAIL_SERVER=dev.orcidhub.org.nz
export MAIL_PORT=2525

export UID USER_GID=$(id -g)
export OAUTHLIB_INSECURE_TRANSPORT=1
export ORCID_CLIENT_ID=APP-6DZOOMOKJCYRY6GE
export SHIB_METADATA_PROVIDER_URI=https://directory.test.tuakiri.ac.nz/metadata/tuakiri-test-metadata-signed.xml
export FLASK_ENV=development

export FZF_DEFAULT_OPS="--extended"


# NPM packages in homedir
NPM_PACKAGES="$HOME/.npm-packages"

# Tell our environment about user-installed node tools
PATH="$NPM_PACKAGES/bin:$PATH"
  if which manpath &>/dev/null ; then
  # Unset manpath so we can inherit from /etc/manpath via the `manpath` command
  unset MANPATH  # delete if you already modified MANPATH elsewhere in your configuration
  MANPATH="$NPM_PACKAGES/share/man:$(manpath)"
fi

# Tell Node about these packages
NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"
[ -d $HOME/node_modules/.bin ] && PATH=$HOME/node_modules/.bin:$PATH

# added by travis gem
[ -f /home/rcir178/.travis/travis.sh ] && source /home/rcir178/.travis/travis.sh

# Swap CAPS with ESC:
#which /usr/bin/setxkbmap &>/dev/null && /usr/bin/setxkbmap -option "caps:swapescape"

if [ -d $HOME/dotnet ] ; then
  export DOTNET_ROOT=$HOME/.dotnet
  export PATH=$PATH:$HOME/.dotnet
fi

# # IBus support:
# export GTK_IM_MODULE=ibus
# export XMODIFIERS=@im=ibus
# export QT_IM_MODULE=ibus
# Fcitx: https://wiki.archlinux.org/title/Fcitx#Set_environment_variables_for_IM_modules
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS='@im=fcitx'
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f $PREFIX/etc/profile.d/command-not-found.sh ] && source $PREFIX/etc/profile.d/command-not-found.sh
