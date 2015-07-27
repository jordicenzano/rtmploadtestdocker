TEST_MEDIA_PATH="/data/test_material/${FILE_TO_STREAM}"

#Other interesting data
#ffmpeg stdout
FFMPEG_STDOUT_LOG="/data/log/ffmpeg_out"
FFMPEG_STDERR_LOG="/data/log/ffmpeg_err"

#Media file should be encoded in h264 and AAC, use following snipet to transcode:
#ffmpeg -i INPUTFILE -pix_fmt yuv420p -c:v libx264 -b:v 500k -g 25 -profile:v baseline -preset veryfast -c:a libfaac -b:a 96k -f flv OUTFILE

AUTH_STRING=""
if [ "$STREAMING_USER" != "" ] && [ "$STREAMING_PASS" != "" ]; then
	AUTH_STRING="${STREAMING_USER}:${STREAMING_PASS}@"
fi

DEST_URL="rtmp://${AUTH_STRING}${STREAMING_SERVER_AND_PORT}/${STREAMING_APP}/${STREAM_NAME}"

echo "Starting test stream to:${DEST_URL}"
ffmpeg -re -y -i ${TEST_MEDIA_PATH} -vcodec copy -acodec copy -f flv "${DEST_URL}" </dev/null >${FFMPEG_STDOUT_LOG} 2>${FFMPEG_STDERR_LOG}