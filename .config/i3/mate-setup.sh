#!/usr/bin/env bash
set -x

# Configure session components
gsettings set org.mate.session required-components-list '["windowmanager"]'
gsettings set org.mate.session.required-components windowmanager i3

# Prevent Caja from managing desktop
gsettings set org.mate.background show-desktop-icons false

# Hide unnecessary decorations
gsettings set org.mate.interface gtk-decoration-layout 'menu'
