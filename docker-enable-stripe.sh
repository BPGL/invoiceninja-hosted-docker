set -a 
sourtce env
set +a

docker compose exec -t db bash -c "mysql -u $DB_USERNAME -u$DB_PASSWORD -e 'UPDATE gateways SET visible=1 WHERE id=20'"
docker compose exec -t app sh "rm -fr /var/www/app/storage/framework/cache/data/*"
