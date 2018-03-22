FROM python:3.6.4-alpine3.7

ARG app_name

RUN apk add --update --no-cache  nodejs postgresql-dev gcc python3-dev musl-dev libffi-dev

WORKDIR /root/
COPY $app_name $app_name

WORKDIR /root/$app_name
RUN pip install -r requirements/dev.txt
RUN npm install

ENV FLASK_APP=autoapp.py
ENV FLASK_DEBUG=1

CMD npm start
