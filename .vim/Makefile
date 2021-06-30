init: dirs ycm helptags spell

.PHONY: dirs
dirs:
	mkdir -p tmp view undo

.PHONY: ycm
ycm:
	@# Force building under python3 (#! is env python) + enable Go completer.
	python3 pack/dev/start/youcompleteme/install.py --go-completer

.PHONY: helptags
helptags:
	find pack -maxdepth 4 -name doc -type d \
		-exec vim -e -c 'helptags {}' -c q \; &>/dev/null

.PHONY: spell
spell: spell/cs.utf-8.spl spell/en.utf-8.spl

spell/cs.utf-8.spl: /usr/share/hunspell/cs_CZ.aff /usr/share/hunspell/cs_CZ.dic
	mkdir -p spell
	env LANG=cs_CZ.UTF-8 vim -u NONE -e \
		-c 'set encoding=utf-8' \
		-c "mkspell! $@ $(sort $(basename $^))" \
		-c q

spell/en.utf-8.spl: /usr/share/hunspell/en_US.aff /usr/share/hunspell/en_US.dic
	mkdir -p spell
	env LANG=en_US.UTF-8 vim -u NONE -e \
		-c 'set encoding=utf-8' \
		-c "mkspell! $@ $(sort $(basename $^))" \
		-c q

.PHONY: clean
clean:
	find tmp view undo -mindepth 1 -delete
