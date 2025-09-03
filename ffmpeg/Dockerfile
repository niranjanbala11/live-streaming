FROM ubuntu:24.04

RUN apt-get update && apt-get install -y \
    ffmpeg \
    v4l-utils \
    && rm -rf /var/lib/apt/lists/*

COPY capture_stream.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/capture_stream.sh

CMD ["/usr/local/bin/capture_stream.sh"]
