git pull

chmod 777 docker/app/public 
chmod 777 docker/app/storage

docker compose pull

docker compose up -d
chown $(docker compose exec -t app id -u) docker/app/public docker/app/storage

docker compose exec -t --user root app sh -c "chown invoiceninja:invoiceninja ./public"
docker compose exec -t --user root app sh -c "chown invoiceninja:invoiceninja ./storage"

until docker compose logs -f | tee /dev/tty | grep -q "ready to handle connections"; do : ; done

./docker-create-admin.sh

./docker-enable-stripe.sh

./docker-localize.sh

./docker-create-react-ui.sh

./docker-replace-images.sh
