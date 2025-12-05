FROM golang:1.22-alpine AS builder

RUN apk add --no-cache git
RUN git clone https://github.com/ginuerzh/gost.git /src
WORKDIR /src
RUN go build ./cmd/gost -o /gost

FROM alpine:3.20

RUN adduser -D -u 1000 app

COPY --from=builder /gost /usr/local/bin/gost
COPY start.sh /start.sh
RUN chmod +x /start.sh

USER app

EXPOSE 8080
CMD ["/start.sh"]