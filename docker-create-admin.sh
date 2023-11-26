cd docker/app/Modules/
git clone https://github.com/invoiceninja/admin-module && \
rm -fr ./Admin/ && \
mv ./admin-module ./Admin && \
docker compose cp Admin app:/var/www/app/app/Modules/



