PHONY: dirs git fzf rg

UNAME:=$(shell uname)

ifeq ($(UNAME) Darwin)
PKG_MAN=brew
else
PKG_MAN=apt-get
endif

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
	$(PKG_MAN) install fzf

