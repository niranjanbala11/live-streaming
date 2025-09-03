FROM ubuntu:24.04

# Install nginx + RTMP + ffmpeg
RUN apt-get update && apt-get install -y \
    nginx \
    libnginx-mod-rtmp \
    && rm -rf /var/lib/apt/lists/*

# Create web directories
RUN mkdir -p /var/www/html/hls /var/www/html/vod

# Copy configs + index.html
COPY nginx.conf /etc/nginx/nginx.conf
COPY index.html /var/www/html/index.html

# Expose RTMP and HTTP ports
EXPOSE 1935 8080

# Start nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
