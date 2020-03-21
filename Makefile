#!make
-include .env
export $(shell sed 's/=.*//' .env)

# REGISTRY_HOST=
# REPO?=
# VERSION?=
DATE=$(shell date +%Y%m%d)
DATE_MONTH=$(shell date +%Y%m01)
REPO_VERSION=$(REPO):$(VERSION)

.PHONY: packages test setup

docker-build: setup
	docker pull $(REGISTRY_HOST)/$(REPO):master || true
	docker build --cache-from=$(REGISTRY_HOST)/$(REPO):master --tag="$(REPO_VERSION)" --tag="$(REPO):master" .
	docker tag $(REPO_VERSION) $(REGISTRY_HOST)/$(REPO_VERSION)-M$(DATE_MONTH)
	docker tag $(REPO_VERSION) $(REGISTRY_HOST)/$(REPO_VERSION)-D$(DATE)
	docker tag $(REPO_VERSION) $(REGISTRY_HOST)/$(REPO_VERSION)
	docker tag $(REPO_VERSION) $(REGISTRY_HOST)/$(REPO):master
	docker tag $(REPO_VERSION) $(REGISTRY_HOST)/$(REPO):latest

docker-push:
	docker push $(REGISTRY_HOST)/$(REPO_VERSION)-M$(DATE_MONTH)
	docker push $(REGISTRY_HOST)/$(REPO_VERSION)-D$(DATE)
	docker push $(REGISTRY_HOST)/$(REPO_VERSION)
	docker push $(REGISTRY_HOST)/$(REPO):master
	docker push $(REGISTRY_HOST)/$(REPO):latest

docker-release: docker-build docker-push

docker-image-prune:
	docker image prune --all -f

setup:
	go mod download
	go mod tidy
