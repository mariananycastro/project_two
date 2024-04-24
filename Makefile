build:
	@docker-compose build

bash:
	docker compose up -d
	docker exec -it app-two bash

down:
	@docker compose down

rabbit:
	@docker run --rm -p 15672:15672 -p 5672:5672 --name rabbitmq --network initiatives rabbitmq:3-management

stop: # make stop container_name=rabbitmq
	docker stop ${container_name}

server:
	docker compose up -d
	docker exec -it app-two /bin/sh -c "bundle exec rackup --host 0.0.0.0 -p 4000"
