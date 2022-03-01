## Make settings
.DEFAULT_GOAL := bin/

## Vars
GO_SRC := $(shell find . -type f -name "*.go" -not -path "./vendor/*")
VENDOR_DIRS := $(shell find vendor/ -mindepth 1 -maxdepth 3 -type d 2>/dev/null | sort | uniq)

bin/: $(GO_SRC) ./vendor/ $(VENDOR_DIRS)
	go build \
		-o bin/ \
		.

go.mod:
	go mod init

go.sum:
	go mod tidy

./vendor/: go.mod go.sum
	go mod vendor

