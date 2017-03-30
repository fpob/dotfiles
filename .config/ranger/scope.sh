#!/usr/bin/env bash
# {{{
# Meanings of exit codes:
# code | meaning    | action of ranger
# -----+------------+-------------------------------------------
# 0    | success    | success. display stdout as preview
# 1    | no preview | failure. display no preview at all
# 2    | plain text | display the plain content of the file
# 3    | fix width  | success. Don't reload when width changes
# 4    | fix height | success. Don't reload when height changes
# 5    | fix both   | success. Don't ever reload
# 6    | image      | success. display the image $cached points to as an image preview
# }}}

path="$1"    # Full path of the selected file
width="$2"   # Width of the preview pane (number of fitting characters)
height="$3"  # Height of the preview pane (number of fitting characters)
cached="$4"  # Path that should be used to cache image previews

maxln=200    # Stop after $maxln lines.  Can be used like ls | head -n $maxln

mimetype=$(file --mime-type -Lb "$path")
extension=$(echo -E "${path##*.}" | tr "[:upper:]" "[:lower:]")
case $extension in
    bz|bz2|gz|lz|lha|lzh|lzma|lzo|rz|xz)
        tmp=$(echo -E "${path##*.}" | tr "[:upper:]" "[:lower:]")
        [[ $tmp = tar ]] && extension=$tmp.$extension
        ;;
esac

try() {
    output=$(eval '"$@"')
}
dump() {
    echo -E "$output"
}
trim() {
    head -n "$maxln"
}
highlight() {
    pygmentize "$@"
    test $? -eq 0 -o $? -eq 141
}

case "$extension" in
    #7z|a|ace|alz|arc|arj|bz|bz2|cab|cpio|deb|gz|jar|lha|lz|lzh|lzma|lzo|\
    #rpm|rz|t7z|tar|tbz|tbz2|tgz|tlz|txz|tZ|tzo|war|xpi|xz|z|zip)
    #    try als "$path" && { dump | trim; exit 0; }
    #    try acat "$path" && { dump | trim; exit 3; }
    #    try bsdtar -lf "$path" && { dump | trim; exit 0; }
    #    exit 1
    #    ;;
    #rar)
    #    try unrar -p- lt "$path" && { dump | trim; exit 0; } || exit 1
    #    ;;

    pdf)
        try pdftotext -l 10 -nopgbrk -q "$path" - \
            && { dump | trim | fmt -s -w $width; exit 0; } || exit 1
        ;;

    htm|html|xhtml)
        try lynx   -dump "$path" && { dump | trim | fmt -s -w $width; exit 4; }
        ;; # fall back to highlight/cat if the text browsers fail

    tsv)
        try column -t -s $'\t' "$path" && { dump | trim; exit 5; } || exit 2
        ;;

    deb)
        try dpkg --info "$path" && { dump | trim; exit 5; } || exit 1
        ;;

    md|markdown)
        try mdv -t 884.0134 -c $width -u i "$path" && { dump | trim; exit 5; }
        ;; # fall back to highlight/cat
esac

case "$mimetype" in
    text/* | */xml)
        try highlight "$path" && { dump | trim; exit 5; } || exit 2
        ;;

    image/*|video/*|audio/*)
        try exiftool "$path" && { dump | trim; exit 5; } || exit 1
        ;;
esac

exit 1
