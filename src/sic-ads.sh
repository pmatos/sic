#! /bin/bash

#
# Receives a single argument and optional
# verbose flag.
# 
# Adds the file to the gallery of pictures.
#
# utility deps:
# * convert (imagemagick)
# * sha1sum

DATADIR=$HOME/.sic/data
mkdir -p $DATADIR

VERB=0

while getopts ":v" opt; do
    case $opt in
	v)
	    VERB=1
	    ;;
	\?)
	    echo "Invalid option to ads: -$OPTARG" >&2
	    exit 1
	    ;;
    esac
done
shift $(( $OPTIND - 1))

if (( "$#" > 1 )); then
    echo "too many arguments to ads" >&2
    exit 1
fi

FILE=$1

# Generate pbm of file
TMPFILE=$(mktemp).ppm
convert $FILE $TMPFILE
SHA=$(sha1sum $TMPFILE | cut -d ' ' -f 1)
rm -f $TMPFILE

if [ -d $DATADIR/$SHA ]; then
    echo "Image already exists in database."
    echo "use"
    echo "  sic display $SHA"
    echo "to view image"
    exit
fi

# create directory
# * add file
# * add _format prop
# * add _sic-author prop
# * add _sic-date prop
# * add _sic-hostname prop
mkdir $DATADIR/$SHA
cp $FILE $DATADIR/$SHA/$SHA
echo $(identify -verbose $DATADIR/$SHA/$SHA | grep '^..Format' | cut -d ':' -f 2 | sed 's/^ *//g') > $DATADIR/$SHA/_format
echo $(whoami) > $DATADIR/$SHA/_sic-author
echo $(hostname) > $DATADIR/$SHA/_sic-hostname
echo $(date) > $DATADIR/$SHA/_sic-date

echo "image $SHA added to gallery successfully."
exit
