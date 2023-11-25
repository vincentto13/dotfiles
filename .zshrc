# Locale setup (FIX)
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# PATH setup
export PATH=$PATH:$HOME/.local/bin

alias vim=nvim

ZSH_THEME="robbyrussell"
#ZSH_THEME="powerlevel10k/powerlevel10k"

# powerlevel10k
#if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
#fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

export ZSH_COMPDUMP="$HOME/.cache/zsh/.zcompdump-$HOST-$ZSH_VERSION"

#ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting web-search)

source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
#[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Adding Catpuccin ZSH styliing
[[ ! -f ${ZSH}/custom/themes/catppuccin/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh ]] || source ${ZSH}/custom/themes/catppuccin/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh

#[[ -f ~/.acme.sh/acme.sh.env ]] || source ~/.acme.sh/acme.sh.env
eval "$(starship init zsh)"
export STARSHIP_CONFIG=$HOME/.config/starship/starship.toml
