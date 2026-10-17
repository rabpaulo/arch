#!/bin/bash
# Setup do notebook depois do install: configs (dots) + dwm, dwmblocks, st e dmenu (suckless-stuff).
# Requer: gh logado (gh auth login -h github.com -p https -w) e sudo.
set -euo pipefail

if ! gh auth status >/dev/null 2>&1; then
    echo "Rode antes: gh auth login -h github.com -p https -w"
    exit 1
fi
gh auth setup-git

echo ">> configs (dots)"
rm -rf "$HOME/temparq" "$HOME/.dotfiles"
git clone --separate-git-dir="$HOME/.dotfiles" https://github.com/rabpaulo/dots.git "$HOME/temparq"
rsync --recursive --exclude '.git' "$HOME/temparq/" "$HOME/"
rm -rf "$HOME/temparq" "$HOME/.dotfiles"

echo ">> suckless-stuff"
if [ -d "$HOME/suckless-stuff/.git" ]; then
    git -C "$HOME/suckless-stuff" pull
else
    gh repo clone rabpaulo/suckless-stuff "$HOME/suckless-stuff"
fi

for d in dwm dwmblocks st dmenu; do
    echo ">> instalando $d"
    (cd "$HOME/suckless-stuff/$d" && sudo make install)
done

echo "Pronto. Reinicie a sessao com: startx"
