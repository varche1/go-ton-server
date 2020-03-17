FROM docker.cryptology.com/base/ci-image:latest as builder

RUN go get github.com/ahmetb/govvv

ENV GO111MODULE=on
ENV CGO_ENABLED=0
ENV GOFLAGS="-mod=vendor"
WORKDIR /app

COPY . .

RUN go build

FROM alpine:3.10.1

RUN apk update && apk upgrade 
RUN apk add --update \
    curl \
    libc6-compat \
    && rm -rf /var/cache/apk/*

RUN addgroup -g 10001 app && \
    adduser -D -G app -h /app -u 10001 app
RUN apk --no-cache add ca-certificates && update-ca-certificates
USER app
# path of application code at builder container and at this container must be the same for proper showing stacktrace at sentry
WORKDIR /app
EXPOSE 8000
ENTRYPOINT ["go-ton-server"]
