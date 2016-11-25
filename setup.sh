
if ! which git > /dev/null; then
	echo "install git before running this!"
	exit 1
fi

linkit() {
	[[ -e "$1" ]] && mv "$1" "$1.initial"
	ln -s "$HOME/dotfiles/$2" "$1"
}

# Config files
linkit ~/.tmux.conf tmux.conf
linkit ~/.bashrc bashrc.sh
linkit ~/.profile profile
linkit ~/.Xresources Xresources

if [[ -e ~/.i3 ]]; then
	linkit ~/.i3/config i3_config
	linkit ~/.i3status.conf i3status.conf
fi

# Git prompt
mkdir -p ~/bin/includes
curl -o ~/bin/includes/git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh

# git stuff start
mkdir ~/git
cd ~/git

# ssh-ident
git clone https://github.com/ccontavalli/ssh-ident
(cd ssh-ident; git remote set-url origin git@github.com:ccontavalli/ssh-ident)
linkit ~/bin/ssh ~/git/ssh-ident/ssh-ident
linkit ~/bin/ssh-ident ~/git/ssh-ident/ssh-ident

# git stuff end
cd -

# vim
mkdir -p ~/.vim/colors
git clone https://github.com/VundleVim/Vundle.vim ~/.vim/bundle/Vundle.vim
linkit ~/.vimrc vimrc
linkit ~/.vim/colors/mycolors.vim vimcolors.vim
vim +PluginInstall +qall
