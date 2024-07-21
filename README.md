# dotfiles

## Terminfo:
- run `tic path/to/terminfo.src` in `$HOME`
  - Or with `-x` if needed


## macos gui setup hints:
- Mouse speed
- non-natural scrolling
- scroll speed
 

## Things to install
- brew
- wezterm
- maccy
- git branchless
- also install fd, rg, sd, and lima.


## Font
Note that I am considering Berkeley Mono as well...
- https://github.com/jesusmgg/comic-shanns-mono
- Iosevka Term Light various others


# Install
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

# also cargo config
```
