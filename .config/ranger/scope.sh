#!/usr/bin/env bash
# https://github.com/ranger/ranger/blob/master/ranger/data/scope.sh

# 'pipefail' is required to make 'false | true && echo ok || echo fail' work as
# needed - fail is printed even if last command in pipe succeeded.
set -o noclobber -o noglob -o nounset -o pipefail
IFS=$'\n'


# File to preview.
FILE_PATH="${1}"
FILE_MIME=$(file --mime-type -Lb "${FILE_PATH}")
FILE_EXT=$(printf '%s' "${FILE_PATH##*.}" | tr '[:upper:]' '[:lower:]')

# Preview size.
PV_WIDTH="${2:-80}"
PV_HEIGHT="${3:-25}"

# Max file size to highlight or process.
MAX_FILE_SIZE=262144    # 256KiB


# Convert tabs to spaces.
retab () {
    expand -t4 "$@"
}

# Wrap long lines.
wrap () {
    fmt -scw "${PV_WIDTH}" "$@"
}

# Trim file to MAX_FILE_SIZE size.
trim () {
    head -c${MAX_FILE_SIZE} "$@"
}

# Highlight source code. Fallback to plain cat.
highlight () {
    bat --color always --plain --theme ansi "$1"
}

# Print title
title () {
    echo "[1m----- ${1} -----[0m"
}


case "${FILE_PATH}" in
    *.cert.pem|*.crt)
        openssl x509 -noout -text -in "${FILE_PATH}" && exit 5
        ;;

    *.csr.pem|*.csr)
        openssl csr -noout -text -in "${FILE_PATH}" && exit 5
        ;;

    *.crl.pem|*.crl)
        openssl crl -noout -text -in "${FILE_PATH}" && exit 5
        ;;
esac


case "${FILE_EXT}" in
    pdf)
        pdftotext -l 10 -nopgbrk -q "${FILE_PATH}" - | wrap && exit 4
        ;;

    json)
        jq -C . "${FILE_PATH}" && exit 5
        ;;

    tar|zip)
        lsar "${FILE_PATH}" && exit 5
        ;;

    gz|xz|lzo|zstd)
        if [[ ${FILE_PATH} = *.tar.${FILE_EXT} ]] ; then
            lsar "${FILE_PATH}" && exit 5
        fi
        ;;
esac


case "${FILE_MIME}" in
    text/*|*/xml)
        highlight "${FILE_PATH}" && exit 5
        exit 2
        ;;

    image/*|video/*|audio/*)
        title 'EXIF'
        exiftool "${FILE_PATH}" && exit 5
        ;;
esac


# Fallback preview.
title 'File Type Classification' \
    && file --dereference --brief -- "${FILE_PATH}" | wrap \
    && file --dereference --brief --mime -- "${FILE_PATH}" | wrap \
    && exit 4


exit 4
