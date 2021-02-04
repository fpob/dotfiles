.PHONY: clean
clean:
	$(RM) tmp/* view/* undo/*

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

.PHONY: spell clean
