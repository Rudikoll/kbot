APP=kbot
REGISTRY=ghcr.io
REPO=rudikoll/kbot

VERSION=1.0.0
COMMIT=$(shell git rev-parse --short HEAD)

TAG=v$(VERSION)-$(COMMIT)
IMAGE=$(REGISTRY)/$(REPO):$(TAG)-linux-amd64

build:
	go build -o bin/$(APP) ./cmd

docker-build:
	docker build -t $(IMAGE) .

docker-push:
	docker push $(IMAGE)

helm-update:
	sed -i "s/tag:.*/tag: \"$(TAG)\"/" helm/kbot/values.yaml

all: docker-build docker-push helm-update
