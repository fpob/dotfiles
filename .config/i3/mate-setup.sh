#!/usr/bin/env bash

YADM_CLASS=$(yadm config --get local.class)

# Configure session components
gsettings set org.mate.session required-components-list '["windowmanager"]'
gsettings set org.mate.session.required-components windowmanager i3

# Prevent Caja from managing desktop
gsettings set org.mate.background show-desktop-icons false

# Hide unnecessary decorations
gsettings set org.mate.interface gtk-decoration-layout 'menu'

# Dont't manage background
gsettings set org.mate.background draw-background false

# GTK theme
gsettings set org.mate.interface gtk-theme 'Abrus'
# Icon theme
gsettings set org.mate.interface icon-theme 'Numix'

# Default font
gsettings set org.mate.interface font-name 'Noto Sans 10'
# Document font
gsettings set org.mate.interface document-font-name 'Noto Sans 10'
# Monospace font
gsettings set org.mate.interface monospace-font-name 'Hack Nerd Font 9'

# Hide keyboard indicator (en/cs/...)
gsettings set org.mate.peripherals-keyboard-xkb.general disable-indicator true
# Don't separate layout for each window
gsettings set org.mate.peripherals-keyboard-xkb.general group-per-window false
# Keyboard layouts
gsettings set org.mate.peripherals-keyboard-xkb.kbd layouts "['us', 'cz\tqwerty']"
# Keyboard options
if [[ $YADM_CLASS == desktop ]] ; then
    # On 'desktop', escape are capslock are swapped in the keyboard firmware.
    gsettings set org.mate.peripherals-keyboard-xkb.kbd options "['grp\tgrp:alt_caps_toggle']"
else
    gsettings set org.mate.peripherals-keyboard-xkb.kbd options "['grp\tgrp:alt_caps_toggle', 'caps\tcaps:swapescape']"
fi
