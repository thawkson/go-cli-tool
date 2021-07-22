SHELL := bash
Version := $(shell git describe --tags --dirty)
GitCommit := $(shell git rev-parse HEAD)
LDFLAGS := "-s -w -X cmd.Version=$(Version) -X cmd.GitCommit=$(GitCommit)"
export GO111MODULE=on
SOURCE_DIRS = cmd main.go

.PHONY: all
all: gofmt dist hash

.PHONY: gofmt
gofmt: 
	@test -z $(gofmt -l -s $(SOURCE_DIRS) ./ | tee /dev/stderr) || (echo "[WARN] Fix formatting issues with 'make fmt'" && exit 1)

.PHONY: dist
dist:
	mkdir -p bin/
	rm -rf bin/tool*
	CGO_ENABLED=0 GOOS=linux go build -a -ldflags $(LDFLAGS) -installsuffix cgo -o bin/tool
	CGO_ENABLED=0 GOOS=darwin go build -a -ldflags $(LDFLAGS) -installsuffix cgo -o bin/tool-darwin
	GOARM=6 GOARCH=arm CGO_ENABLED=0 GOOS=linux go build -a -ldflags $(LDFLAGS) -installsuffix cgo -o bin/tool-armhf
	GOARCH=arm64 CGO_ENABLED=0 GOOS=linux go build -a -ldflags $(LDFLAGS) -installsuffix cgo -o bin/tool-arm64
	GOOS=windows CGO_ENABLED=0 go build -a -ldflags $(LDFLAGS) -installsuffix cgo -o bin/tool.exe

.PHONY: hash
hash:
	rm -rf bin/*.sha256 && ./generators/hashgen.sh