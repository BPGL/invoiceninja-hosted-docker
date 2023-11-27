chmod 777 docker/app/public 
chmod 777 docker/app/storage
docker compose up -d
chown $(docker compose exec -t app id -u) docker/app/public docker/app/storage
docker compose exec -t --user root app sh -c "chown invoiceninja:invoiceninja ./public"
docker compose exec -t --user root app sh -c "chown invoiceninja:invoiceninja ./storage"
docker compose logs -f
#./docker-create-admin.sh
