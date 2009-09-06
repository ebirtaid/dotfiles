# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/ebirtaid/.zshrc'

autoload -Uz compinit promptinit
compinit
promptinit
setopt extended_glob                                                                                                                                 
#  preexec () {                                                                                                                                         
#
#	       if [[ "$TERM" == "screen" ]]; then                                                                                                               
#
#		                local CMD=${1[(wr)^(*=*|sudo|-*)]}                                                                                                           
#				         echo -ne "\ek$CMD\e\\"                                                                                                                       
#					      fi                                                                                                                                               
#					       }                        
# End of lines added by compinstall
#prompt suse
alias ls="ls --color=auto"


if [[ ${TERM} == "screen-bce" || ${TERM} == "screen" ]]; then
  precmd () { print -Pn "\033k\033\134\033k%m[%1d]\033\134" }
  preexec () { print -Pn "\033k\033\134\033k%m[$1]\033\134" }
else
  precmd () { print -Pn "\e]0;%n@%m: %~\a" }
  preexec () { print -Pn "\e]0;%n@%m: $1\a" }
fi
PS1=$'%{\e[0;32m%}%m%{\e[0m%}:%~> '
export PS1

alias pacman='sudo pacman-color'
function pacman; pacman-color $argv;
compdef pacman-color=pacman
alias nano='nano -w'
