NAME = haroldmei/payment
INSTANCE = payment

GROUP=k8smaster:5000/haroldmei
TRAVIS_TAG=latest

TRAVIS_COMMIT=$(TRAVIS_TAG)
COMMIT=$(TRAVIS_TAG)
.EXPORT_ALL_VARIABLES:

build:
	./scripts/build.sh
	./scripts/push.sh
    
.PHONY: default copy test

default: test

copy:
	docker create --name $(INSTANCE) $(NAME)-dev
	docker cp $(INSTANCE):/app/main $(shell pwd)/app
	docker rm $(INSTANCE)

release:
	docker build -t $(NAME) -f ./docker/payment/Dockerfile-release .

test:
	GROUP=haroldmei COMMIT=$(COMMIT) ./scripts/build.sh
	./test/test.sh unit.py
	./test/test.sh container.py --tag $(COMMIT)
