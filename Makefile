.PHONY: build-image push-image run-image

build-image:
	sudo docker build  --no-cache -t akaesus/go2pins-docker .

push-image:
	sudo docker push akaesus/go2pins-docker

run-image:
	docker run --rm -it akaesus/go2pins-docker
