# Build stage
FROM golang:1.23.2-alpine AS builder

# Set working directory
WORKDIR /app

# Copy go mod files
COPY go.mod ./

# Download dependencies
RUN go mod download

# Copy source code
COPY main.go ./

# Build the application
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o personal-website main.go

# Runtime stage
FROM alpine:latest

# Install ca-certificates for HTTPS requests (if needed)
RUN apk --no-cache add ca-certificates

WORKDIR /root/

# Copy the binary from builder
COPY --from=builder /app/personal-website .

# Copy static files and HTML
COPY index.html ./
COPY static ./static

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/health || exit 1

# Run the application
CMD ["./personal-website"]
