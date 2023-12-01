set -a 
source ./env
set +a

echo
echo "Enabling Stripe..."
docker compose exec -t db bash -c "mysql -u $DB_USERNAME -p'$DB_PASSWORD' -e 'UPDATE "$DB_DATABASE".gateways SET visible=1 WHERE id=20'"
docker compose exec -t app sh -c "rm -fr /var/www/app/storage/framework/cache/data/*"
