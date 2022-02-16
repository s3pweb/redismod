VERSION = $(shell grep 'ARG REDIS_VER=' Dockerfile | cut -d'=' -f2)

.PHONY: version build push

all: build

version:
	@echo "$(VERSION)"

build: Dockerfile
	@docker build -t s3pweb/redismod:$(VERSION) -f $< .

push:
	@docker push s3pweb/redismod:$(VERSION)

