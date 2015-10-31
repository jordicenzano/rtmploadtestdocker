# rtmploadtestdocker
This code allows you to create a docker container with all the tools to create a RTMP stream. This can be automated to test any kind of cloud live streaming system:
  - Brightcove / Zencoder
  - Youtube
  - Twich
  - WowzaStreamingCloud
  - etc

# Installation
- Install docker (https://docs.docker.com/installation/)
- Clone this repository
- Add the mediafiles (.mp4) that you want to include in the container into `./media`
  - This files should be in the correct format, you can use this snippet as example:
```
ffmpeg -i INPUTFILE -pix_fmt yuv420p -c:v libx264 -b:v 500k -g 25 -profile:v baseline -preset veryfast -c:a libfaac -b:a 96k -f flv OUTFILE.mp4
```

# Container creation
- Call `make`

# Test container locally
- Call `startcontainer.sh IMAGE_ID [dest url] [file to stream] [show logs]`, for example:
```
./startcontainer.sh ABCDE rtmp://log:pass@server.com:1935/live/streamname auto720p30@2M 0
```
- As `[file to stream]` you can use the following special names that will create auto generated files:
```
auto240p30@500k: Video 320x240 at 30fps, H264 500Kbps + 1KHz sine audio AAC at 96Kbps
auto720p30@2M: Video 1280x720 at 30fps, H264 2Mbps + 1KHz sine audio AAC at 96Kbps
auto720p60@3M: Video 1280x720 at 60fps, H264 3Mbps + 1KHz sine audio AAC at 96Kbps
auto1080p30@3M: Video 1920x1080 at 30fps, H264 3Mbps + 1KHz sine audio AAC at 96Kbps
auto1080p60@4M: Video 1920x1080 at 60fps, H264 4Mbps + 1KHz sine audio AAC at 96Kbps
```
#Push container to any container repository
- To push to DockerHub (https://docs.docker.com/userguide/dockerrepos/)

#Use this container from the "Cloud"
- To install docker and pull the container from DockerHub to EC2 follow this guide: (http://docs.aws.amazon.com/AmazonECS/latest/developerguide/docker-basics.html)
- Clone this repo in the EC2 server (or just copy the `startcontainer.sh`)
- Run the container in the EC2 server with `startcontainer.sh IMAGE_ID [dest url] [file to stream] [show logs]`
