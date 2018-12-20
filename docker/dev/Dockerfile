ARG python_image_version
FROM python:$python_image_version

ARG app_name

RUN apk add --update --no-cache nodejs nodejs-npm postgresql-dev gcc python3-dev musl-dev libffi-dev

WORKDIR /root/
COPY $app_name $app_name

WORKDIR /root/$app_name
RUN pip install -r requirements/dev.txt
RUN npm install

CMD npx concurrently -n "WEBPACK,FLASK" -c "bgBlue.bold,bgMagenta.bold" "NODE_ENV=debug webpack-dev-server --port 2992 --hot --inline --host 0.0.0.0" "flask run --host=0.0.0.0"
