# dotfiles
a focus on rust

## Terminfo:
- run `tic path/to/terminfo.src` in `$HOME`
  - Or with `-x` if needed

## TODO:
- wezterm NATIVE multiplexing
- document issue #2 (font usage)
- document color usage
- better way to link dotfiles
- switch to coc.nvim for rust-analyzer
- resolve rust-analyzer issues
- more cleanup
- document terminfo stuff (home and end issues)
- document rustfmt usage
- .zshrc should +nightly rustfmt
- fix prompt info
- vim mode for tmux
- vim `mouse=a` without problems
- Figure out why `-x` is needed on `tic` sometimes

# macos gui setup hints:
- Mouse speed
- non-natural scrolling
- scroll speed
- TODO: More here
 
# Helpful links
- https://github.com/jonhoo/configs/blob/master/editor/.config/nvim/init.vim
  - And others

# Things to install
- brew
- wezterm
- maccy
- git branchless
- also install fd, rg, sd, and lima.

font:
- https://github.com/jesusmgg/comic-shanns-mono
- Iosevka Term Light various others


## Install
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
