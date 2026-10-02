# dotfiles

My Linux config files.

## Install

On a fresh machine:

```sh
sudo apt install git curl i3 alacritty rofi dunst network-manager \
  network-manager-gnome i3lock brightnessctl pulseaudio pavucontrol \
  lightdm lightdm-gtk-greeter feh flameshot pcmanfm lxappearance tmux
```

```sh
git clone --recurse-submodules git@github.com:temesgen-982/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

### Neovim Debian Install Steps

```sh
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo mkdir -p /opt/nvim-linux-x86_64
sudo chmod a+rX /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz

# make it available in /usr/local/bin, distro installs to /usr/bin
sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/
```
