cp -r ./nvim/ ~/.config/
mkdir -p ~/.config/tmux && cp -r tmux.conf ~/.config/tmux

PLUGIN_PATH=
if [ ! -d ~/.config/tmux/plugins/tpm ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
fi

