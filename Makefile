APP       := kbot
REGISTRY  := ghcr.io
OWNER     := $(shell git config --get remote.origin.url | sed 's/.*github.com[:/]\([^/]*\)\/.*/\1/' | tr '[:upper:]' '[:lower:]')
REPO      := $(REGISTRY)/$(OWNER)/$(APP)

APP_VERSION  := $(shell git describe --tags --abbrev=0 2>/dev/null || echo "v1.0.0")
SHORT_SHA    := $(shell git rev-parse --short HEAD)
TAG          := $(APP_VERSION)-$(SHORT_SHA)

TARGETOS   ?= linux
TARGETARCH ?= amd64

IMAGE := $(REPO):$(TAG)-$(TARGETOS)-$(TARGETARCH)

.PHONY: all build push image clean help version

all: build image push

## Show current version/tag info
version:
	@echo "App:     $(APP)"
	@echo "Version: $(APP_VERSION)"
	@echo "SHA:     $(SHORT_SHA)"
	@echo "Tag:     $(TAG)"
	@echo "Image:   $(IMAGE)"

## Build Go binary
build:
	CGO_ENABLED=0 GOOS=$(TARGETOS) GOARCH=$(TARGETARCH) \
	  go build -ldflags="-w -s" -o $(APP) .

## Build Docker image
image:
	docker build \
	  --platform $(TARGETOS)/$(TARGETARCH) \
	  --build-arg TARGETOS=$(TARGETOS) \
	  --build-arg TARGETARCH=$(TARGETARCH) \
	  -t $(IMAGE) \
	  -t $(REPO):latest \
	  .
	@echo "Built: $(IMAGE)"

## Push image to registry
push:
	docker push $(IMAGE)
	docker push $(REPO):latest
	@echo "Pushed: $(IMAGE)"

## Update Helm chart tag
helm-update:
	sed -i 's/tag: .*/tag: "$(TAG)"/' helm/values.yaml
	@echo "Updated helm/values.yaml tag → $(TAG)"

## Remove binary
clean:
	rm -f $(APP)

## Show help
help:
	@grep -E '^##' Makefile | sed 's/## //'
