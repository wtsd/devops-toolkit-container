SHELL := /bin/bash

build:
	docker compose build

up:
	docker compose up -d

down:
	docker compose down

shell:
	docker exec -it devops-toolbox bash

logs:
	docker logs -f devops-toolbox
