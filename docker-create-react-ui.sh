set -a
source ./env
set +a

echo
echo "Creating React UI..."

DIR=$(pwd)

cd $DIR/docker/app/react-ui/
git clone --single-branch --branch $REACTUI_REPO_BRANCH $REACTUI_REPO

cd $DIR/docker/app/react-ui/invoiceninja-ui
git reset --hard
git pull
cp -f .env.example .env
sed -i "/^VITE_IS_HOSTED=/c\VITE_IS_HOSTED=true" .env
sed -i "/^VITE_APP_TITLE=/c\VITE_APP_TITLE=\"$APP_NAME\"" .env
sed -i "/^VITE_API_URL=/c\VITE_API_URL=$APP_URL" .env

echo "Replacing texts in source code..."
sed -i "s|Invoice Ninja (React)|$APP_NAME|g" public/manifest.json
sed -i "s|Disallow:|Disallow: /|g" public/robots.txt

cp $DIR/config/images/my-logo@dark.png ./src/resources/images/
cp $DIR/config/images/my-logo@light.png ./src/resources/images/
find . -type d \( -name .git -o -name .github \) -prune -o -type f -exec sed -i "s|invoiceninja-logo@light.png|my-logo@light.png|g"  {} +
find . -type d \( -name .git -o -name .github \) -prune -o -type f -exec sed -i "s|invoiceninja-logo@dark.png|my-logo@light.png|g"  {} +

find . -type d \( -name .git -o -name .github \) -prune -o -type f -exec sed -i "s|Invoice Ninja Logo||g"  {} +
find . -type d \( -name .git -o -name .github \) -prune -o -type f -exec sed -i "s|Invoice Ninja|$APP_NAME|g"  {} +
find . -type d \( -name .git -o -name .github \) -prune -o -type f -exec sed -i "s|invoiceninja.com|$APP_DOMAIN|g"  {} +

cd $DIR/docker/app/react-ui/invoiceninja-ui
echo
echo "Compiling React UI for Invoice Ninja, in hosted mode..."
docker run --rm -t -v .:/home/node/app/ --user $(id -u):$(id -g) node \
bash -c "cd /home/node/app/ && npm install && npm run build"

cd $DIR/docker/app/react-ui/
rm -fr ./html/*
mv $DIR/docker/app/react-ui/invoiceninja-ui/dist/* $DIR/docker/app/react-ui/html/

cd $DIR
docker compose cp $DIR/config/images/favicon.ico reactui:/usr/share/nginx/html/
docker compose cp $DIR/config/images/favicon.ico reactui:/usr/share/nginx/html/logo192.png
docker compose cp $DIR/config/images/favicon.ico reactui:/usr/share/nginx/html/logo180.png


docker compose restart reactui

