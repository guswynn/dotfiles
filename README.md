# dotfiles

## Install
- brew
- ghostty
- fd, rg, sd
- lsps
- node
- jj


## Font
Note that I am considering Berkeley Mono as well...
- https://github.com/jesusmgg/comic-shanns-mono
- Iosevka Term Light various others
- Ligatures off in ghostty

## Connect to dotfiles
```
ln -s ~/repos/dotfiles/.zshrc .zshrc
ln -s ~/repos/dotfiles/.tmux.conf .tmux.conf

ln -s ~/repos/dotfiles/.gitconfig .gitconfig
ln -s ~/repos/dotfiles/.gitconfig-personal .gitconfig-personal
ln -s ~/repos/dotfiles/.gitconfig-work .gitconfig-work

ln -s ~/repos/dotfiles/.wezterm.lua .wezterm.lua

mkdir -p ~/.config/nvim
cd ~/.config/nvim
ln -s ~/repos/dotfiles/.config/nvim/init.lua init.lua
ln -s ~/repos/dotfiles/.config/nvim/lua lua

ln -s ~/repos/dotfiles/.config/zed zed

# also cargo config
```

## jj
I'm trying out jj. Rebase-and-merge is my main confusion right now.

## Neovim and LSP quirks
- cpp's clangd requires compile_commands.json to be generated
