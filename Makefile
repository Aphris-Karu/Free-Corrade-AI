VERSION=2.2.3
REGISTRY=192.168.1.222:5000
all:
	# Only available as a public build
	docker build -t ${REGISTRY}/bot-ai\:latest -t ${REGISTRY}/bot-ai\:${VERSION} .
	docker push ${REGISTRY}/bot-ai\:latest
	docker push ${REGISTRY}/bot-ai\:${VERSION}

