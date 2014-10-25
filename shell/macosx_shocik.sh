# $ - Mac OSX screenshots take and upload to own directory - $ #
# $ - Sebastian Szary <sebastian@szary.org> - $ #

#!/bin/bash

### configure as You want
SERVER="example.com"
DSTPATH="~/shots"
URLPATH="http://example.com/shots"

# don't change anything from here
TMPFILE=/tmp/screenshot.png
screencapture -i $TMPFILE
MD5SUM=`md5 $TMPFILE | awk -F " = " '{ print $2 }'`
#MD5SUM=`date +'%F_%H-%M-%S'` 
scp $TMPFILE $SERVER:$DSTPATH/$MD5SUM.png
rm -f $TMPFILE
echo "$URLPATH/$MD5SUM.png" | pbcopy
