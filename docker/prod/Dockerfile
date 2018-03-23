FROM python:3.6.4-alpine3.7 as builder

RUN apk add --update --no-cache  nodejs

ARG app_name
WORKDIR /root/
COPY $app_name $app_name

WORKDIR /root/$app_name
RUN npm install &&\
 npm run build


FROM python:3.6.4-alpine3.7

RUN apk add --update --no-cache postgresql-dev gcc python3-dev musl-dev libffi-dev

ARG app_name
WORKDIR /root/
COPY --from=builder /root/$app_name $app_name

WORKDIR /root/$app_name
RUN rm -rf migrations dev.db node_modules && \
  pip install -r requirements/prod.txt

ENV FLASK_APP=autoapp.py
ENV FLASK_DEBUG=0

CMD flask run --host=0.0.0.0
