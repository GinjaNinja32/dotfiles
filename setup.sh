
# if we don't have git, we can't do much
if ! which git > /dev/null; then
	echo "install git before running this!"
	exit 1
fi

# helper
linkit() {
	# Canonicalise both paths
	link_name=$(readlink -m $1)
	link_target=$(readlink -m $2)
	# If canonical name of target == canonical name of new link,
	# then one of the following is true:
	# - They are the same file
	# - Both are symlinks to the same file
	# - One is a symlink to the other
	# In all three cases, there's no point doing the rest of `linkit`.
	[[ $link_name == $link_target ]] && return

	# Don't overwrite existing files!
	if [[ -e "$link_name" ]]; then
		mv "$link_name" "$link_name.initial"
	fi

	ln -s "$link_target" "$link_name"
}

# bin!
mkdir -p ~/bin
linkit ~/bin/scripts scripts

# Shell things
linkit ~/.tmux.conf tmux.conf
linkit ~/.bashrc bashrc.sh
linkit ~/.profile profile

# Termite
mkdir -p ~/.config/termite
linkit ~/.config/termite/config termite_config

# i3
mkdir -p ~/.config/i3
linkit ~/.config/i3/config i3_config
linkit ~/.i3status.conf i3status.conf

# X11
linkit ~/.xinitrc xinitrc
linkit ~/.Xresources Xresources

# Git prompt
mkdir -p ~/bin/includes
curl -o ~/bin/includes/git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh

# ssh config
mkdir ~/.ssh
chmod 700 ~/.ssh
linkit ~/.ssh/config ssh_config

# git stuff start
mkdir ~/git
cd ~/git

# Helper function to clone things from GitHub
# We don't have ssh-ident etc set up yet (this helper is used to do it!),
# so we want to clone via HTTPS instead; any updates, though, we'll want
# to use SSH, so we change the URL after cloning.
github_clone() {
	git clone https://github.com/$1
	(cd ${1#*/}; git remote set-url origin git@github.com:$1)
}

# xcompose
github_clone kragen/xcompose
linkit ~/.XCompose dotXCompose

# ssh-ident
github_clone ccontavalli/ssh-ident
linkit ~/bin/ssh ~/git/ssh-ident/ssh-ident

# git stuff end
cd -

# vim
mkdir -p ~/.vim/colors
git clone https://github.com/VundleVim/Vundle.vim ~/.vim/bundle/Vundle.vim
linkit ~/.vimrc vimrc
linkit ~/.vim/colors/mycolors.vim vimcolors.vim
vim +PluginInstall +qall
