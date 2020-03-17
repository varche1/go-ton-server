FROM debian:testing as builder


ENV GO111MODULE=on
ENV CGO_ENABLED=1
ENV GOFLAGS="-mod=vendor"
WORKDIR /app

RUN apt update
RUN apt install -y golang openssl libssl-dev

COPY . .

COPY ./vendor/github.com/mercuryoio/tonlib-go/v2/lib/linux/* ./linux/

RUN ls .


RUN LD_LIBRARY_PATH=$LD_LIBRARY_PATH:./linux go build

FROM debian:testing as worker

RUN apt update -y
RUN apt install -y openssl libssl-dev curl ca-certificates
RUN addgroup --gid 10001 app && \
    adduser --disabled-password --gid 10001 --home /app --uid 10001 app

USER app
# path of application code at builder container and at this container must be the same for proper showing stacktrace at sentry
WORKDIR /app

COPY --from=builder /app/go-ton-server ./
COPY --from=builder /app/linux/* ./linux/
COPY tonlib.config.json ./
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:./linux
EXPOSE 8000

ENTRYPOINT ["/app/go-ton-server"]
