#!/usr/bin/env bash
# Set up these dotfiles on WSL (Ubuntu) without sudo.
# Installs nvim, starship, ripgrep, fd, tree-sitter and win32yank into ~/.local,
# (tree-sitter is built with a user-local rustup/cargo),
# then symlinks the configs. Safe to re-run.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN="$HOME/.local/bin"
OPT="$HOME/.local/opt"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$BIN" "$OPT" "$HOME/.config/tmux/plugins"

latest() { curl -fsSL "https://api.github.com/repos/$1/releases/latest" | sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p'; }

# fetch URL, extract tarball into $TMP
untar() { curl -fsSL -o "$TMP/dl.tgz" "$1" && tar xzf "$TMP/dl.tgz" -C "$TMP" "${@:2}" && rm "$TMP/dl.tgz"; }

link() {
  local src="$1" dst="$2"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    mv "$dst" "$dst.bak.$(date +%s)"
    echo "backed up $dst"
  fi
  ln -sfn "$src" "$dst"
  echo "linked $dst -> $src"
}

echo "==> neovim"
v=$(latest neovim/neovim)
untar "https://github.com/neovim/neovim/releases/download/$v/nvim-linux-x86_64.tar.gz"
rm -rf "$OPT/nvim" && mv "$TMP/nvim-linux-x86_64" "$OPT/nvim"
ln -sfn "$OPT/nvim/bin/nvim" "$BIN/nvim"

echo "==> starship"
untar "https://github.com/starship/starship/releases/latest/download/starship-x86_64-unknown-linux-musl.tar.gz" starship
install -m755 "$TMP/starship" "$BIN/starship"

echo "==> ripgrep"
v=$(latest BurntSushi/ripgrep)
untar "https://github.com/BurntSushi/ripgrep/releases/download/$v/ripgrep-$v-x86_64-unknown-linux-musl.tar.gz"
cp "$TMP/ripgrep-$v-x86_64-unknown-linux-musl/rg" "$BIN/rg"

echo "==> fd"
v=$(latest sharkdp/fd)
untar "https://github.com/sharkdp/fd/releases/download/$v/fd-$v-x86_64-unknown-linux-musl.tar.gz"
cp "$TMP/fd-$v-x86_64-unknown-linux-musl/fd" "$BIN/fd"

echo "==> tree-sitter cli (needed by nvim-treesitter; prebuilt binaries need glibc 2.39, so build it)"
if ! tree-sitter --version >/dev/null 2>&1; then
  [ -x "$HOME/.cargo/bin/cargo" ] || curl -fsSL https://sh.rustup.rs | sh -s -- -y --profile minimal --no-modify-path
  rm -f "$BIN/tree-sitter"
  "$HOME/.cargo/bin/cargo" install --locked tree-sitter-cli --root "$HOME/.local"
fi

echo "==> win32yank (clipboard between nvim and Windows)"
curl -fsSL -o "$TMP/wy.zip" "https://github.com/equalsraf/win32yank/releases/latest/download/win32yank-x64.zip"
unzip -oq "$TMP/wy.zip" -d "$TMP/wy" && install -m755 "$TMP/wy/win32yank.exe" "$BIN/win32yank.exe"

echo "==> tmux catppuccin theme"
cat_dir="$HOME/.config/tmux/plugins/catppuccin/tmux"
if [ ! -d "$cat_dir" ]; then
  git -c advice.detachedHead=false clone -q --depth 1 -b v2.3.1 https://github.com/catppuccin/tmux.git "$cat_dir"
fi

echo "==> oh-my-zsh + zsh-autosuggestions"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
as_dir="$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
[ -d "$as_dir" ] || git clone -q --depth 1 https://github.com/zsh-users/zsh-autosuggestions "$as_dir"

echo "==> symlinks"
link "$DOTFILES/nvim" "$HOME/.config/nvim"
link "$DOTFILES/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"
link "$DOTFILES/.zsh" "$HOME/.zshrc"

echo
echo "==> nvim plugins + treesitter parsers"
PATH="$BIN:$PATH" nvim --headless "+Lazy! restore" +qa
PATH="$BIN:$PATH" nvim --headless "+lua require('nvim-treesitter').install(require('lazy.core.config').plugins['nvim-treesitter'].opts.ensure_installed):wait(300000)" +qa

echo "Done. Open a new shell (or run: exec zsh)."
echo "Run ./windows-terminal.sh for the Nerd Font + catppuccin Windows Terminal colours."
