## Make settings
.DEFAULT_GOAL := $OUT_PATH

## Vars
OUT_PATH := bin/$(shell basename $$(pwd))
GO_SRC := $(shell find . -type f -name "*.go" -not -path "./vendor/*")
VENDOR_DIRS := $(shell find vendor/ -mindepth 1 -maxdepth 3 -type d 2>/dev/null | sort | uniq)
VERSION_FILE := ./version
VERSION := $(shell cat "${VERSION_FILE}")

## Build targets
$OUT_PATH: $(GO_SRC) ./vendor/ $(VENDOR_DIRS)
	@echo "Compiling to ${OUT_PATH}"
	go build \
		-o "${OUT_PATH}" \
		-ldflags="-X 'main.Version=${VERSION}'" \
		.

go.mod:
	go mod init

go.sum:
	go mod tidy

./vendor/: go.mod go.sum
	go mod vendor

## Test targets
.PHONY: test
test: ./vendor/
	go test ./...

## Versioning targets
.PHONY: version
version:
	@echo "Use the bump_major, bump_minor, bump_patch, and set_pre_release targets to manage the project version"
	@echo "To set the pre-release version in each, set the P variable e.g."
	@echo "    make bump_minor P=beta-1"
.PHONY: bump_major
bump_major:
	@EXTRA_ARGS=""
	@if [ ! -z "${P:-}" ]; then EXTRA_ARGS="-r ${P}"; fi
	@./semver.sh -v "${VERSION}" -M ${EXTRA_ARGS} > "${VERSION_FILE}"

.PHONY: bump_minor
bump_minor:
	@EXTRA_ARGS=""
	@if [ ! -z "${P:-}" ]; then EXTRA_ARGS="-r ${P}"; fi
	@./semver.sh -v "${VERSION}" -m ${EXTRA_ARGS} > "${VERSION_FILE}"

.PHONY: bump_patch
bump_patch:
	@EXTRA_ARGS=""
	@if [ ! -z "${P:-}" ]; then EXTRA_ARGS="-r ${P}"; fi
	@./semver.sh -v "${VERSION}" -p ${EXTRA_ARGS} > "${VERSION_FILE}"

.PHONY: set_pre_release
set_pre_release:
	@if [ -z "$P" ]; then \
      echo "Set the value with P=value"; \
    else \
	  ./semver.sh -v "${VERSION}" -r "${P}" > "${VERSION_FILE}"; \
  	fi