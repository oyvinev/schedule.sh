#!/bin/bash -ue

function help() {
    # Display Help
   echo
   echo "Syntax: schedule.sh [options] command"
   echo "Options:"
   echo " -n, --every     Run every n seconds"
   echo " -s, --start     Start time as HH:MM"
   echo " -v[v], --verbose   Verbose mode"
   echo
}

every=60
start=0
verbose=0
while [[ "$#" -gt 2 ]]; do
    case $1 in
        -n|--every) every="$2"; shift ;;
        -s|--start) start="$2"; shift ;;
        -v|--verbose) verbose=1; ;;
        -vv) verbose=2; ;;
        -h|--help) help; exit 0; ;;
        -*) echo "Unknown parameter passed: $1"; help; exit 1; ;;
        *) break;  ;;
    esac
    shift
done
command="$@"

if [[ "$start" != "0" ]]; then
    start=$(date --date="$start today" +%s)
    while [[ "$start" < $(date +%s) ]]; do 
        start=$(($start + $every))
    done
    [[ "$verbose" == "1" ]] && echo "Will start execution of \"$command\" at $(date -d@$start)"
    now=$(date +%s)
    wait_for=$(($start - $now))
    sleep $wait_for
else
    start=$(date +%s)
    [[ "$verbose" == "1" ]] && echo "Will start execution of \"$command\" at $(date -d@$start)"
fi


next_start=$start
while true; do
    now=$(date +%s)
    if [[ $now -ge $next_start ]]; then
        [[ "$verbose" == "2" ]] && echo "Starting $(date -d@$now)"
        next_start=$(( $next_start + $every ))
        $command
        [[ "$verbose" == "2" ]] && echo "Waiting until $(date -d@$next_start)"
    fi
    sleep 1
done
