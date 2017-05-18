PWD = $(shell pwd)

default: clean

init:
	wget -P autoload https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim
	mkdir tmp view

youcompleteme:
	git -C bundle/youcompleteme submodule update --recursive --init
	cd bundle/youcompleteme && ./install.py

spell:
	cd /usr/share/hunspell && env LANG=cs_CZ.utf-8 vim -u NONE -e \
	    -c "mkspell! $(PWD)/spell/cs cs_CZ" -c q

clean:
	$(RM) tmp/* view/*

.PHONY: default init youcompleteme spell clean
