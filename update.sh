rm -rf ~/.config/nvim/
# mkdir -p ~/.config/nvim/
# ln -fs $(realpath ./nvim) ~/.config/nvim
ln -Tfs "$(realpath ./nvim-config)" "$HOME/.config/nvim"
