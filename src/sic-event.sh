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

mkdir -p $SICHOME/events

# Given an event name it returns the path to the event directory
event_path ()
{
    EVNAME=$1
    echo $SICHOME/events/$EVNAME
}

event_exists_p ()
{
    EVNAME=$1
    
    EVPATH=$(event_path $EVNAME)

    if [ -d $EVPATH ]; then
	return 1
    else
	return 0
    fi
}

# Create a new event.
# This should be a simple touch.
event_new ()
{
    EVNAME=$1
    
    if event_exists_p $EVNAME; then
	echo "Event $EVNAME already exists"
	exit 1
    fi
    
    touch $(event_path $EVNAME)
    echo "Event $EVNAME created"
    exit 0
}

# Add single file to an event
event_ads ()
{
    EVNAME=$1
    SHA=$2

    # First we should check if the file
    # is already part of the event.
    if grep -q $SHA $(event_path $EVNAME); then
	echo "File $SHA is already part of event $EVNAME"
	exit 1
    fi

    # Lets add it
    echo $SHA >> $(event_path $EVNAME)
    echo "File $SHA added successfully to event $EVNAME"
    exit 0
}

# Remove single file from an event
event_rms ()
{
    EVNAME=$1
    SHA=$2
    
    # Check if file is not part of event
    if ! grep -q $SHA $(event_path $EVNAME); then
	echo "File $SHA is not part of event $EVNAME"
	exit 1
    fi
    
    # Lets remove it
    sed -i "/$SHA/d" $(event_path $EVNAME)
    echo "File $SHA removed successfully from event $EVNAME"
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

if (( $DEL == 1 )); then
    EVNAME=$1
    
    if ! event_exists_p $EVNAME; then
	echo "Event $EVNAME does not exist"
	exit 1
    fi

    rm -Rf $(event_path $EVNAME)
    echo "Event $EVNAME deleted"
    exit 0
fi

COMMAND=$1

if [ $COMMAND == "new" ]; then
    event_new $2
elif [ $COMMAND == "ads" ]; then
    event_ads $2 $3
elif [ $COMMAND == "rms" ]; then
    event_rms $2 $3
else
    echo "Unknown command: $COMMAND"
    exit 1
fi

exit 0
    
    
