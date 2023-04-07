# load zinit plugin manager
source /usr/share/zinit/zinit.zsh # yay -S zinit-git
zstyle :compinstall filename '$HOME/.zshrc'

# Kitty stuff
autoload -Uz compinit
compinit

## PLUGINS ##
zinit light trapd00r/LS_COLORS
zinit load zdharma-continuum/history-search-multi-word
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting
zinit snippet https://gist.githubusercontent.com/hightemp/5071909/raw/

## INCLUDES ##
source $HOME/.zsh_include/git/git.zsh
source $HOME/.zsh_include/themes/agnoster.zsh-theme


# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history #histfile
HISTSIZE=10000
SAVEHIST=10000

## ALIAS ##
alias ..="cd .."
alias ytmp3="youtube-dl -x --audio-format mp3 --no-mtime --add-metadata --xattrs --embed-thumbnail -o '%(title)s.%(ext)s' "
alias yt="youtube-dl --add-metadata "
alias md5="python3 /home/chiya/Documents/scripts/md5.py"
alias ll="ls -aslhpx --group-directories-first"
alias history="history 1"
#alias ls="exa"

## BINDKEY ###
bindkey  "^[[H"   beginning-of-line
bindkey  "^[[F"   end-of-line
bindkey  "^[[3~"  delete-char
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward


# Completion for kitty
#kitty + complete setup zsh | source /dev/stdin

# Don't know what this is
alias composer="XDEBUG_MODE=off composer"

## EXPORTS ##

# Japanese in the terminal
export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export XMODIFIERS=@im=ibus

# R
export R_PROFILE=~/.Rprofile


## PROMPT ##
# https://i.pinimg.com/originals/71/fc/88/71fc88a521c1a0c67768b15e79fb46c9.jpg
# #f5b6ac
# #222d3a
# #C2A4B4
# #495B7A
# #536988
# #7A85AA

## Main prompt
build_prompt() {
  RETVAL=$?
  prompt_status
  prompt_virtualenv
  prompt_aws
  prompt_context
  prompt_dir
  prompt_git
  prompt_bzr
  prompt_hg
  prompt_end
}

precmd() {
  PROMPT="$(build_prompt) "
  #PROMPT="%K{#f5b6ac}%F{231} 無名 %K{#536988}%F{#f5b6ac}%K{#536988}%F{#f5b6ac} %~ %k%F{#536988}${THEME_PROMPT} "
}

PS1="ahhhhhhHHHHHHHHHHHHHHHHHH!!" # shell prompt