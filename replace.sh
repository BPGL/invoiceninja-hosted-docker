echo "Replacing logo..."
docker compose cp ./config/new_logo.png app:/var/www/app/public/images/
docker compose exec -it --user root app sh -c "find /var/www/app/ -type f -name '*.php' -exec sed -i 's|https://invoicing.co/images/new_logo.png|'\"\$APP_URL\"'images/new_logo.png|g' {} +"

