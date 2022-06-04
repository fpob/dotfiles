export ASDF_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/asdf"
export ASDF_DATA_DIR="$ASDF_DIR"
export ASDF_CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/asdf/asdfrc"

path=("$ASDF_DIR/bin" $path)
export PATH
