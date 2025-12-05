FROM alpine:3.20

# Install tools needed to download gost
RUN apk add --no-cache wget ca-certificates

# Download prebuilt gost binary (linux amd64)
# If this version ever breaks, you can change v2.11.5 to a newer one from:
# https://github.com/ginuerzh/gost/releases
RUN wget -O /usr/local/bin/gost \
    https://github.com/ginuerzh/gost/releases/download/v2.11.5/gost-linux-amd64-2.11.5 && \
    chmod +x /usr/local/bin/gost

# Add non-root user
RUN adduser -D -u 1000 app

# Copy start script
COPY start.sh /start.sh
RUN chmod +x /start.sh

USER app

EXPOSE 8080

CMD ["/start.sh"]