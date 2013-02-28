#! /bin/bash

#
# Event management
# Events are collections of photos,
# usually spanning a sequence of dates: a weekend,
# a week, two weeks even...
#
# This is just a bunch of files (named after the event name)
# which contain itself a list of photos/videos.
#

source common.sh

HELP=0
VERBOSE=""
DEL=0

# Available commands
# new: create new event
# add: add photo to event
# rm: delete photo from event
# -d: delete event

while getopts ":hvd" opt; do
    case $opt in
	h)
	    HELP=1
	    ;;
	v)
	    VERBOSE="-v"
	    ;;
	d)
	    DEL=1
	    ;;
	\?)
	    echo "Invalid option: -$OPTARG" >&2
	    exit 1
	    ;;
    esac
done
shift $(( $OPTIND - 1))

if (( $HELP == 1 )); then
    echo "HELP"
fi

COMMAND=$1

if (( $COMMAND == "new" )); then
    # Create a new event.
    # This should be a simple touch.
    EVENTNAME=$2

    if [ !-f "
