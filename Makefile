.PHONY: up

SHELL := $(shell which bash)

DIR   := $(shell basename $$PWD)

# export DOCKER_IP = $(shell which docker-machine > /dev/null 2>&1 && docker-machine ip $(DOCKER_MACHINE_NAME))

export PATH := ./bin:./venv/bin:$(PATH)

YOUR_HOSTNAME := $(shell hostname | cut -d "." -f1 | awk '{print $1}')

export HOST_IP=$(shell curl ipv4.icanhazip.com 2>/dev/null)

username := bossjones
container_name := gnome-builder-meson
docker_developer_chroot := .docker-developer

GIT_BRANCH    = $(shell git rev-parse --abbrev-ref HEAD)
GIT_SHA       = $(shell git rev-parse HEAD)
BUILD_DATE    = $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")
VERSION       = latest
NON_ROOT_USER = developer

LOCAL_REPOSITORY = $(HOST_IP):5000

TAG ?= $(VERSION)
ifeq ($(TAG),@branch)
	override TAG = $(shell git symbolic-ref --short HEAD)
	@echo $(value TAG)
endif

list:
	@$(MAKE) -qp | awk -F':' '/^[a-zA-Z0-9][^$#\/\t=]*:([^=]|$$)/ {split($$1,A,/ /);for(i in A)print A[i]}' | sort

build:
	docker build --tag $(username)/$(container_name):$(GIT_SHA) . ; \
	docker tag $(username)/$(container_name):$(GIT_SHA) $(username)/$(container_name):latest
	docker tag $(username)/$(container_name):$(GIT_SHA) $(username)/$(container_name):$(TAG)

build-force:
	docker build --rm --force-rm --pull --no-cache -t $(username)/$(container_name):$(GIT_SHA) . ; \
	docker tag $(username)/$(container_name):$(GIT_SHA) $(username)/$(container_name):latest
	docker tag $(username)/$(container_name):$(GIT_SHA) $(username)/$(container_name):$(TAG)

build-local:
	docker build --tag $(username)/$(container_name):$(GIT_SHA) . ; \
	docker tag $(username)/$(container_name):$(GIT_SHA) $(LOCAL_REPOSITORY)/$(username)/$(container_name):latest

tag-local:
	docker tag $(username)/$(container_name):$(GIT_SHA) $(LOCAL_REPOSITORY)/$(username)/$(container_name):$(TAG)
	docker tag $(username)/$(container_name):$(GIT_SHA) $(LOCAL_REPOSITORY)/$(username)/$(container_name):latest

push-local:
	docker push $(LOCAL_REPOSITORY)/$(username)/$(container_name):$(TAG)
	docker push $(LOCAL_REPOSITORY)/$(username)/$(container_name):latest

build-push-local: build-local tag-local push-local

tag:
	docker tag $(username)/$(container_name):$(GIT_SHA) $(username)/$(container_name):latest
	docker tag $(username)/$(container_name):$(GIT_SHA) $(username)/$(container_name):$(TAG)

build-push: build tag
	docker push $(username)/$(container_name):latest
	docker push $(username)/$(container_name):$(GIT_SHA)
	docker push $(username)/$(container_name):$(TAG)

push:
	docker push $(username)/$(container_name):latest
	docker push $(username)/$(container_name):$(GIT_SHA)
	docker push $(username)/$(container_name):$(TAG)

push-force: build-force push

dc-up:
	docker-compose -f docker-compose.yml create && \
	docker-compose -f docker-compose.yml start

dc-down:
	docker-compose -f docker-compose.yml stop && \
	docker-compose -f docker-compose.yml down

dc-restart: dc-down dc-up

dc-build:
	docker-compose build --force-rm --pull

pull:
	docker-compose pull

up: pull
	docker-compose up

dev-up: up

dev-down: down

up-d: pull
	docker-compose up -d

down:
	docker-compose down && \
	docker-compose rm -f

restart: down up

run-bash:
	docker run --rm \
	-it \
	-e UID \
	-e GID \
	-e DISPLAY=$$DISPLAY \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v /run/user/$(UID)/pulse:/run/pulse \
	\
	-v $(PWD):/home/$(NON_ROOT_USER)/$(DIR) \
	-v /usr/share/fonts:/usr/local/share/fonts:ro \
	-v /usr/share/themes:/usr/local/share/themes:ro \
	-v /usr/share/icons:/usr/local/share/icons:ro \
	-w /home/$(NON_ROOT_USER)/$(DIR) \
	\
	$(username)/$(container_name):latest bash


shell:
	docker exec -ti $(username)/$(container_name):latest /bin/bash

tail:
	docker logs -f $(container_name)

travis: build


# https://cntnr.io/running-guis-with-docker-on-mac-os-x-a14df6a76efc
setup-socat:
	setup-socat

run-gnome-builder: xstart
	docker-run-bash

run-xquartz-proxy:
	xstart

xquartz-proxy: run-xquartz-proxy

xstart:
	xstart

mkdirs:
	mkdir -p $$HOME/$(docker_developer_chroot)

run-dev:
	dev-entrypoint.sh
