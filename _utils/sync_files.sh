PROD_DIR=$1
STAGING_DIR=$2

echo "Copying files to staging..."
cp -fr $PROD_DIR/docker/app/public/storage/* $STAGING_DIR/docker/app/public/storage/

