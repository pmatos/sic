#! /bin/bash

# Remove photo from gallery given its sha1,
# introduce sha1 into the removed files list

source common.sh

SHA=$1

if [ ! -d $DATADIR/$SHA ]; then
    echo "File $SHA doesn't exist in gallery" >&2
    exit 1
fi

# Remove file
rm -Rf $DATADIR/$SHA

# Add removed SHA to removed file
touch $REMFILE # do i need to do this if doesn't exist?
echo $SHA >> $REMFILE

echo "File $SHA removed successfully"



