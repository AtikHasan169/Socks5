FROM alpine:3.20

# Tools to download and extract gost
RUN apk add --no-cache wget ca-certificates tar

# Download prebuilt gost binary for linux amd64 (v2.12.0)
RUN wget https://github.com/ginuerzh/gost/releases/download/v2.12.0/gost_2.12.0_linux_amd64.tar.gz && \
    tar -zxvf gost_2.12.0_linux_amd64.tar.gz && \
    mv gost /usr/local/bin/gost && \
    chmod +x /usr/local/bin/gost && \
    rm gost_2.12.0_linux_amd64.tar.gz

# Non-root user
RUN adduser -D -u 1000 app

# Your start script
COPY start.sh /start.sh
RUN chmod +x /start.sh

USER app

EXPOSE 8080

CMD ["/start.sh"]