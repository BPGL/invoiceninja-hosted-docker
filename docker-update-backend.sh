
echo
echo "Updating backend files..."
docker compose cp ./config/backend/* app:/var/www/app/resources/views/email/template/
