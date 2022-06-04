DATA_DIR = $(HOME)/.local/share/vim

init: ycm helptags spell

$(DATA_DIR) $(DATA_DIR)/spell:
	mkdir -p "$@"

.PHONY: ycm
ycm:
	@# Force building under python3 (#! is env python) + enable Go completer.
	python3 pack/plugins/start/youcompleteme/install.py --go-completer

.PHONY: helptags
helptags:
	find pack -maxdepth 4 -name doc -type d \
		-exec vim -e -c 'helptags {}' -c q \; &>/dev/null

.PHONY: spell
spell: $(DATA_DIR)/spell/cs.utf-8.spl $(DATA_DIR)/spell/en.utf-8.spl

$(DATA_DIR)/spell/cs.utf-8.spl: /usr/share/hunspell/cs_CZ.aff /usr/share/hunspell/cs_CZ.dic | $(DATA_DIR)/spell
	env LANG=cs_CZ.UTF-8 vim -u NONE -e \
		-c 'set encoding=utf-8' \
		-c "mkspell! $@ $(sort $(basename $^))" \
		-c q

$(DATA_DIR)/spell/en.utf-8.spl: /usr/share/hunspell/en_US.aff /usr/share/hunspell/en_US.dic | $(DATA_DIR)/spell
	env LANG=en_US.UTF-8 vim -u NONE -e \
		-c 'set encoding=utf-8' \
		-c "mkspell! $@ $(sort $(basename $^))" \
		-c q
