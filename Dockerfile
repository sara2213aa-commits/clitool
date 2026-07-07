FROM alpine:3.20

RUN apk add --no-cache icu-libs icu ca-certificates tzdata bash wget proxychains-ng

COPY Cli /usr/local/bin/Cli
RUN chmod +x /usr/local/bin/Cli

RUN mkdir -p /traffmonetizer && chown -R 1000:1000 /traffmonetizer

RUN adduser -D -H -u 1000 cliuser
USER cliuser

WORKDIR /traffmonetizer

ENTRYPOINT ["sh", "-c"]
CMD ["echo 'Use --start or run with proxychains'"]
