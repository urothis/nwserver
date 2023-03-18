#!/usr/bin/env awk

BEGIN {
    in_alias=0;
}

in_alias == 1 {
    if ($0 ~ /^\[/) {
        in_alias=0;
    } else {
        next;
    }
}

/^\[Alias\]/ {
    in_alias=1;
}

{ print; }
