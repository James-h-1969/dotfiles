# dotfiles

zsh (oh-my-zsh + starship), nvim (lazy.nvim, catppuccin) and tmux (catppuccin).

## WSL (Ubuntu)

```sh
git clone git@github.com:James-h-1969/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install-wsl.sh        # tools into ~/.local (no sudo), symlinks configs, installs nvim plugins/parsers
./windows-terminal.sh   # Nerd Font + catppuccin mocha for the Windows Terminal Ubuntu profiles
```

Symlinks: `~/.config/nvim`, `~/.config/tmux/tmux.conf`, `~/.zshrc` -> `.zsh`. Existing files are backed up as `*.bak.<timestamp>`.
