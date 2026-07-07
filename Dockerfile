FROM alpine:3.20

RUN apk add --no-cache icu-libs icu ca-certificates tzdata bash wget proxychains-ng

COPY Cli /usr/local/bin/Cli
COPY start.sh /start.sh

RUN chmod +x /usr/local/bin/Cli /start.sh

WORKDIR /traffmonetizer

ENTRYPOINT ["/start.sh"]
