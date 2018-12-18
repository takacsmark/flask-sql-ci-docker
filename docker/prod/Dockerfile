ARG python_image_version
FROM python:$python_image_version as builder

RUN apk add --update --no-cache  nodejs nodejs-npm

ARG app_name
WORKDIR /root/
COPY $app_name $app_name

WORKDIR /root/$app_name
RUN npm install &&\
 npm run build


FROM python:$python_image_version

RUN apk add --update --no-cache postgresql-dev gcc python3-dev musl-dev libffi-dev

ARG app_name
WORKDIR /root/
COPY --from=builder /root/$app_name $app_name

WORKDIR /root/$app_name
RUN rm -rf migrations dev.db node_modules && \
  pip install -r requirements/prod.txt

CMD flask run --host=0.0.0.0
