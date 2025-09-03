#!/bin/bash
echo "Starting Linux Webcam Capture..."

# Check if ffmpeg is installed
if ! command -v ffmpeg &> /dev/null
then
    echo "FFmpeg is not installed. Please install it first."
    exit 1
fi
echo "FFmpeg is installed. Continuing..."

# Detect first available webcam
if [ -e /dev/video0 ]; then
    CAMDEVICE="/dev/video0"
else
    echo "No webcam found!"
    exit 1
fi

echo "Using webcam: $CAMDEVICE"

#HOST_IP=$(grep nameserver /etc/resolv.conf | awk '{print $2}')
# Set RTMP URL dynamically
#RTMP_URL="rtmp://$HOST_IP/live/stream"
#echo "Streaming to RTMP server at: $RTMP_URL"

# Set the RTMP URL
RTMP_URL="rtmp://localhost/live/stream"

# Stream in a loop
while true; do
    echo "Capturing webcam and streaming to RTMP server..."
    ffmpeg -f v4l2 -i "$CAMDEVICE" \
           -c:v libx264 \
           -preset ultrafast \
           -tune zerolatency \
           -b:v 2500k \
           -maxrate 2500k \
           -bufsize 5000k \
           -pix_fmt yuv420p \
           -g 50 \
           -keyint_min 15 \
           -sc_threshold 0 \
           -f flv "$RTMP_URL"

    echo "Stream stopped. Restarting in 5 seconds..."
    sleep 5
done