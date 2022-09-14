.PHONY: build run

REPO  ?= zongxin/ubuntu-develop
TAG   ?= latest
ARCH  ?= amd64

build: $(templates)
	docker build \
	--network=host \
	--build-arg http_proxy=${http_proxy} \
	--build-arg https_proxy=${https_proxy} \
	-f docker/Dockerfile.$(ARCH) \
	-t $(REPO)-$(ARCH):$(TAG) .

run:
	docker run --privileged -it \
	-p 6080:80 -p 5900:5900 \
	-e USER=zongxin -e PASSWORD=zongxin \
	-v /dev/shm:/dev/shm \
	$(REPO)-$(ARCH):$(TAG) bash

clean:
	docker rmi $(REPO)-$(ARCH):$(TAG)
	docker image prune -f
	docker stop $(docker ps -a | grep "Exited" | awk '{print $1 }')
	docker rm $(docker ps -a | grep "Exited" | awk '{print $1 }')
	docker rmi $(docker images | grep "none" | awk '{print $3}')