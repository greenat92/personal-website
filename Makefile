# Variables
APP_NAME = personal-website
PORT = 8080

# Default target
all: build run

# Build the binary
build:
	go build -o $(APP_NAME) main.go

# Run the server
run:
	./$(APP_NAME)

# Test the code
test:
	go test ./...

# Clean up binary
clean:
	rm -f $(APP_NAME)

# Format the code
format:
	go fmt ./...

# Install dependencies
deps:
	go mod tidy
