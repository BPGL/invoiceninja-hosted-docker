#!/bin/bash

# Load environment variables from .env file
source ../env
source .env

# This is not needed if the server has an assumed IAM role:
#export AWS_ACCESS_KEY_ID=$AWS_S3_ACCESS_KEY_ID
#export AWS_SECRET_ACCESS_KEY=$AWS_S3_SECRET_ACCESS_KEY
#export AWS_DEFAULT_REGION=$AWS_S3_REGION


current_date=$(date +"%Y-%m-%d")
current_datetime=$(date +"%Y-%m-%d-%H-%M-%S")

tar -czf /tmp/$current_datetime-files.tar.gz ../docker/app/public/storage/*

aws s3 cp /tmp/$current_datetime-files.tar.gz s3://$AWS_S3_BUCKET/$AWS_S3_PREFIX/$current_date/storage/

rm /tmp/$current_datetime-files.tar.gz
