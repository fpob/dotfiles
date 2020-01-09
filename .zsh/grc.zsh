#!/usr/bin/env zsh

if [[ "$TERM" != dumb ]] && (( $+commands[grc] )) ; then
    # GRC prefix for other aliasses in .zshrc for example. If GRC is not
    # installed or cannot be used this var will be empty (default shell var
    # value).
    export _GRC='grc --colour=auto '

    # Set alias for available colorfiles and commands.
    for conf in ~/.grc/conf.*(.N) /usr/local/share/grc/conf.*(.N) /usr/share/grc/conf.*(.N) ; do
        name=${conf##*conf.}

        if (( $+commands[$name] )) ; then
            alias $name="$_GRC$(whence $name) "
        fi
    done

    # Clean up variables
    unset conf name
fi
