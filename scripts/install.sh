sudo apt-get -y install $(< packages.list) && \
cd ~ && \
curl -o https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash && \
export NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
nvm install --lts && npm i -g npm && \
curl -o https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash && \
curl -o https://ohmyposh.dev/install.sh | bash && \
curl -O https://github.com/neovim/neovim/releases/download/stable/nvim.appimage && \
chmod u+x nvim.appimage && ./nvim.appimage && \
git clone https://github.com/Gibsonguy911/stow.git ~/dotfiles && \
cd ~/dotfiles && stow . && \
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && \
cd ~/.fzf && ./install --key-bindings --completion --no-update-rc
