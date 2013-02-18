#! /bin/bash
# 
# Welcome to SIC, the first user-friendly, fast
# and (hopefully) useful photo management tool suite.
#

# Argument 1 is either help or a command.
# If it is help then,
# if there's argument 2 (and no more),
# we call help of that command.
# If it's not help we pass all the arguments to
# the specified command.

HELP=0
VERBOSE=""

while getopts ":hv" opt; do
    case $opt in
	h)
	    HELP=1
	    ;;
	v)
	    VERBOSE="-v"
	    ;;
	\?)
	    echo "Invalid option: -$OPTARG" >&2
	    exit 1
	    ;;
	esac
done
shift $(( $OPTIND - 1 ))

if (( $HELP == 1 )); then
    echo "HELP"
    while (( "$#" )); do
	echo $1
	shift
    done
fi

if (( "$#" > 1 )); then
    CMD=$1
    shift
    bash ./sic-${CMD}.sh $VERBOSE $*
fi
