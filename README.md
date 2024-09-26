## [Stow](https://www.gnu.org/software/stow/) Repository for multiple dotfile configs including:
1. [Tmux](https://github.com/tmux/tmux/wiki)
2. [Zsh](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH)
3. [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh/wiki)
4. [Oh My Posh](https://ohmyposh.dev/docs/)
5. [Neovim](https://github.com/neovim/neovim)

### Installing (Ubuntu)
Run the install script in the script directory

This will:
1. Install dependencies including git if this script was copied to a fresh machine
2. Install Tmux and Zsh from package manager
3. Run the Oh My Zsh and Oh My Posh install scripts listed on their Github
4. Clone the latest v10 version of Neovim, make, and install

### Tmux dependencies
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

### Neovim dependencies
1. fzf
2. fd-find
3. nvm
4. node
5. dotnet

### Npm dependencies
1. prettierd
2. neovim

## Terminal Theme
dconf load /org/gnome/terminal/legacy/profiles:/ < gnome-terminal-profiles.dconf
