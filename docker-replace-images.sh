echo
echo "Replacing logo images..."
docker compose cp ./config/images/new_logo.png app:/var/www/app/public/images/
docker compose cp ./config/images/favicon.ico app:/var/www/app/public/
docker compose cp ./config/images/admin.blade.php app:/var/www/app/resources/views/email/template/
docker compose cp ./config/images/client.blade.php app:/var/www/app/resources/views/email/template/

echo
echo "Replacing logo referenced in code..."
docker compose exec -it --user root app sh -c "find /var/www/app/ -type f -name '*.php' ! -path \"*/vendor/*\" -exec sed -i 's|https://invoicing.co/images/new_logo.png|'\"\$APP_URL\"'/images/new_logo.png|g' {} +"
docker compose exec -it --user root app sh -c "find /var/www/app/ -type f -name '*.php' ! -path \"*/vendor/*\" -exec sed -i 's|Invoice Ninja logo||g' {} +"
docker compose exec -it --user root app sh -c "find /var/www/app/ -type f -name '*.php' ! -path \"*/vendor/*\" -exec sed -i 's|invoiceninja-black-logo-2.png|new_logo.png|g' {} +"

