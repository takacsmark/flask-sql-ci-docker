FROM python:3.6.4-alpine3.7

ARG repo

WORKDIR /root/
COPY cookiecutter.yml cookiecutter.yml

RUN pip install cookiecutter && \
  apk --update add git

RUN cookiecutter --no-input --config-file cookiecutter.yml $repo
