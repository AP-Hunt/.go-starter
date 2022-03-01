## Make settings
.DEFAULT_GOAL := bin/

## Vars
GO_SRC := $(shell find . -type f -name "*.go" -not -path "./vendor/*")

bin/: $(GO_SRC)
	go build \
		-o bin/ \
		.
