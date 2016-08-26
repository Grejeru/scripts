# Written & Supported by Sebastian Szary <sebastian@szary.org>
# GNU GPLv3 licensed

#!/bin/bash

### configure as You want
SERVER="example.com"
DSTPATH="~/shots"
URLPATH="http://example.com/shots"

# don't change anything from here
TMPFILE=/tmp/screenshot.png
screencapture -i $TMPFILE
MD5SUM=$(md5 $TMPFILE | awk -F " = " '{ print $2 }')
scp $TMPFILE $SERVER:$DSTPATH/$MD5SUM.png
rm -f $TMPFILE
echo "$URLPATH/$MD5SUM.png" | pbcopy
