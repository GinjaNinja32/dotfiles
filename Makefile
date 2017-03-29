DOTFILES = $(shell pwd)

.PHONY: arch-packages
arch-packages:
	# make temp dir for AUR installs
	mkdir -p ~/tmp/aur
	cd ~/tmp/aur
	
	# change PKGEXT to .pkg.tar, we don't need compression for AUR builds
	sudo sed -i "s/PKGEXT='.pkg.tar.xz'/PKGEXT='.pkg.tar'/" /etc/makepkg.conf
	
	# Install cower and pacaur
	git clone aur.archlinux.org/cower && cd cower && makepkg -sri
	git clone aur.archlinux.org/pacaur && cd pacaur && makepkg -sri
	
	pacaur -S tig

.PHONY: arch-gui-packages
arch-gui-packages:
	pacaur -S xorg-xinit i3 dmenu \
				termite \
				pulseaudio pavucontrol \
				noto-fonts noto-fonts-emoji noto-fonts-cjk \
				ttf-dejavu \
				evince

.PHONY: arch-lib32
arch-lib32:
	# enable multilib and update package list
	sudo sed -i "s|#[multilib]|[multilib]\nInclude = /etc/pacman.d/mirrorlist|" /etc/pacman.conf
	pacaur -Syu
	
	# install packages
	pacaur -S lib32-libpulse steam

.PHONY: shell-config
shell-configs:
	./link $(DOTFILES)/tmux.conf ~/.tmux.conf
	./link $(DOTFILES)/bashrc.sh ~/.bashrc
	./link $(DOTFILES)/profile ~/.profile
	mkdir -p ~/bin/includes
	./link $(DOTFILES)/bin/scripts ~/bin/scripts
	curl -o ~/bin/includes/git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh

.PHONY: termite-config
termite-config:
	mkdir -p ~/.config/termite
	./link $(DOTFILES)/termite_config ~/.config/termite/config

.PHONY: i3-config
i3-config:
	mkdir -p ~/.config/i3
	./link $(DOTFILES)/i3_config ~/.config/i3/config

.PHONY: x-config
x-config:
	./link $(DOTFILES)/xinitrc ~/.xinitrc
	./link $(DOTFILES)/Xresources ~/.Xresources
	./link $(DOTFILES)/dotXCompose ~/.XCompose

.PHONY: ssh-config
ssh-config:
	mkdir -p ~/.ssh
	chmod 700 ~/.ssh
	./link $(DOTFILES)/ssh_config ~/.ssh/config

.PHONY: vim-config
vim-config:
	mkdir -p ~/.vim/colors
	git clone https://github.com/VundleVim/Vundle.vim ~/.vim/bundle/Vundle.vim
	./link $(DOTFILES)/vimrc ~/.vimrc
	./link $(DOTFILES)/vimcolors.vim ~/.vim/colors/mycolors.vim
	vim +PluginInstall +qall

.PHONY: git-repos
git-repos:
	mkdir ~/git
	cd ~/git
	git clone https://github.com/kragen/xcompose
	(cd xcompose && git remote set-url origin git@github.com:kragen/xcompose)
	git clone https://github.com/ccontavalli/ssh-ident
	(cd xcompose && git remote set-url origin git@github.com:ccontavalli/ssh-ident)

.PHONY: non-arch
non-arch: shell-config termite-config i3-config x-config ssh-config vim-config git-repos

.PHONY: arch
arch: non-arch arch-packages

.PHONY: arch-gui
arch-gui: arch arch-gui-packages

.PHONY: arch-gui32
arch-gui32: arch-gui arch-lib32
