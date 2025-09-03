# Live Streaming Solution – Design Document
## Overview

This project provides a cross-platform live video streaming solution using local webcams, FFmpeg, Nginx with RTMP/HLS, and Docker. The solution allows users to stream webcam video to a web player accessible via a browser.

## Architecture

```mermaid
flowchart
    A[Webcam / Video Device] --> B[FFmpeg (streaming via RTMP)]
    B --> C[Nginx-RTMP Server]
    C --> D[HLS Playlist & Segments\n(served via HTTP on port 8080)]
    D --> E[Browser / Web Player]
```

Components:

 - FFmpeg – Captures video from webcam, encodes it using libx264 with low latency settings, and streams via RTMP.

 - Nginx with RTMP Module – Receives RTMP stream, converts it to HLS for browser playback, and serves static web content.

 - Web Player (HTML + HLS.js) – Plays live stream via HLS in any modern browser.

 - Docker & Docker Compose – Containerizes the solution for cross-platform deployment. Provides easy setup for users without manual dependencies.

## Technical Choices
| Choice                | Reason                                                                                             |
|-----------------------|---------------------------------------------------------------------------------------------------|
| FFmpeg                |High-performance multimedia library. Supports RTMP streaming, H.264 encoding, low latency. |
| Nginx + RTMP Module   | Lightweight, scalable, widely used for live streaming. Converts RTMP to HLS for browser support.  |
| HLS.js                | JavaScript library to play HLS in browsers that don’t natively support it. |
| Docker / Docker Compose | Simplifies setup and cross-platform deployment. Isolates dependencies and configuration.          |
| Dynamic RTMP/HLS URLs | Ensures users don’t need to manually configure IPs; works across Docker, WSL, Linux, and Windows. |
## Scalability Considerations

1. Multiple Clients:

 - HLS allows multiple viewers to connect simultaneously without impacting the FFmpeg encoder.
 - Nginx can handle hundreds of simultaneous connections with proper tuning.

2. Multiple Streams / Cameras:

 - Extend Nginx with multiple RTMP applications for different cameras.
 - FFmpeg containers can run independently for each source.

3. Horizontal Scaling:

 - Deploy Nginx-RTMP on a dedicated server or cloud instance.
 - Use a CDN (e.g., CloudFront, Cloudflare) to serve HLS segments to a global audience.

4. Fault Tolerance:

 - FFmpeg scripts are designed to restart automatically on failure.

5. Performance Optimization:

 - Low-latency encoding (-tune zerolatency, small -g values).

 - Adjust HLS fragment length for trade-off between latency and buffering.

 - For higher performance, GPU-accelerated encoding (NVENC/VAAPI) can be integrated.
