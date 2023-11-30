set -a
source ./env
set +a


echo
echo "Deleting excessive currencies..."
docker compose exec -t db bash -c "mysql -u $DB_USERNAME -p'$DB_PASSWORD' -e \"DELETE from "$DB_DATABASE".currencies WHERE code NOT IN ('EUR', 'SEK', 'NOK', 'USD', 'HKD')\" "
