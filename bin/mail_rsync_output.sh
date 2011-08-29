#!/usr/bin/env bash

# Mail command, customized for rsync output.
#
# The message body only contains the stat report, while the whole rsync output
# is packed into a single zipped text file attached to the mail.
#
# The subject of the mail is maid from the second line of rsync output which is
# the root directory. The sender address is "Backup $HOSTNAME <noreply>". These
# values can be overritten with command line arguments.
#
# Use it as a drop-in replacement to the generic mail command.
# eg. rsync --verbose [...] | mail_rsync_output.sh -s <subject> <email>


SENDER="Backup $HOSTNAME <noreply>"


TMPDIR=$(mktemp --directory)
BODY=$TMPDIR/rsync.$(date +%Y%M%d_%H%M%S).txt
while read LINE
do
    echo $LINE >> $BODY
done

ATTACHMENT=$BODY
MAX_FILESIZE=$((25 * 1024 * 1024))  # max attachment size in Gmail: 25MB
FILESIZE=$(stat --format='%s' $ATTACHMENT)
if [ $FILESIZE -gt $MAX_FILESIZE ]
then
    ATTACHMENT=$BODY.zip
    zip --quiet $ATTACHMENT $BODY
fi

PATTERN='/^$/H;x;/\n/{:a;n;p;ba;}'  # drop lines until first blank line
sed --quiet $PATTERN $BODY | mail -r "$SENDER" -a "$ATTACHMENT" $@

rm --recursive --force $TMPDIR
