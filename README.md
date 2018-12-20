# flask-sql-ci-docker

A containerized version of the [https://github.com/sloria/cookiecutter-flask](https://github.com/sloria/cookiecutter-flask) template project.

[![Build Status](https://travis-ci.org/takacsmark/flask-sql-ci-docker.svg?branch=master)](https://travis-ci.org/takacsmark/flask-sql-ci-docker)

## What is this repository

This repo adds Docker containers to the [https://github.com/sloria/cookiecutter-flask](https://github.com/sloria/cookiecutter-flask) template project.

The original project at [https://github.com/sloria/cookiecutter-flask](https://github.com/sloria/cookiecutter-flask) is a template for Flask based web applications with best practices and well-written boilerplate for development, testing and production.

This repo adds Docker containers to the original project so that you can:

* Generate the initial source code of your Flask application with a Docker container.
* Develop your Flask application with Docker.
* Run Flask tests with Docker.
* Run your tests with Travis-CI and push your image to the Docker Hub from Travis.
* Run your Flask application in Swarm mode.
* Run your Flask application with Kubernetes.

## Purpose and disclaimer

This repository was created for Docker learning, a step-by-step guide to build this repository is described [here](https://takacsmark.com/get-started-with-docker-in-your-projects-through-examples/).

The repo contains a basic production configuration and was lightly tested in production. If you are using this repo in production you are welcome to contribute.

## Usage

## Installation

Clone this repository to your computer.

```terminal
git clone git@github.com:takacsmark/flask-sql-ci-docker.git
```

Change working directory.

```terminal
cd flask-sql-ci-docker
```

## Initialize your Flask application

In this step you'll generate the source code of your Flask application.

**Customize the environment variables below the following line in the `.env` file:**

```shell
# Customize these variables before initialization
```

Generate the source code of your Flask Web application.

```terminal
make init
```

## Development

Build the development Docker image.

```terminal
make dev-build
```

Start the application in development mode.

```termnial
make dev-up
```

You can access the application on `localhost:5000`.

_Please note that you need to initialize the database to make your application work._ You can achieve this executing the following steps:

* Identify your application's Docker container with `docker ps`.
* Open an interactive shell in the container with `docker exec -ti <container_id> /bin/ash`.
* Initialize the db with `flask db init && flask db migrate && flask db upgrade`.

You can read more about this in the [sloria repo](https://github.com/sloria/cookiecutter-flask/tree/master/%7B%7Bcookiecutter.app_name%7D%7D).

Follow the logs.

```terminal
make dev-logs
```

Stop the containers with the following command:

```terminal
make dev-down
```

## Testing

Run the automated tests.

```terminal
make test-run
```

## Production

Start up a Swarm cluster, or just enter Swam mode on your computer.

```termninal
docker swarm init
```

Create the `_db_password.txt` and `_app_secret.txt` files copying `_db_password.txt.sample` and `_app_secret.txt.sample`. Add your desired password and key into the text files.

Build the production image.

```terminal
make prod-build
```

Deploy the application to Swarm.

```terminal
make prod-deploy
```

Initialize the database.

* Identify your application's Docker container with `docker ps`.
* Open an interactive shell in the container with `docker exec -ti <container_id> /bin/ash`.
* Export the environment variables from secrets with `. ./exportsecret.sh`.
* Initialize the db with `flask db init && flask db migrate && flask db upgrade`.

Access the application on `localhost:5000`.

Use standard Swarm management commands to see logs and manage your stack, e.g.:

```terminal
docker service ls
```

Remove your deployment.

```terminal
make prod-rm
```

## Kubernetes

The repo features a basic Kubernetes deployment showcase.

Install a hypervisor, kubectl and Minikube as described [here](https://kubernetes.io/docs/tasks/tools/install-minikube/).

Start up Minikube.

```terminal
minikube start
```

Start up the dashboard if you prefer visual feedback.

```terminal
minikube dashboard &
```

Create the secrets.

```terminal
kubectl create secret generic app-secret --from-file ./_app_secret.txt
kubectl create secret generic db-password --from-file ./_db_password.txt
```

Deploy the database.

```termnial
kubectl create -f docker/prod/postgres-deployment.yaml
```

Push the Flask application image to the Docker Hub. _Note: if you did not change the DOCKER\_USERNAME configuration in the .env file, then you can skip this step and use the [default image that lives on the Docker Hub](https://cloud.docker.com/repository/docker/takacsmark/flask-sql-ci-web)._

```terminal
docker login
docker-compose -f docker/prod/docker-compose.yml push
```

Deploy the application to Minikube.

```terminal
kubectl create -f docker/prod/web-deployment.yaml
```

Initialize the database.

* Identify your application's Docker container with `kubectl get pods`.
* Open an interactive shell in the container with `kubectl exec -ti <pod_name> /bin/ash`.
* Export the environment variables from secrets with `. ./exportsecret.sh`.
* Initialize the db with `flask db init && flask db migrate && flask db upgrade`.

Access the application running the below command.

```termnial
minikube service web
```

## Compatibility with the sloria/cookiecutter-flask repo

The sloria/cookiecutter-flask repo is under continuous development, therefore this repo is bound to a specific commit of the sloria repo to make its functionality stable.

The commit id can be found in the `.env` file.

The initialization step takes the exact commit from the sloria repo and this solution is developed and tested to work with that exact commit.

As the sloria repo evolves this repo is also updated to work with a more recent version.