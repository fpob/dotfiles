# Cat GPG encrypted file.
alias gpg-cat='gpg -qd -o-'

# Source GPG encrypted shell file.
gpg-source () {
    source =(gpg-cat $@)
}

# Execute GPG encrypted shell file.
gpg-sh () {
    gpg-cat $@ | $SHELL
}
