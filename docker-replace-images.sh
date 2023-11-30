echo
echo "Replacing logo..."
docker compose cp ./config/images/new_logo.png app:/var/www/app/public/images/
docker compose cp ./config/images/favicon.ico app:/var/www/app/public/
docker compose cp ./config/images/favicon.ico reactui:/usr/share/nginx/html/
docker compose cp ./config/images/favicon.ico reactui:/usr/share/nginx/html/logo192.png
docker compose cp ./config/images/logo180.png reactui:/usr/share/nginx/html/logo180.png
docker compose exec -it --user root app sh -c "find /var/www/app/ -type f -name '*.php' -exec sed -i 's|https://invoicing.co/images/new_logo.png|'\"\$APP_URL\"'/images/new_logo.png|g' {} +"

