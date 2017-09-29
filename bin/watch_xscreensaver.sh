#! /bin/bash

# Disable the mouse whenever the screensaver is active. This prevents the
# computer from waking up if you bump the desk...

# Uses hardcoded mouse input ID.

while read line; do
    if [[ $line == BLANK* ]] || [[ $line == LOCK* ]]; then
        xinput disable 9
    elif [[ $line == UNBLANK* ]]; then
        xinput enable 9
    fi
done < <(xscreensaver-command -watch)
