#!/usr/bin/env zsh

if [[ "$TERM" == dumb ]] || (( ! $+commands[grc] )) ; then
    return
fi

# from /etc/grc.zsh
cmds=(
    as
    ant
    blkid
    cc
    configure
    curl
    cvs
    df
    diff
    dig
    dnf
    docker
    docker-compose
    docker-machine
    du
    env
    fdisk
    findmnt
    free
    g++
    gas
    gcc
    getfacl
    getsebool
    gmake
    id
    ifconfig
    iostat
    ip
    iptables
    iwconfig
    journalctl
    kubectl
    last
    ldap
    lolcat
    ld
    ls
    lsattr
    lsblk
    lsmod
    lsof
    lspci
    make
    mount
    mtr
    mvn
    netstat
    nmap
    ntpdate
    php
    ping
    ping6
    proftpd
    ps
    sar
    semanage
    sensors
    showmount
    sockstat
    ss
    stat
    sysctl
    systemctl
    tcpdump
    traceroute
    traceroute6
    tune2fs
    ulimit
    uptime
    vmstat
    wdiff
    whois
)

for cmd in $cmds ; do
    # Don't use it for builtins
    (( $+builtins[$cmd] )) && continue

    if (( $+commands[$cmd] )) ; then
        $cmd() {
            if zstyle -t ":grc:$0" disable ; then
                ${commands[$0]} "$@"
            else
                grc --colour=auto ${commands[$0]} "$@"
            fi
        }
    fi
done

unset cmds cmd
