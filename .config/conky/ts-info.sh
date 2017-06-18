#!/usr/bin/env bash

tsp | awk '
BEGIN {
    total = 0;
    running = 0;
    queued = 0;
    finished = 0;
    failed = 0;
}
NR > 1 {
    total += 1;
    if ($2 == "running") {
        running += 1;
    } else if ($2 == "queued") {
        queued += 1;
    } else if ($2 == "finished") {
        finished += 1;
        if ($4 != "0") {
            failed += 1;
        }
    }
}
END {
    if (total > 0) {
        print "\\uf0ae", running "/" queued, finished "!" failed;
    }
}
'
