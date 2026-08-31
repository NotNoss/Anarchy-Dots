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
  git
  base-devel
  fzf
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

echo "Installing yay..."
git clone https://aur.archlinux.org/yay.git "$HOME/yay"
cd "$HOME/yay"
makepkg -si
rm -rf "$HOME/yay"

echo "Synchronizing package databases..."
yay -Sy

echo "Installing packages..."
sudo pacman -S --needed --noconfirm "${packages[@]}"
yay -S --needed --noconfirm "${aur_packages[@]}"

echo "Creating dotfiles directories..."
mkdir -p "$HOME/.config/anarchy/.cache/"

echo "Cloning github repo..."
cd "$HOME/.config/anarchy/"
git clone https://github.com/NotNoss/Anarchy-Dots.git ./dots

echo "Creating symlinks..."
cd "$HOME/.config/anarchy/dots/home/"
stow -t "$HOME" .

cd "$HOME"

echo "Setting shell..."
chsh -s $(which zsh)

echo "Installing fonts..."
sudo cp "$HOME/.config/anarchy/dots/fonts/*" /usr/share/fonts/
fc-cache -f -v

echo "Setting wallpaper..."
awww-daemon &
awww img "$HOME/.config/anarchy/Wallpapers/montagna.png"
pkill awww

echo "Setting up SDDM..."
sudo cp "$HOME/.config/anarchy/Wallpapers/montagna.png" /usr/share/sddm/themes/silent/backgrounds/
sudo sed -i "s/smoky.jpg/montagna.png/g" /usr/share/sddm/themes/silent/configs/default.conf
/usr/share/sddm/themes/silent/change_avatar.sh $(echo $USER) "$HOME/.config/anarchy/Anarchy-Logo.png"
sudo cp "$HOME/.config/anarchy/dots/sddm.conf" /etc/

sudo systemctl enable sddm --now

echo "Done. Everything should be setup now"
