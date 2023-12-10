PROD_DIR=$1
STAGING_DIR=$2

echo "Exporting from production..."
cd $PROD_DIR || exit 1
source ./env
docker compose exec -t db bash -c "mysqldump -u$DB_USERNAME -p'$DB_PASSWORD' --no-tablespaces $DB_DATABASE" > /tmp/prod_db.sql

echo "Importing to staging..."
cd $STAGING_DIR || exit 1
source ./env
docker compose exec -t db bash -c "mysql -u$DB_USERNAME -p'$DB_PASSWORD' -D $DB_DATABASE" < /tmp/prod_db.sql

echo "Removing dump"
rm -f /tmp/prod_db.sql

