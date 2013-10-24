#!/bin/bash
# Boilerplate for script which knows how to install/uninstall itself into
# a user's crontab.  See the end of the file for what it actually does.

#              min hour day mon dow
CRON_SCHEDULE="01 00,06,12,18 * * *"

set -e
TEMPFILE=$(tempfile)
function cleanup {
    rm -f "$TEMPFILE"
}
trap cleanup EXIT

PROGNAME="$(basename $0)"
case "$1" in
    --install)
        crontab -l 2>&1 |grep -v "$PROGNAME --run" >"$TEMPFILE" || true
        echo "$CRON_SCHEDULE screen -S $PROGNAME -d -m $(pwd)/$PROGNAME --run" \
            >> "$TEMPFILE"
        crontab "$TEMPFILE"
        echo "=== Installed into crontab: ==="
        crontab -l
        exit 0
    ;;
    --uninstall)
        crontab -l 2>&1 |grep -v "$PROGNAME --run" >"$TEMPFILE" || true
        crontab "$TEMPFILE"
        echo "=== Removed from crontab: ==="
        crontab -l
        exit 0
    ;;
    --run)
    ;;
    *)
        echo "Usage: $0 [--install|--uninstall|--run]"
        exit 1
    ;;
esac

############################################################################
# This is the actual script that updates and runs mailpile
PATH=.:$PATH
killall python || true
cd
cd mailpile
git pull
mp --setup
exec mp
