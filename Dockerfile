# Multi-arch base image (arm64 + amd64), runs as non-root on port 8080
FROM nginxinc/nginx-unprivileged:alpine
COPY index.html /usr/share/nginx/html/index.html
