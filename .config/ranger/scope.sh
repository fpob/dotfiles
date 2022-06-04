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
PV_WIDTH="${2}"
PV_HEIGHT="${3}"

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

# Highlight source code. If file is too large or highlighting timed out file is
# printed as it is (without highlighting).
highlight () {
    batcat --color always --plain --theme base16 "$1"
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

    htm|html|xhtml)
        grep -q '{%.*%}\|\|{#.*#}{{.*}}' "${FILE_PATH}" \
            && highlight "${FILE_PATH}" html+jinja && exit 5
        lynx -dump "${FILE_PATH}" | wrap && exit 4
        ;;

    tsv)
        trim "${FILE_PATH}" | column -t -s$'\t' && exit 5
        ;;

    csv)
        # Convert to TSV first.
        trim "${FILE_PATH}" \
            | python3 -c "import csv, sys; csv.writer(sys.stdout, 'excel-tab').writerows(csv.reader(sys.stdin))" \
            | column -t -s$'\t' \
            && exit 5
        ;;

    deb)
        dpkg --info "${FILE_PATH}" control \
            | highlight - control && exit 5
        ar p "${FILE_PATH}" control.tar.gz | tar xzO ./control \
            | highlight - control && exit 5
        ar p "${FILE_PATH}" control.tar.xz | tar xJO ./control \
            | highlight - control && exit 5
        ;;

    rpm)
        rpm -qip "${FILE_PATH}" && exit 5
        ;;

    json)
        jq -C . "${FILE_PATH}" | trim && exit 5
        python3 -m json.tool -- "${FILE_PATH}" | highlight - json | trim && exit 5
        ;;

    xml)
        xmllint --format "${FILE_PATH}" | highlight - xml && exit 5
        ;;

    md|markdown)
        mdv -t 884.0134 -c ${PV_WIDTH} -u inline "${FILE_PATH}" | wrap && exit 4
        ;;

    desktop|service|target|socket)
        [[ "${FILE_MIME}" =~ text/* ]] && highlight "${FILE_PATH}" ini && exit 5
        ;;

    j2)
        highlight "${FILE_PATH}" jinja && exit 5
        ;;

    yml|yaml)
        highlight "${FILE_PATH}" yaml && exit 5
        ;;
esac


case "${FILE_MIME}" in
    text/*|*/xml)
        highlight "${FILE_PATH}" && exit 5
        exit 2
        ;;

    image/*|video/*|audio/*)
        exiftool "${FILE_PATH}" && exit 5
        ;;
esac


# Fallback preview.
echo '[1m----- File Type Classification -----[0m' \
    && file --dereference --brief -- "${FILE_PATH}" | wrap \
    && file --dereference --brief --mime -- "${FILE_PATH}" | wrap \
    && exit 4


exit 1
