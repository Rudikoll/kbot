FROM golang:1.22-alpine AS builder

WORKDIR /app
COPY . .
RUN go mod tidy
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o kbot ./cmd

FROM alpine:3.19
WORKDIR /app
COPY --from=builder /app/kbot .

CMD ["./kbot"]