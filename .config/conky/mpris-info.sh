#!/usr/bin/env bash

# http://stackoverflow.com/questions/4545661/unicodedecodeerror-when-redirecting-to-file
export PYTHONIOENCODING=UTF-8

status=`mpris-remote playstatus 2>/dev/null | awk '/^playing/{print $2}'`

if [[ $status == playing ]] ; then
    awk_script='{
        $1=""
        gsub(/^\s+/, "", $0)
        if (length($0) > 32)
            print substr($0,0,32) "\\u2026"
        else
            print
    }'
    artist=`mpris-remote trackinfo | awk "/^artist/$awk_script"`
    title=`mpris-remote trackinfo | awk "/^title/$awk_script"`
    [[ -n $artist$title ]] && echo "\\uf001 $artist \\u2013 $title"
fi 2>/dev/null
