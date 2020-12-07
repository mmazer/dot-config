.PHONY: dirs git fzf rg fonts install-monaco

UNAME:=$(shell uname)

dirs:
	mkdir -p ${HOME}/.cache
	mkdir -p ${HOME}/.config
	mkdir -p ${HOME}/.local/share
	mkdir -p ${HOME}/.local/share/bash_completion.d
	mkdir -p ${HOME}/.local/share/bookmarks

git: dirs
	cd ${HOME}/.local/share/bash_completion.d
	curl -O https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash && \
	curl -O https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh

rg:
	$(PKG_MAN) install rg

tmux:
	$(BREW) install tmux && \
	    git clone https://github.com/tmux-plugins/tpm ${HOME}/.tmux/plugins/tpm

fonts: install-monaco

install-monaco:
	sudo mkdir -p /usr/share/fonts/truetype/ttf-monaco && \
	sudo wget http://www.gringod.com/wp-upload/software/Fonts/Monaco_Linux.ttf -O \
	/usr/share/fonts/truetype/ttf-monaco/Monaco_Linux.ttf && \
	sudo fc-cache
