#!/bin/bash

packages=(
  ghostty
  hyprland
  hyprpicker
  hyprlock
  awww
  matugen
  neovim
  yazi
  ripgrep
  serpl
  lazygit
  npm
  tree-sitter
  tree-sitter-cli
  quickshell
  ttf-firacode-nerd
  slurp
  grim
  hyprpicker
  polkit
  playerctl
  tmux
  zoxide
  zsh
  yarn
  stow
  sddm
)

aur_packages=(
  oh-my-posh
  ttf-material-symbols-variable-git
  sddm-silent-theme
)

if [[ $EUID -eq 0 ]]; then
  echo "Please run the script as a normal user. The install script will call sudo when needed." >&2
  exit 1
fi

echo "Synchronizing package databases..."
yay -Sy

echo "Installing packages..."
sudo pacman -S --needed --noconfirm "${packages[@]}"
yay -S --needed --noconfirm "${aur_packages[@]}"

echo "Creating dotfiles directories..."
mkdir -p "$HOME/.config/anarchy/.cache/"

echo "Cloning github repo..."
git clone "https://github.com/NotNoss/Anarchy-Dots.git" "$HOME/.config/anarchy/dots"

echo "Creating symlinks..."
cd "$HOME/.config/anarchy/dots/home/"
stow -t "$HOME" .

cd "$HOME/.config/anarchy/dots/etc/"
sudo stow -t "/etc/" .
/usr/share/sddm/themes/silent/change_avatar.sh "$USER" "$HOME/.config/anarchy/dots/Anarchy-Logo.png"

echo "Enabling SDDM..."
sudo systemctl enable --now sddm

echo "Done. Everything should be setup now"
