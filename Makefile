PROJECT = concourse-helm3
ID ?= YOUR_DOCKER_HOST_HERE/${PROJECT}
TAG ?= release-candidate

all: build push

build:
	docker build --tag ${ID}:${TAG} .

push:
	docker push ${ID}

run:
	docker run \
		--volume $(shell pwd):/opt/helm-3 \
		--workdir /opt/helm-3 \
		--interactive \
		--tty \
		${ID}:latest \
		bash
