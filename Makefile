.PHONY: up

SHELL := $(shell which bash)

DIR   := $(shell basename $$PWD)

TRACE=

ifdef trace
TRACE=1
endif

# export DOCKER_IP = $(shell which docker-machine > /dev/null 2>&1 && docker-machine ip $(DOCKER_MACHINE_NAME))

ED=\033[0;31m
GREEN=\033[0;32m
ORNG=\033[38;5;214m
BLUE=\033[38;5;81m
NC=\033[0m

export RED
export GREEN
export NC
export ORNG
export BLUE

export PATH := ./bin:./venv/bin:$(PATH)

YOUR_HOSTNAME := $(shell hostname | cut -d "." -f1 | awk '{print $1}')

export HOST_IP=$(shell curl ipv4.icanhazip.com 2>/dev/null)

username := scarlettos
container_name := docker-gnome-builder-meson
docker_developer_chroot := .docker-developer

GIT_BRANCH    = $(shell git rev-parse --abbrev-ref HEAD)
GIT_SHA       = $(shell git rev-parse HEAD)
BUILD_DATE    = $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")
VERSION       = latest
NON_ROOT_USER = developer

IMAGE_TAG      := $(username)/$(container_name):$(GIT_SHA)
CONTAINER_NAME := $(shell echo -n $(IMAGE_TAG) | openssl dgst -sha1 | sed 's/^.* //'  )

LOCAL_REPOSITORY = $(HOST_IP):5000

TAG ?= $(VERSION)
ifeq ($(TAG),@branch)
	override TAG = $(shell git symbolic-ref --short HEAD)
	@echo $(value TAG)
endif

# verify that certain variables have been defined off the bat
check_defined = \
    $(foreach 1,$1,$(__check_defined))
__check_defined = \
    $(if $(value $1),, \
      $(error Undefined $1$(if $(value 2), ($(strip $2)))))

list_allowed_args := interface

list:
	@$(MAKE) -qp | awk -F':' '/^[a-zA-Z0-9][^$#\/\t=]*:([^=]|$$)/ {split($$1,A,/ /);for(i in A)print A[i]}' | sort

# FIXME: Implement this
build-two-phase: build
	time docker run \
	--privileged \
	-i \
	-e TRACE=1 \
	--cap-add=ALL \
	--tty \
	--name $(CONTAINER_NAME) \
	--entrypoint "bash" \
	$(IMAGE_TAG) \
	/app/bin/flatpak-bootstrap.sh

# Commit backend Container
	time docker commit --message "Makefile docker CI dep install for $(username)/$(container_name)" $(CONTAINER_NAME) $(IMAGE_TAG)
	time docker commit --message "Makefile docker CI dep install for $(username)/$(container_name)" $(CONTAINER_NAME) $(username)/$(container_name):latest

# Commit backend Container
build-commit:
	time docker commit --message "Makefile docker CI dep install for $(username)/$(container_name)" $(CONTAINER_NAME) $(IMAGE_TAG)

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

build-push-two-phase: build-two-phase tag push

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

pull-latest:
	docker pull $(username)/$(container_name):latest

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
	--privileged \
	--cap-add=ALL \
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

docker-run-bash-osx: xstart
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

run-tmux:
	tmux-entrypoint.sh

start:
	echo hi

start-socat:
	$(call check_defined, interface, Please set interface)
	start-socat $(interface)

kill-socat:
	kill-socat

stop-start-socat: kill-socat start-socat

start-xquartz:
	start-xquartz

setup-xhost:
	$(call check_defined, interface, Please set interface)
	setup-xhost $(interface)

# run:
# 	$(call check_defined, interface, Please set interface)
# 	$(MAKE) setup-xhost $(interface)
# 	$(MAKE) start-socat $(interface)
# 	$(MAKE) start-xquartz
# 	$$TRACE docker-run-dbus-shell.sh $(interface)

run: setup-xhost start-socat start-xquartz
	$(call check_defined, interface, Please set interface)
	docker-run-dbus-shell.sh $(interface)

run-gnome-builder: TRACE=1
run-gnome-builder:
	$(call check_defined, interface, Please set interface)
	run-gnome-builder.sh $(interface)

entrypoint-dbus-bash:
	entrypoint-dbus-bash

docker-run-dbus-shell:
	$(call check_defined, interface, Please set interface)
	docker-run-dbus-shell.sh $(interface)

run-usage:
	echo "make run interface=en0 trace=1"

flatpak-builder-bash:
	flatpak run --command=bash --filesystem=host org.gnome.Sdk/x86_64/3.24
