#!/bin/bash
#
# This is the Mailpile dogfooding script. It can be used in these ways:
#
#    dogfood-mp.sh --install     # Install into crontab, restarts 4x/day
#    dogfood-mp.sh --uninstall   # Remove from user's crontab
#    dogfood-mp.sh --status      # Is it running? Is it installed?
#    dogfood-mp.sh --resume      # Connect to the running instance
#    dogfood-mp.sh --run         # Actually run the script
#
# See the end of the file for what the script actually does.
#
# The installer leaves Mailpile running in a screen session, use
# `dogfood-mp.sh --status` to find it, or `dogfood-mp.sh --resume` to connect
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
        echo "### Launching now in background (screen)"
        screen -S $PROGNAME -d -m $(pwd)/$PROGNAME --run
        crontab -l 2>/dev/null |grep -v "$PROGNAME --run" >"$TEMPFILE" || true
        echo "$CRON_SCHEDULE screen -S $PROGNAME -d -m $(pwd)/$PROGNAME --run" \
            >> "$TEMPFILE"
        crontab "$TEMPFILE"
        echo "### Installed into crontab:"
        crontab -l
        exit 0
    ;;
    --uninstall)
        crontab -l 2>/dev/null |grep -v "$PROGNAME --run" >"$TEMPFILE" || true
        crontab "$TEMPFILE"
        echo "### Removed from crontab:"
        crontab -l
        exit 0
    ;;
    --status)
        crontab -l 2>/dev/null |grep -c "$PROGNAME --run" >/dev/null \
          && echo "Correctly installed in crontab" \
          || echo "Not installed in crontab"
        screen -list $PROGNAME
        exit 0
    ;;
    --resume)
        screen -r $PROGNAME
        exit 0
    ;;
    --run)
    ;;
    *)
        sed -e '1,1 d; /^####/,$ d' < $0
        echo "# Usage: $0 [--run|--install|--uninstall|--status|--resume]"
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

