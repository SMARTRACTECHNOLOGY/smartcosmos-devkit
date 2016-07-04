


build:
	@docker-compose -p devkit build

run:
	@docker-compose -p devkit up -d data master

stop:
	@docker-compose -p devkit stop

clean: stop
	@docker-compose -p devkit rm master

clean-data: clean
	@docker-compose -p devkit rm -v data

clean-images:
	@docker rmi `docker images -q -f "dangling=true"`
