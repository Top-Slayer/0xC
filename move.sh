case "$(uname -s)" in
    Darwin) cp -R nvim/. ~/.config/nvim ;;
    Linux)  cp -r ./nvim/ ~/.config/    ;;
esac

mkdir -p ~/.config/tmux && cp -r tmux.conf ~/.config/tmux

if [ ! -d ~/.config/tmux/plugins/tpm ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
fi

