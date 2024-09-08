sudo apt-get -y install $(< packages.list) && \
cd ~ && \
git clone git@github.com:Gibsonguy911/stow.git ~/dotfiles && \
curl -o https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash && \
export NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
nvm install --lts && npm i -g npm && \
wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash && \
curl -o https://ohmyposh.dev/install.sh | bash && \
curl -O https://github.com/neovim/neovim/releases/download/stable/nvim.appimage && \
chmod u+x nvim.appimage && ./nvim.appimage && \
rm ~/.zshrc && cd ~/dotfiles && stow . && \
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && \
cd ~/.fzf && ./install --key-bindings --completion --no-update-rc
git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab && \
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
