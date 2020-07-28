SHORT_NAME ?= registry-token-refresher

include versioning.mk

# Enable vendor/ directory support.
export GO15VENDOREXPERIMENT=1

# dockerized development environment variables
REPO_PATH := github.com/drycc/${SHORT_NAME}
DEV_ENV_IMAGE := drycc/go-dev
DEV_ENV_WORK_DIR := /go/src/${REPO_PATH}
DEV_ENV_PREFIX := docker run --rm -e GO15VENDOREXPERIMENT=1 -v ${CURDIR}:${DEV_ENV_WORK_DIR} -w ${DEV_ENV_WORK_DIR}
DEV_ENV_CMD := ${DEV_ENV_PREFIX} ${DEV_ENV_IMAGE}

# SemVer with build information is defined in the SemVer 2 spec, but Docker
# doesn't allow +, so we use -.
BINARY_DEST_DIR := rootfs/usr/bin
# Common flags passed into Go's linker.
LDFLAGS := "-s -w -X main.version=${VERSION}"
# Docker Root FS
BINDIR := ./rootfs

DRYCC_REGISTRY ?= ${DEV_REGISTRY}

all:
	@echo "Use a Makefile to control top-level building of the project."

bootstrap:
	${DEV_ENV_CMD} go mod vendor

# This illustrates a two-stage Docker build. docker-compile runs inside of
# the Docker environment. Other alternatives are cross-compiling, doing
# the build as a `docker build`.
build-binary:
	${DEV_ENV_CMD} sh -c 'go build -ldflags ${LDFLAGS} -o ${BINARY_DEST_DIR}/boot boot.go'

test: test-style
	${DEV_ENV_CMD} sh -c 'go test ./...'

test-style:
	${DEV_ENV_CMD} lint --deadline

update-changelog:
	${DEV_ENV_PREFIX} -e RELEASE=${WORKFLOW_RELEASE} ${DEV_ENV_IMAGE} gen-changelog.sh \
	  | cat - CHANGELOG.md > tmp && mv tmp CHANGELOG.md

docker-build: build-binary
	docker build ${DOCKER_BUILD_FLAGS} -t ${IMAGE} rootfs
	docker tag ${IMAGE} ${MUTABLE_IMAGE}

.PHONY: all docker-build test
