#!/usr/bin/env bash

# Mail command, customized for rsync output.
#
# The message body only contains the stat report, while the whole rsync output
# is packed into a single text file attached to the mail.
#
# Use it as a drop-in replacement to the generic mail command.
# eg. rsync [...] | mail_rsync_output.sh -s <subject> <email>


ATTACHMENT=$(mktemp)

while read LINE
do
    echo $LINE >> $ATTACHMENT
done

PATTERN='/^$/H;x;/\n/{:a;n;p;ba;}'  # drop lines until first blank line

cat $ATTACHMENT | sed -n $PATTERN | mail -a $ATTACHMENT $@
rm $ATTACHMENT
