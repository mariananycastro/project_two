build:
	@docker compose build

bash:
	docker compose up -d
	docker exec -it app-two bash

down:
	@docker compose down

server:
	docker compose up -d
	docker exec -it app-two /bin/sh -c "bundle exec rackup --host 0.0.0.0 -p 4000"
