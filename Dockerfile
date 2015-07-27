# Generate a docker for live streaming load testing
# by Jordi Cenzano
# VERSION               1.0.1

FROM ubuntu:14.04
MAINTAINER jordi.cenzano@gmail.com

#Update
RUN apt-get update && \
apt-get clean

#Upgrade
RUN apt-get upgrade -y && \
apt-get clean

#Install ffmpeg
RUN apt-get install software-properties-common python-software-properties -y && \
	add-apt-repository ppa:mc3man/trusty-media -y && \
	apt-get update -y && \
	apt-get install ffmpeg -y && \
	apt-get clean

#Copy test content
COPY tmp/bbb_sunflower_1080p_30fps_normal_audio.mp4 tmp/bbb_sunflower_1080p_60fps_normal_audio.mp4 /data/test_material/

#Copy load test scripts
COPY scripts/rtmploadtest.sh scripts/rtmpclean.sh /data/scripts/
RUN chmod 755 /data/scripts/rtmploadtest.sh && \
	chmod 755 /data/scripts/rtmpclean.sh

#Create logs dir for load test
RUN mkdir /data/log

#Start test
ENTRYPOINT /data/scripts/rtmploadtest.sh