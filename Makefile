DOTFILES = $(shell pwd)

# Install $(1) from AUR, using ~/tmp/aur/$(1) as build directory
AUR_INSTALL = ([[ -e ~/tmp/aur/$(1) ]] && (cd ~/tmp/aur/$(1) && git pull) || git clone https://aur.archlinux.org/$(1) ~/tmp/aur/$(1)) && (cd ~/tmp/aur/$(1) && makepkg -sri)

define TARGDET
if uname -v | grep -i ubuntu >/dev/null; then
	if [ -z "$$DISPLAY" ]; then
		echo ubuntu;
	else
		echo ubuntu-gui;
	fi;
elif uname -r | grep -i arch >/dev/null; then
	if [ -z "$$DISPLAY" ]; then
		echo arch;
	else
		echo arch-gui;
	fi;
else
	echo generic;
fi
endef
AUTOTARGET=$(shell $(TARGDET))

.PHONY: auto
auto: $(AUTOTARGET)

.PHONY: arch
arch:
	# make temp dir for AUR installs
	mkdir -p ~/tmp/aur
	
	# change PKGEXT to .pkg.tar, we don't need compression for AUR builds
	sudo sed -i "s/PKGEXT='.pkg.tar.xz'/PKGEXT='.pkg.tar'/" /etc/makepkg.conf
	
	# Install cower and pacaur
	$(call AUR_INSTALL,cower)
	$(call AUR_INSTALL,pacaur)
	
	pacaur -S tig python python2 htop nmap fzf

	$(MAKE) generic

.PHONY: arch-gui
arch-gui:
	pacaur -S xorg-xinit i3 dmenu termite feh \
	          pulseaudio pavucontrol pulseaudio-alsa \
	          noto-fonts noto-fonts-emoji noto-fonts-cjk \
	          ttf-dejavu evince baudline-bin thunderbird \
	          py3status-git scrot graphicsmagick compton \
	          hsetroot playerctl espeak-ng
	$(MAKE) arch

.PHONY: arch-gui32
arch-gui32:
	# enable multilib and update package list
	sudo sed -i "s|#[multilib]|[multilib]\nInclude = /etc/pacman.d/mirrorlist|" /etc/pacman.conf
	pacaur -Syu
	
	# install packages
	pacaur -S lib32-libpulse steam

	$(MAKE) arch-gui

.PHONY: ubuntu
ubuntu:
	sudo apt update
	sudo apt install python3-jinja2

	$(MAKE) generic

.PHONY: ubuntu-gui
ubuntu-gui:
	sudo add-apt-repository ppa:aslatter/ppa
	sudo apt update
	sudo apt install i3 dmenu alacritty vim

	$(MAKE) ubuntu

.PHONY: configs
configs:
	./joinTheDots
	chmod 700 ~/.ssh

	mkdir -p ~/.local/man/man6/
	ln -sf ~/byond/use/man/man6/DreamMaker.6 ~/.local/man/man6/
	ln -sf ~/byond/use/man/man6/DreamDaemon.6 ~/.local/man/man6/

.PHONY: git-prompt
git-prompt:
	mkdir -p ~/bin/includes
	curl -o ~/bin/includes/git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh

.PHONY: vim-plugins
vim-plugins:
	[ -e ~/.vim/bundle/Vundle.vim ] || git clone https://github.com/VundleVim/Vundle.vim ~/.vim/bundle/Vundle.vim
	vim +PluginInstall +qall

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
	$(call github_clone,junegunn/fzf,~/git/fzf)

.PHONY: non-arch-git-repos
non-arch-git-repos:
	$(call github_clone,icy/pacapt,~/git/pacapt)

GOINSTALL = \
	TMP=$$(mktemp -d); \
	trap 'rm -r $$TMP' EXIT; \
	GOFILE=$$(curl -s https://go.dev/dl/ | grep -Eo 'go1.*\.linux-amd64\.tar\.gz' | head -n1); \
	curl -L --output $$TMP/$$GOFILE https://go.dev/dl/$$GOFILE; \
	sudo tar -C /usr/local -xzf $$TMP/$$GOFILE

.PHONY: golang
golang:
	$(GOINSTALL)

.PHONY: fzf
fzf: golang
	cd ~/git/fzf && make && make install

.PHONY: dunst
dunst:
	cd $(DOTFILES)/packages/dunst && \
		makepkg -fsri

.PHONY: i3lock-color
i3lock-color:
	cd $(DOTFILES)/packages/i3lock-color && \
		makepkg -fsri

.PHONY: generic
generic: configs git-prompt vim-plugins git-repos fzf

.PHONY: non-arch
non-arch: generic non-arch-git-repos
