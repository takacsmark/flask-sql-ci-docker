#Import and expose environment variables
cnf ?= .env
include $(cnf)
export $(shell sed 's/=.*//' $(cnf))

#Create secret for development
DEV_SECRET=$(shell echo  $(APP_NAME) | tr /a-z/ /A-Z/ )_SECRET=$(shell openssl rand -base64 32)

.PHONY: init

help:
	@echo
	@echo "Usage: make TARGET"
	@echo
	@echo "$(PROJECT_NAME) project automation helper"
	@echo
	@echo "Targets:"
	@echo "	init 		generate source code base from GitHub repo"
	@echo "	init-purge 	clean up generated code" 

#Generate project code base form GitHub using cookiecutter
init:
	envsubst <docker/init/cookiecutter.template.yml >docker/init/cookiecutter.yml
	docker-compose -f docker/init/docker-compose.yml up -d --build
	docker cp flask-mysql-ci-initiator:/root/$(APP_NAME) ./$(APP_NAME)
	sed -i 's/NODE_ENV=debug webpack-dev-server --port 2992 --hot --inline/NODE_ENV=debug webpack-dev-server --port 2992 --hot --inline --host 0.0.0.0/' ./$(APP_NAME)/package.json
	sed -i 's/FLASK_DEBUG=1 flask run/FLASK_DEBUG=1 flask run --host=0.0.0.0/' ./$(APP_NAME)/package.json
	docker-compose -f docker/init/docker-compose.yml down
	rm docker/init/cookiecutter.yml

#Remove the generated code, use this before re-running the `init` target 
init-purge: 
	sudo rm -rf ./$(APP_NAME)

#Write the development secret to file
.dev-secret:
	echo $(DEV_SECRET) > secrets.env

#Build the development image
dev-build:
	docker-compose -f docker/dev/docker-compose.yml build

#Start up development environment
dev-up: .dev-secret
	docker-compose -f docker/dev/docker-compose.yml up -d

#Bring down development environment
dev-down:
	docker-compose -f docker/dev/docker-compose.yml down
	rm secrets.env

#List development conatiners
dev-ps:
	docker-compose -f docker/dev/docker-compose.yml ps

#Show development logs
dev-logs:
	docker-compose -f docker/dev/docker-compose.yml logs -f

#Run tests
test-run: .dev-secret
	docker-compose -f docker/dev/docker-compose.yml up -d
	sleep 10
	docker-compose -f docker/dev/docker-compose.yml exec web flask test
	docker-compose -f docker/dev/docker-compose.yml down 
	

