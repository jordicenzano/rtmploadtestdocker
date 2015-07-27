#!/bin/bash

function usage
{
	echo "Usage: startcontainer.sh IMAGE_ID/NAME number_containers_to_lunch"
  	exit 1
}

if [ "$#" -ne 2 ]; then
    echo "Illegal number of parameters"
    usage
fi

re='^[0-9]+$'
if ! [[ $2 =~ $re ]] ; then
	echo "Parameter 2 must be a number"
   	usage
fi

#Load vars *****
#Example:
#RTMP test data
#STREAMING_SERVER_AND_PORT="servername:1935"
#STREAMING_APP="live"
#STREAM_BASE_NAME="test"
#STREAMING_USER="" 
#STREAMING_PASS=""
#FILE_TO_STREAM="bbb_sunflower_1080p_60fps_normal_audio.mp4"
source creds/load_test_config

for ((i=1; i<=$2; i++)); 
do
	STREAM_NAME="${STREAM_BASE_NAME}${i}"
	if [ "$2" -lt "2" ] ; then
		STREAM_NAME="${STREAM_BASE_NAME}"
	fi

	echo "Starting to publish to: ${STREAMING_SERVER_AND_PORT}/${STREAMING_APP}/${STREAM_NAME}"

	#With --rm all modification to the container files are deleted when exit
	docker run --name="loadtest_container_$i" -t --rm -e "FILE_TO_STREAM=${FILE_TO_STREAM}" -e "STREAMING_SERVER_AND_PORT=${STREAMING_SERVER_AND_PORT}" -e "STREAMING_APP=${STREAMING_APP}" -e "STREAM_NAME=${STREAM_NAME}" -e "STREAMING_USER=${STREAMING_USER}" -e "STREAMING_PASS=${STREAMING_PASS}" $1 &
done
