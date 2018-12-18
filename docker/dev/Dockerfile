ARG python_image_verson

FROM python:$python_image_verson

ARG app_name

RUN apk add --update --no-cache nodejs nodejs-npm postgresql-dev gcc python3-dev musl-dev libffi-dev

WORKDIR /root/
COPY $app_name $app_name

WORKDIR /root/$app_name
RUN pip install -r requirements/dev.txt
# RUN cp .env.example .env
RUN npm install

ENV FLASK_APP=autoapp.py
ENV FLASK_DEBUG=1
ENV FLASK_ENV=development
ENV DATABASE_URL="sqlite:////tmp/dev.db"
ENV SECRET_KEY="not-so-secret"

CMD npm start
