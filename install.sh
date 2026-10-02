#!/usr/bin/env bash
#
# Symlink the tracked configs into their live locations.
#
# Usage:
#   ./install.sh            create/repair links
#   ./install.sh --dry-run  report what is wrong, change nothing
#
# Safe to re-run: links that already point at the right place are left
# alone, and a real file sitting at a destination is never overwritten.

set -euo pipefail

repo=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
config_root=${XDG_CONFIG_HOME:-$HOME/.config}
dry_run=0

if [[ ${1:-} == --dry-run ]]; then
	dry_run=1
fi

status=0

# repo-relative source <TAB> destination.
# The heredoc is unquoted, so $config_root and $HOME expand when it is read.
while IFS=$'\t' read -r src dst; do
	if [[ -z $src || $src == \#* ]]; then
		continue
	fi

	src=$repo/$src

	if [[ ! -e $src && ! -L $src ]]; then
		printf 'MISSING  %s not found in repo\n' "$src" >&2
		status=1
		continue
	fi

	if [[ -L $dst ]]; then
		if [[ $(readlink "$dst") == "$src" ]]; then
			printf 'ok       %s\n' "$dst"
			continue
		fi
		action=relink
	elif [[ -e $dst ]]; then
		action=clash
	else
		action=link
	fi

	if [[ $action == clash ]]; then
		printf 'CLASH    %s exists and is not managed by this repo\n' "$dst" >&2
		printf '         move it aside first, e.g. mv %s %s.bak\n' "$dst" "$dst" >&2
		status=1
		continue
	fi

	if ((dry_run)); then
		printf 'would %s  %s -> %s\n' "$action" "$dst" "$src"
		continue
	fi

	mkdir -p "$(dirname -- "$dst")"
	# -n so an existing link-to-directory is replaced rather than followed,
	# -f so an existing broken link is replaced.
	ln -sfn "$src" "$dst"
	printf '%s  %s -> %s\n' "$action" "$dst" "$src"
done <<EOF
config/alacritty/alacritty.toml	$config_root/alacritty/alacritty.toml
config/dunst/dunstrc	$config_root/dunst/dunstrc
config/gtk-3.0/settings.ini	$config_root/gtk-3.0/settings.ini
config/i3/config	$config_root/i3/config
config/i3status/config	$config_root/i3status/config
config/rofi/config.rasi	$config_root/rofi/config.rasi
config/nvim	$config_root/nvim
home/.fehbg	$HOME/.fehbg
home/.gitconfig	$HOME/.gitconfig
home/.profile	$HOME/.profile
home/.tmux.conf	$HOME/.tmux.conf
home/.zshrc	$HOME/.zshrc
EOF

exit $status