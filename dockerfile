# Stage 1: Build
FROM golang:1.21-alpine AS builder

ARG TARGETOS=linux
ARG TARGETARCH=amd64

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} \
    go build -ldflags="-w -s" -o kbot .

# Stage 2: Runtime
FROM scratch

WORKDIR /

COPY --from=builder /app/kbot /kbot

ENTRYPOINT ["/kbot"]
