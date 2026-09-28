export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=""

zstyle ':omz:update' mode auto      # update automatically without asking

HIST_STAMPS="dd.mm.yyyy"

plugins=(git)
[[ -d "$ZSH/custom/plugins/zsh-autosuggestions" ]] && plugins+=(zsh-autosuggestions)

export PATH="$HOME/.local/bin:$PATH"

source $ZSH/oh-my-zsh.sh

[[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env" # uv

bindkey '^ ' autosuggest-accept # accept autocomplete

eval "$(starship init zsh)" # theme
