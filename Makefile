build:
	@docker-compose build

bash:
	docker compose up -d
	docker exec -it app-two bash

down:
	@docker compose down


