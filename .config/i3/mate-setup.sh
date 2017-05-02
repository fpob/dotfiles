#!/usr/bin/env bash

# Change mate window manager
gsettings set org.mate.session.required-components windowmanager i3

# Prevent Caja from managing the desktop
gsettings set org.mate.background show-desktop-icons false

# Remove all buttons from the header bar
gsettings set org.mate.interface gtk-decoration-layout 'menu:'
