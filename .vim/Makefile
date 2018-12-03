PWD = $(shell pwd)

clean:
	$(RM) tmp/* view/* undo/*

helptags:
	find pack -maxdepth 4 -name doc -type d -exec vim -T dumb -e -c 'helptags {}' -c q \;

youcompleteme:
	cd pack/dev/start/youcompleteme && ./install.py

spell:
	test -d spell || mkdir spell
	{ cd /usr/share/hunspell || cd /usr/share/myspell ;} 2>/dev/null \
	    && env LANG=cs_CZ.utf-8 vim -u NONE -e -c "mkspell! $(PWD)/spell/cs cs_CZ" -c q
	{ cd /usr/share/hunspell || cd /usr/share/myspell ;} 2>/dev/null \
	    && env LANG=en_US.utf-8 vim -u NONE -e -c "mkspell! $(PWD)/spell/en en_US" -c q

.PHONY: helptags youcompleteme spell clean
