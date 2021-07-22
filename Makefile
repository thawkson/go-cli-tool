SHELL := bash
Version := $(shell git describe --tags --dirty)
GitCommit := $(shell git rev-parse HEAD)
LDFLAGS := "-s -w"
export GO111MODULE=on
SOURCE_DIRS = cmd main.go
GOPATH=${PWD}/cmd

.PHONY: all
all: gofmt dist hash

.PHONY: gofmt
gofmt: 
	@test -z $(gofmt -l -s $(SOURCE_DIRS) ./ | tee /dev/stderr) || (echo "[WARN] Fix formatting issues with 'make fmt'" && exit 1)

.PHONY: dist
dist:
	mkdir -p bin/
	rm -rf bin/tool*
	GOOS=linux go build -o bin/tool cmd/main.go
	GOOS=darwin go build -o bin/tool-darwin cmd/main.go
	GOARM=6 GOARCH=arm GOOS=linux go build -o bin/tool-armhf cmd/main.go
	GOARCH=arm64 GOOS=linux go build -o bin/tool-arm64 cmd/main.go
	GOOS=windows go build -o bin/tool.exe cmd/main.go

.PHONY: hash
hash:
	rm -rf bin/*.sha256 && ./generators/hashgen.sh