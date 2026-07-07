FROM alpine:3.20

RUN apk add --no-cache icu-libs icu ca-certificates tzdata

COPY Cli /usr/local/bin/Cli
RUN chmod +x /usr/local/bin/Cli

RUN adduser -D -H -u 1000 cliuser
USER cliuser

ENTRYPOINT ["/usr/local/bin/Cli"]
CMD ["start", "accept", "--token"]
