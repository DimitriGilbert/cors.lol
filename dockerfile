# Build stage: compile the Go binary
FROM golang:1.23-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o corsl .
  
# Final stage: small runtime image
FROM alpine:latest
WORKDIR /root/
COPY --from=builder /app/corsl .
EXPOSE 8080
ENTRYPOINT ["./corsl"]
