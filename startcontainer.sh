#!/bin/bash

function usage
{
    echo "Usage: startcontainer.sh IMAGE_ID/NAME [dest url] [file to stream] [show logs]"
    echo "Example: startcontainer.sh hello/ABCDE rtmp://log:pass@server.com:1935/live/streamname auto720p30@2M 0"
    echo "Special filenames are: auto240p30@500k, auto720p30@2M, auto720p60@3M, auto1080p30@3M, and auto1080p60@4M"
    exit 1
}

if [ "$#" -lt 1 ]; then
    echo "Illegal number of parameters"
    usage
fi

if [ -z "$2" ]; then 
    read -p "Enter destination URL with stream name (like rtmp://log:pass@server.com:1935/live/streamname): " DEST_URL
else
    DEST_URL=$2
fi

if [ -z "$3" ]; then
    read -p "Enter file name to use (auto720p30@2M): " FILE_TO_STREAM
    FILE_TO_STREAM=${FILE_TO_STREAM:-auto720p30@2M}
else
    FILE_TO_STREAM=$3
fi

if [ -z "$4" ]; then
    SHOW_LOGS=0
else
    SHOW_LOGS=$4
fi

#vars *****
#DEST_URL
#FILE_TO_STREAM (opt) This file shoud be inside the container dir /data/test_material/
#SHOW_LOGS (opt) (0/1)

echo "Starting to publish to: ${DEST_URL}, File: ${FILE_TO_STREAM}, Show logs: ${SHOW_LOGS}"

#With --rm all modification to the container files are deleted when exit
docker run --name="loadtest_container_$i" -t --rm -e "FILE_TO_STREAM=${FILE_TO_STREAM}" -e "DEST_URL=${DEST_URL}" -e "SHOW_LOGS=${SHOW_LOGS}" $1 &

