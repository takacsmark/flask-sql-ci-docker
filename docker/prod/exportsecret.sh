#!/bin/sh
export SECRET_KEY=$(cat $APP_SECRET)
export DATABASE_URL=postgresql://postgres:$(cat $POSTGRES_PASSWORD)@postgres/postgres
