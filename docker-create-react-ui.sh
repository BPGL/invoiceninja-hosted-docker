set -a
source ./env
set +a

cd ./docker/app/
git clone --single-branch --branch main git@github.com:Zer0Divis0r/invoiceninja-ui.git
cd invoiceninja-ui
cp -f .env.example .env
sed -i "/^VITE_IS_HOSTED=/c\VITE_IS_HOSTED=true" .env
sed -i "/^VITE_APP_TITLE=/c\VITE_APP_TITLE=\"$APP_NAME\"" .env
sed -i "/^VITE_API_URL=/c\VITE_API_URL=$APP_URL" .env

echo 
echo "Compiling React UI for Invoice Ninja, in hosted mode..."
docker run -t -v .:/home/node/app/ node \
bash -c "cd /home/node/app/ && npm install && npm run build"