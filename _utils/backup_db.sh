#!/bin/bash

source ../env
source .env

# This is not needed if the server has an assumed IAM role:
#export AWS_ACCESS_KEY_ID=$AWS_S3_ACCESS_KEY_ID
#export AWS_SECRET_ACCESS_KEY=$AWS_S3_SECRET_ACCESS_KEY
#export AWS_DEFAULT_REGION=$AWS_S3_REGION


current_date=$(date +"%Y-%m-%d")
current_datetime=$(date +"%Y-%m-%d-%H-%M-%S")

docker compose exec -t db bash -c "mysqldump -u$DB_USERNAME -p'$DB_PASSWORD' --no-tablespaces $DB_DATABASE" > /tmp/$current_datetime.sql

cd /tmp

tar -czf /tmp/$current_datetime-db.tar.gz $current_datetime.sql

aws s3 cp /tmp/$current_datetime-db.tar.gz s3://$AWS_S3_BUCKET/$AWS_S3_PREFIX/$current_date/database/

rm /tmp/$current_datetime.sql
rm /tmp/$current_datetime-db.tar.gz
