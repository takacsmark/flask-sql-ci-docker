#Import and expose environment variables
cnf ?= .env
include $(cnf)
export $(shell sed 's/=.*//' $(cnf))

.PHONY: init

help:
	@echo
	@echo "Usage: make TARGET"
	@echo
	@echo "Dockerization of the sloria/cookiecutter-flask template repo"
	@echo
	@echo "Targets:"
	@echo "	init 		initialize your app code base from the sloria/cookiecutter-flask repo"
	@echo "	init-purge 	clean up generated code"
	@echo "	dev-build 	build the Docker image for development"
	@echo "	dev-up  	start the app in development mode with Docker Compose"
	@echo "	dev-down 	stop the app in development mode with Docker Compose"
	@echo "	dev-ps  	list development containers"
	@echo "	dev-logs 	follow development logs"
	@echo "	test-run 	run the test with Docker Compose"
	@echo "	prod-build 	buld the Docker image for production"
	@echo "	prod-deploy	deploy the app in production mode to a Swam cluster"
	@echo "	prod-rm 	remove the production deployment from the Swarm"
	@echo "	aws deploy 	deploy the app in production mode to AWS"

#Generate project code base form GitHub using cookiecutter
init:
	envsubst <docker/init/cookiecutter.template.yml >docker/init/cookiecutter.yml
	docker-compose -f docker/init/docker-compose.yml up -d --build
	docker cp flask-mysql-ci-initiator:/root/$(APP_NAME) ./$(APP_NAME)
	docker-compose -f docker/init/docker-compose.yml down
	rm docker/init/cookiecutter.yml

#Remove the generated code, use this before re-running the `init` target 
init-purge: 
	sudo rm -rf ./$(APP_NAME)

#Build the development image
dev-build:
	docker-compose -f docker/dev/docker-compose.yml build

#Start up development environment
dev-up:
	docker-compose -f docker/dev/docker-compose.yml up -d

#Bring down development environment
dev-down:
	docker-compose -f docker/dev/docker-compose.yml down
	# rm secrets.env

#List development conatiners
dev-ps:
	docker-compose -f docker/dev/docker-compose.yml ps

#Show development logs
dev-logs:
	docker-compose -f docker/dev/docker-compose.yml logs -f

#Run tests
test-run:
	docker-compose -f docker/dev/docker-compose.yml up -d
	sleep 10
	docker-compose -f docker/dev/docker-compose.yml exec web flask test
	docker-compose -f docker/dev/docker-compose.yml down 
	
#Build production
prod-build:
	docker-compose -f docker/prod/docker-compose.yml build

#Deploy production stack
prod-deploy:
	docker stack deploy myflaskapp -c docker/prod/docker-compose.yml

#Remove production stack
prod-rm:
	docker stack rm myflaskapp

#AWS deploy
aws-deploy:
	docker -H localhost:2374 stack deploy myflaskapp -c docker/prod/docker-compose.yml
