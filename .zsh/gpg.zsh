# Cat GPG encrypted file.
alias gpg-cat='gpg -qd -o-'

# Source GPG encrypted shell file.
function gpg-source {
    source =(gpg-cat $@)
}

# Execute GPG encrypted file. By default executes in current running shell.
# Shell can be changed by '-s SHELL' option.
function gpg-run {
    local shell=$SHELL

    while getopts s: opt ; do
        case $opt in
            s) shell=$OPTARG ;;
            *) echo "Unknown option '$opt'" ;;
        esac
    done
    shift $((--OPTIND))

    local script=$1
    shift 1

    $shell =(gpg-cat "$script") $@
}
