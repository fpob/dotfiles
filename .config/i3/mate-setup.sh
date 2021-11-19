#!/usr/bin/env bash
set -x

# Configure session components
gsettings set org.mate.session required-components-list '["windowmanager"]'
gsettings set org.mate.session.required-components windowmanager i3

# Prevent Caja from managing desktop
gsettings set org.mate.background show-desktop-icons false

# Hide unnecessary decorations
gsettings set org.mate.interface gtk-decoration-layout 'menu'

# Dont't manage background
gsettings set org.mate.background draw-background false

# Hide keyboard indicator (en/cs/...)
gsettings set org.mate.peripherals-keyboard-xkb.general disable-indicator true
