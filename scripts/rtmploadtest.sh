#Media file should be encoded in h264 and AAC, use following snipet to transcode:
#ffmpeg -i INPUTFILE -pix_fmt yuv420p -c:v libx264 -b:v 500k -g 25 -profile:v baseline -preset veryfast -c:a libfaac -b:a 96k -f flv OUTFILE

#ffmpeg stdout
FFMPEG_STDOUT_LOG="/data/log/ffmpeg_out"
FFMPEG_STDERR_LOG="/data/log/ffmpeg_err"

#DEST_URL: Come from docker env var 
#Ex: 
#rtmp//log:pass@server.com:1935/live/streamname
if [ -z "$DEST_URL" ]; then echo "DEST_URL is unset"; fi

#FILE_TO_STREAM: Come from docker env var 
#Use 720p 30fps 30h long by default (if the var is not set)
if [ -z "$FILE_TO_STREAM" ]; then
    echo "Warning: FILE_TO_STREAM is not set, using default settings\n"
    FFMPEGOPTS='-f lavfi -re -i testsrc=duration=108000:size=1280x720:rate=30 -f lavfi -re -i sine=frequency=1000:duration=108000:sample_rate=44100 -pix_fmt yuv420p -c:v libx264 -b:v 2000k -g 30 -profile:v baseline -preset veryfast -c:a libfdk_aac -b:a 96k -f flv'
elif [ "$FILE_TO_STREAM" = "auto720p30@2M" ]; then
    FFMPEGOPTS='-f lavfi -re -i testsrc=duration=108000:size=1280x720:rate=30 -f lavfi -re -i sine=frequency=1000:duration=108000:sample_rate=44100 -pix_fmt yuv420p -c:v libx264 -b:v 2000k -g 30 -profile:v baseline -preset veryfast -c:a libfdk_aac -b:a 96k -f flv'
elif [ "$FILE_TO_STREAM" = "auto720p60@3M" ]; then
    FFMPEGOPTS='-f lavfi -re -i testsrc=duration=108000:size=1280x720:rate=60 -f lavfi -re -i sine=frequency=1000:duration=108000:sample_rate=44100 -pix_fmt yuv420p -c:v libx264 -b:v 3000k -g 60 -profile:v baseline -preset veryfast -c:a libfdk_aac -b:a 96k -f flv'
elif [ "$FILE_TO_STREAM" = "auto1080p30@3M" ]; then
    FFMPEGOPTS='-f lavfi -re -i testsrc=duration=108000:size=1920x1080:rate=30 -f lavfi -re -i sine=frequency=1000:duration=108000:sample_rate=44100 -pix_fmt yuv420p -c:v libx264 -b:v 3000k -g 30 -profile:v baseline -preset veryfast -c:a libfdk_aac -b:a 96k -f flv'
elif [ "$FILE_TO_STREAM" = "auto1080p60@4M" ]; then
    FFMPEGOPTS='-f lavfi -re -i testsrc=duration=108000:size=1920x1080:rate=60 -f lavfi -re -i sine=frequency=1000:duration=108000:sample_rate=44100 -pix_fmt yuv420p -c:v libx264 -b:v 4000k -g 60 -profile:v baseline -preset veryfast -c:a libfdk_aac -b:a 96k -f flv'
elif [ "$FILE_TO_STREAM" = "auto240p30@500k" ]; then
    FFMPEGOPTS='-f lavfi -re -i testsrc=duration=108000:size=320x240:rate=30 -f lavfi -re -i sine=frequency=1000:duration=108000:sample_rate=44100 -pix_fmt yuv420p -c:v libx264 -b:v 500k -g 30 -profile:v baseline -preset veryfast -c:a libfdk_aac -b:a 96k -f flv'
else
    TEST_MEDIA_PATH="/data/test_material/${FILE_TO_STREAM}"
    FFMPEGOPTS="-re -y -i ${TEST_MEDIA_PATH} -vcodec copy -acodec copy -f flv"
fi

#Create ffmpeg command
FFMPEGCMD="ffmpeg $FFMPEGOPTS ${DEST_URL}"

echo "Starting command: $FFMPEGCMD\n\n"
#SHOW_LOGS: Come from docker env var 
if [ "$SHOW_LOGS" -eq "0" ]; then
    $FFMPEGCMD </dev/null >${FFMPEG_STDOUT_LOG} 2>${FFMPEG_STDERR_LOG}
else
    $FFMPEGCMD
fi

#Showing logs at the end
echo "Showing ffmpeg stdout log:\n"
cat ${FFMPEG_STDOUT_LOG}
echo "\n\n"

echo "Showing ffmpeg stderr log:\n"
cat ${FFMPEG_STDERR_LOG}
echo "\n\n"
