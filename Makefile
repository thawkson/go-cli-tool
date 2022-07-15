SHELL := bash
Version := $(shell git describe --tags --dirty)
GitCommit := $(shell git rev-parse HEAD)
LDFLAGS := "-s -w -X cmd.Version=$(Version) -X cmd.GitCommit=$(GitCommit)"
export GO111MODULE=on
TOOL_NAME=$(notdir $(shell pwd))
NEW_COMMAND=${CLI:-default}
SOURCE_DIRS = cmd main.go

.PHONY: all
all: gofmt darwin linux arm arm64 windows hash

.PHONY: setup
setup:
	git init
	go mod init ${TOOL_NAME}
	go get -u github.com/spf13/cobra@latest
	go install github.com/spf13/cobra-cli@latest
	cobra-cli init --viper

.PHONY: newcli
newcli:
	cobra-cli add ${NEW_COMMAND}

.PHONY: gofmt
gofmt: 
	@test -z $(gofmt -l -s $(SOURCE_DIRS) ./ | tee /dev/stderr) || (echo "[WARN] Fix formatting issues with 'make fmt'" && exit 1)

.PHONY: darwin
darwin:
	mkdir -p bin/
	rm -rf bin/${TOOL_NAME}-darwin
	CGO_ENABLED=0 GOOS=darwin go build -a -ldflags $(LDFLAGS) -installsuffix cgo -o bin/${TOOL_NAME}-darwin

.PHONY: linux
linux:
	mkdir -p bin/
	rm -rf bin/${TOOL_NAME}*
	CGO_ENABLED=0 GOOS=linux go build -a -ldflags $(LDFLAGS) -installsuffix cgo -o bin/${TOOL_NAME}

.PHONY: arm
arm:
	mkdir -p bin/
	rm -rf bin/${TOOL_NAME}armf
	GOARM=6 GOARCH=arm CGO_ENABLED=0 GOOS=linux go build -a -ldflags $(LDFLAGS) -installsuffix cgo -o bin/${TOOL_NAME}-armhf

.PHONY: arm64
arm64:
	mkdir -p bin/
	rm -rf bin/${TOOL_NAME}-arm64
	GOARCH=arm64 CGO_ENABLED=0 GOOS=linux go build -a -ldflags $(LDFLAGS) -installsuffix cgo -o bin/${TOOL_NAME}-arm64

.PHONY: windows
windows:
	mkdir -p bin/
	rm -rf bin/${TOOL_NAME}.exe
	GOOS=windows CGO_ENABLED=0 go build -a -ldflags $(LDFLAGS) -installsuffix cgo -o bin/${TOOL_NAME}.exe

.PHONY: hash
hash:
	rm -rf bin/*.sha256
	for f in bin/${TOOL_NAME}*; do shasum -a 256 $$f > $$f.sha256; done

.PHONY: clean
clean:
	rm -rf bin/