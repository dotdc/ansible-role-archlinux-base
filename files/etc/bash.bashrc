#!/bin/bash

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[[ $DISPLAY ]] && shopt -s checkwinsize

PS1='[\u@\h \W]\$ '

case ${TERM} in
  xterm*|rxvt*|Eterm|aterm|kterm|gnome*)
    PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'                                                          

    ;;
  screen*)
    PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033_%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'                                                          
    ;;
esac

[[ -r /usr/share/bash-completion/bash_completion ]] && . /usr/share/bash-completion/bash_completion

################################################################################
# Shell Options
################################################################################

shopt -s histappend
shopt -s expand_aliases

################################################################################
# Environment Variables
################################################################################

export LANG="en_US.UTF-8"
export TERM="xterm"

export VISUAL="/usr/bin/vim -p -X"
export EDITOR="/usr/bin/vim"

################################################################################
# Aliases
################################################################################

alias vi="vim -b"
alias vim="vim -b"

alias ls="ls --color=auto"
alias ll="ls -hails --color=auto"

alias grep="grep --color=auto --binary-files=without-match --devices=skip"

alias pacman="pacman --color auto"

################################################################################
# Functions
################################################################################

# Molokai colors for man
man()
{
    env LESS_TERMCAP_mb="$(printf "\e[38;5;202m")" \
    LESS_TERMCAP_md="$(printf "\e[38;5;202m")" \
    LESS_TERMCAP_me="$(printf "\e[0m")" \
    LESS_TERMCAP_se="$(printf "\e[0m")" \
    LESS_TERMCAP_so="$(printf "\e[48;5;82m\e[38;5;0m")" \
    LESS_TERMCAP_ue="$(printf "\e[0m")" \
    LESS_TERMCAP_us="$(printf "\e[38;5;82m")" \
    man "$@"
}

################################################################################
# Prompt
################################################################################

RED=$(echo -e "\[\e[38;5;196m\]")
WHITE=$(echo -e "\[\e[38;5;7m\]")
BLUE=$(echo -e "\[\e[38;5;45m\]")
GREEN=$(echo -e "\[\e[38;5;46m\]")
YELLOW=$(echo -e "\[\e[38;5;226m\]")

# Change char and color for root
if [[ "$(id -u)" -eq 0 ]] ; then
    PS1_USER="#"
    PS1_COLOR="${RED}"
else
    PS1_USER="\$"
    PS1_COLOR="${YELLOW}"
fi

# Display the current git branch
__git_ps1()
{
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Print return code if not 0 
__prompt_command()
{
    EXIT="$?"
    [[ "${EXIT}" != 0 ]] && echo -e "${R}[ Return code : ${EXIT} ]${W}"
}

PS1="${PS1_COLOR}\u${WHITE}@${GREEN}\h ${WHITE}\W${RED}\$(__git_ps1) ${PS1_USER} ${WHITE}"
export PS1
PS2="${BLUE}>${WHITE} "
export PS2
PS4="${BLUE}Line ${LINENO} >${WHITE} "
export PS4
export PROMPT_COMMAND=__prompt_command
