DOTFILES = $(shell pwd)

# Install $(1) from AUR, using ~/tmp/aur/$(1) as build directory
AUR_INSTALL = ([[ -e ~/tmp/aur/$(1) ]] && (cd ~/tmp/aur/$(1) && git pull) || git clone https://aur.archlinux/org/$(1) ~/tmp/aur/$(1)) && (cd ~/tmp/aur/$(1) && makepkg -sri)

.PHONY: arch-packages
arch-packages:
	# make temp dir for AUR installs
	mkdir -p ~/tmp/aur
	
	# change PKGEXT to .pkg.tar, we don't need compression for AUR builds
	sudo sed -i "s/PKGEXT='.pkg.tar.xz'/PKGEXT='.pkg.tar'/" /etc/makepkg.conf
	
	# Install cower and pacaur
	$(call AUR_INSTALL,cower)
	$(call AUR_INSTALL,pacaur)
	
	pacaur -S tig python python2 htop nmap

.PHONY: arch-gui-packages
arch-gui-packages:
	pacaur -S xorg-xinit i3 dmenu termite \
				pulseaudio pavucontrol pulseaudio-alsa \
				noto-fonts noto-fonts-emoji noto-fonts-cjk \
				ttf-dejavu evince baudline-bin thunderbird

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
	./link $(DOTFILES)/Xmodmap ~/.Xmodmap

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

.PHONY: dunst-config
dunst-config:
	./link $(DOTFILES)/dunstrc ~/.config/dunst/dunstrc

define github_clone
	mkdir -p ~/git
	[ -e $(2) ] || git clone https://github.com/$(1) $(2)
	(cd $(2) && git remote set-url origin git@github.com:$(1))
endef

.PHONY: git-repos
git-repos:
	mkdir -p ~/git
	$(call github_clone,kragen/xcompose,~/git/xcompose)
	$(call github_clone,ccontavalli/ssh-ident,~/git/ssh-ident)

.PHONY: non-arch-git-repos
non-arch-git-repos:
	$(call github_clone,icy/pacapt,~/git/pacapt)

.PHONY: dunst
dunst:
	$(call github_clone,dunst-project/dunst,$(DOTFILES)/packages/dunst/src/dunst)
	cd $(DOTFILES)/packages/dunst/src/dunst && \
		git checkout -- . && \
		git apply $(DOTFILES)/packages/dunst/patch.diff
	cd $(DOTFILES)/packages/dunst && \
		makepkg -efsri

.PHONY: generic
generic: shell-config termite-config i3-config x-config ssh-config vim-config git-repos

.PHONY: non-arch
non-arch: generic non-arch-git-repos

.PHONY: arch
arch: generic arch-packages

.PHONY: arch-gui
arch-gui: arch arch-gui-packages

.PHONY: arch-gui32
arch-gui32: arch-gui arch-lib32
