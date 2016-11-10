all: build

help:
	@echo ""
	@echo "-- Help Menu"
	@echo ""
	@echo "   1. make build       - build the redmine image"
	@echo "   2. make quickstart  - start redmine"
	@echo "   3. make stop        - stop redmine"
	@echo "   4. make logs        - view logs"
	@echo "   5. make purge       - stop and remove the container"

build:
	@docker build --tag=jda/teo .

release:
	@docker build --tag=jda/teo:$(shell cat VERSION) .

quickstart:
	@echo "Starting TEO..."
	@docker run --name=teo-demo -d -p 10080:80 \
		-v /var/run/docker.sock:/run/docker.sock \
		-v $(shell which docker):/bin/docker \
		jda/teo:latest >/dev/null
	@echo "Please be patient. This could take a while..."
	@echo "TEO will be available at http://localhost:10080"
	@echo "Type 'make logs' for the logs"

stop:
	@echo "Stopping TEO..."
	@docker stop teo-demo >/dev/null

purge: stop
	@echo "Removing stopped container..."
	@docker rm teo-demo >/dev/null

logs:
	@docker logs -f teo-demo

