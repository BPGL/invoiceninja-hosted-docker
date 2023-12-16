
echo
echo Creating Admin Module...

cd docker/app/Modules/
rm -fr admin-module
git clone --single-branch --branch master git@github.com:invoiceninja/admin-module.git && \
rm -fr admin-module/.git
docker compose exec -t app sh -c "mkdir -p /var/www/app/Modules" && \
docker compose cp admin-module app:/var/www/app/Modules/Admin && \
docker compose exec -t --user root app sh -c "ln -s /var/www/app/Modules /var/www/app/app/Modules" && \
docker compose exec -t --user root app sh -c "chown -R invoiceninja:invoiceninja /var/www/app/Modules" && \
docker-compose exec -t app sed -i '/App\\Providers\\NinjaTranslationServiceProvider::class,/a \ \ Modules\\Admin\\Providers\\RouteServiceProvider::class,' config/app.php

echo Replacing references to IN website in code...
docker compose exec -it --user root app sh -c "find /var/www/app/ -type f -name '*.php' ! -path \"*/vendor/*\" -exec sed -i 's|https://invoiceninja.invoicing.co|'\"\$APP_URL\"'|g' {} +"
docker compose exec -it --user root app sh -c "find /var/www/app/ -type f -name '*.php' ! -path \"*/vendor/*\" -exec sed -i 's|https://invoicing.co|'\"\$APP_URL\"'|g' {} +"

echo Replacing references to IN name in code...
docker compose exec -it --user root app sh -c "find /var/www/app/lang/ -type f -name '*.php'  -exec sed -i 's|Invoice Ninja|$APP_NAME|g' {} +"

# Disable welcome emails:
docker-compose exec -t app sed -i 's/if (Ninja::isHosted()) {/if (Ninja::isHosted() \&\& false) {/' app/Listeners/Account/CreateAccountActivity.php

docker compose exec -t app sh -c "composer dump-autoload" && \
docker compose exec -t app sh -c "php artisan route:clear" && \
echo "Admin module backend installed successfully" || \
echo -e "Could not complete installation of Admin module. Check if you could clone admin module.\n" \
"Check that you can clone the repo, confirm that your SSH key has access to the repo.\n" \
"If you want to use an alternative SSH key, you can do that like this:\n" \
'GIT_SSH_COMMAND="ssh -i /root/.ssh/id_rsa_bee"' $0


