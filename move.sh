case "$(uname -s)" in
    Darwin)
        mkdir -p ~/.config/nvim
        rm -rf ~/.config/nvim
        cp -R nvim/. ~/.config/nvim
        echo "Neovim config copied for macOS"
        ;;
    Linux)
        mkdir -p ~/.config/nvim
        rm -rf ~/.config/nvim
        cp -r ./nvim/ ~/.config/
        echo "Neovim config copied for Linux"

        mkdir -p "$HOME/.local/share/applications"
        printf '%s\n' \
            '[Desktop Entry]' \
            'Name=Neovim URL Handler' \
            "Exec=$HOME/.0xC/nvim_opener %u" \
            'Type=Application' \
            'Terminal=false' \
            'NoDisplay=true' \
            'MimeType=x-scheme-handler/nvim;' \
            > "$HOME/.local/share/applications/nvim-handler.desktop"
        ;;
esac


# TODO: make it support various shells
if [ -f "$HOME/.zshrc" ]; then
    CONF="$HOME/.zshrc"
fi

echo "Your config file is: $CONF"


if [ ! -d "$HOME/.0xC" ]; then
    mkdir "$HOME/.0xC"
    echo ".0xC dir created"

fi

MARK="# 0xC"
if ! grep -q "$MARK" ~/.zshrc; then
  printf '\n%s\n' "$MARK" >> ~/.zshrc
  printf '%s\n' \
    'export _0XC_INSTALL="$HOME/.0xC"' \
    'export PATH="$_0XC_INSTALL:$PATH"' \
    >> ~/.zshrc
fi


if [ -f "./target/release/nvim_opener" ]; then
    cp "./target/release/nvim_opener" "$HOME/.0xC"
fi


mkdir -p ~/.config/tmux && cp -r tmux.conf ~/.config/tmux

if [ ! -d ~/.config/tmux/plugins/tpm ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
fi

cp .gitconfig $HOME
cp .psqlrc $HOME
