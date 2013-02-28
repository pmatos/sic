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

# Given an event name it returns the path to the event directory
event_path ()
{
    EVNAME=$1
    return $SICHOME/events/$1
}

event_exists_p ()
{
    EVNAME=$1
    
    event_path $EVNAME
    EVPATH=$?

    if [ -d $EVPATH ]; then
	return 0
    else
	return 1
    fi
}

# Create a new event.
# This should be a simple touch.
event_new ()
{
    EVNAME=$1
    
    if (( $(event_exists_p $EVNAME) == 1 )); then
	echo "Event $EVNAME already exists"
	exit 1
    fi
    
    touch $(event_path $EVNAME)
    echo "Event $EVNAME created"
    exit 0
}

# Available commands
# new: create new event
# ads: add photo to event
# rms: delete photo from event
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

if (( $DEL == 1)); then
    EVNAME=$1
    
    if (( !$(event_exists_p $EVNAME) )); then
	echo "Event $EVNAME does not exist"
	exit 1
    fi

    rm -Rf $(event_path $EVNAME)
    echo "Event $EVNAME deleted"
    exit 0
fi

COMMAND=$1

if (( $COMMAND == "new" )); then
    event_new $2
elif (( $COMMAND == "ads" )); then
    event_ads $2 $3
elif (( $COMMAND == "rms" )); then
    event_rms $2 $3
else
    echo "Unknown command: $COMMAND"
    exit 1
fi

exit 0
    
    
