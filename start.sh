# Initialize a variable to track whether "--skipui" is specified
skip_ui=false

# Check if "--skipui" is specified in the command line arguments
for arg in "$@"; do
    if [ "$arg" == "--skipui" ]; then
        skip_ui=true
        break
    fi
done


git pull

chmod 777 docker/app/public
chmod 777 docker/app/storage

docker compose pull

set -a
source ./env
set +a

REACTUI_EXPOSE_PORT=$REACTUI_EXPOSE_PORT \
API_EXPOSE_PORT=$API_EXPOSE_PORT \
MYSQL_EXPOSE_PORT=$MYSQL_EXPOSE_PORT \
  docker compose up -d

chown $(docker compose exec -t app id -u) docker/app/public docker/app/storage

docker compose exec -t --user root app sh -c "chown invoiceninja:invoiceninja ./public"
docker compose exec -t --user root app sh -c "chown invoiceninja:invoiceninja ./storage"

until docker compose logs -n 50 -f | tee /dev/tty | grep -q "ready to handle connections"; do : ; done

./docker-create-admin.sh

./docker-replace-images.sh

./docker-update-backend.sh

./docker-enable-stripe.sh

./docker-localize.sh

./docker-remove-flutter.sh

if [ "$skip_ui" == false ]; then
    ./docker-create-react-ui.sh
fi

echo Finished.


