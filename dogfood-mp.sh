#!/bin/bash
#
# This is the maipile dogfooding script. It can be used in three ways:
#
#    dogfood-mp.sh --install     # Install into crontab, restarts 4x/day
#    dogfood-mp.sh --uninstall   # Remove from user's crontab
#    dogfood-mp.sh --run         # Actualy run the script
#
# See the end of the file for what the script actually does.
#
# The installer leaves Mailpile running in a screen session, use
# `screen --list` to find it, or `screen -r dogfood-mp.sh` to connect
# to it and interact on the CLI.
#
# The program assumes you have git cloned the Mailpile repo into a folder
# named "Mailpile" in your home directory.
#
###############################################################################

#############  min hour day mon dow
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
        crontab -l 2>/dev/null |grep -v "$PROGNAME --run" >"$TEMPFILE" || true
        echo "$CRON_SCHEDULE screen -S $PROGNAME -d -m $(pwd)/$PROGNAME --run" \
            >> "$TEMPFILE"
        crontab "$TEMPFILE"
        echo "=== Installed into crontab: ==="
        crontab -l
        echo "=== Launching now in background (screen) ==="
        screen -S $PROGNAME -d -m $(pwd)/$PROGNAME --run
        exit 0
    ;;
    --uninstall)
        crontab -l 2>/dev/null |grep -v "$PROGNAME --run" >"$TEMPFILE" || true
        crontab "$TEMPFILE"
        echo "=== Removed from crontab: ==="
        crontab -l
        exit 0
    ;;
    --run)
    ;;
    *)
        sed -e '1,1 d; /^####/,$ d' < $0
        echo "# Usage: $0 [--install|--uninstall|--run]"
        echo "#"
        exit 1
    ;;
esac
cleanup

###############################################################################
# This is the actual script that updates and runs mailpile

# Kill any old running mailpiles
kill $(ps axw |grep python |grep mailpile |cut -f1 -d\ || true) \
  2>/dev/null || true

# Enter our source directory, git pull
cd ~/Mailpile
git pull

# Run Mailplile!
PATH=.:$PATH
mp --setup
exec mp

