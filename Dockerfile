# Build stage
FROM golang:1.22.5 AS builder
WORKDIR /app
COPY go.mod .
RUN go mod download
COPY . .
RUN go build -o main .

EXPOSE 8080
ENTRYPOINT ["./main"]

# Final stage (distroless)
FROM gcr.io/distroless/base-debian12:nonroot
WORKDIR /app
COPY --from=builder /app/main .
COPY --from=builder /app/static ./static
EXPOSE 8080
ENTRYPOINT ["./main"]


