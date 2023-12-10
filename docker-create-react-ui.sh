set -a
source ./env
set +a

echo
echo "Creating React UI..."

cd ./docker/app/
git clone --single-branch --branch $REACTUI_REPO_BRANCH $REACTUI_REPO

cd invoiceninja-ui
git reset --hard
git pull
cp -f .env.example .env
sed -i "/^VITE_IS_HOSTED=/c\VITE_IS_HOSTED=true" .env
sed -i "/^VITE_APP_TITLE=/c\VITE_APP_TITLE=\"$APP_NAME\"" .env
sed -i "/^VITE_API_URL=/c\VITE_API_URL=$APP_URL" .env

echo "Replacing texts in sourcce code..."
sed -i "s|Invoice Ninja (React)|$APP_NAME|g" public/manifest.json
sed -i "s|Disallow:|Disallow: /|g" public/robots.txt

cp ../../../config/images/my-logo@dark.png ./src/resources/images/
cp ../../../config/images/my-logo@light.png ./src/resources/images/
find . -type d \( -name .git -o -name .github \) -prune -o -type f -exec sed -i "s|invoiceninja-logo@light.png|my-logo@light.png|g"  {} +
find . -type d \( -name .git -o -name .github \) -prune -o -type f -exec sed -i "s|invoiceninja-logo@dark.png|my-logo@light.png|g"  {} +

find . -type d \( -name .git -o -name .github \) -prune -o -type f -exec sed -i "s|Invoice Ninja Logo||g"  {} +
find . -type d \( -name .git -o -name .github \) -prune -o -type f -exec sed -i "s|Invoice Ninja|$APP_NAME|g"  {} +
find . -type d \( -name .git -o -name .github \) -prune -o -type f -exec sed -i "s|invoiceninja.com|$APP_DOMAIN|g"  {} +

echo
echo "Compiling React UI for Invoice Ninja, in hosted mode..."
docker run -t -v .:/home/node/app/ node \
bash -c "cd /home/node/app/ && npm install && npm run build"

cd ../../../
docker compose cp ./config/images/favicon.ico reactui:/usr/share/nginx/html/
docker compose cp ./config/images/favicon.ico reactui:/usr/share/nginx/html/logo192.png
docker compose cp ./config/images/favicon.ico reactui:/usr/share/nginx/html/logo180.png


docker compose restart reactui

