1.  Install i3-mate.desktop file
    ```
    desktop-file-install --dir=$HOME/.local/share/applications ~/.config/i3-mate/i3-mate.desktop
    ```

2.  Change MATE window manager
    ```
    gsettings set org.mate.session.required-components windowmanager i3-mate
    ```

3.  Remove `filemanager` from `required-components-list` (other components must remain)
    ```
    gsettings set org.mate.session required-components-list "['windowmanager', 'panel']"
    ```

4.  Prevent Caja to manage the desktop
    ```
    gsettings set org.mate.background show-desktop-icons false
    ```

5.  Hide decoration button (close button in titlebar)
    ```
    gsettings set org.mate.interface gtk-decoration-layout 'menu'
    ```
