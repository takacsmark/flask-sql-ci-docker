ARG python_image_version

FROM python:$python_image_version

ARG repo
ARG repo_release_version

WORKDIR /root/
COPY cookiecutter.yml cookiecutter.yml

RUN pip install cookiecutter && \
  apk --update add git

RUN git clone $repo && \
  cd cookiecutter-flask && \
  git reset --hard $repo_release_version

RUN cookiecutter --no-input --config-file cookiecutter.yml cookiecutter-flask
