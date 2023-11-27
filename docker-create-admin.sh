cd docker/app/Modules/
git clone git@github.com:invoiceninja/admin-module.git && \
exit 1
rm -fr ./Admin/* && \
mv ./admin-module/* ./Admin/ && \
exit 1
I_USER=$(docker compose exec -t app id -un) && \
I_GROUP=$(docker compose exec -t app id -gn) && \
docker compose exec -t -u root app sh -c "chown -R $I_USER:$I_GROUP /var/www/app/app/Modules" && \
docker compose exec -t --user root app sh -c "ln -s /var/www/app/app/Modules /var/www/app/Modules" && \
echo "Admin module backend installed successfully" || \
echo -e "Could not complete installation of Admin module. Check if you could clone admin module.\n" \
"Check that you can clone the repo, confirm that your SSH key has access to the repo.\n" \
"If you want to use an alternative SSH key, you can do that like this:\n" \
'GIT_SSH_COMMAND="ssh -i /root/.ssh/id_rsa_bee"' $0



rm -fr ./admin-module

#docker compose cp ./Admin dockerfiles-app-1:/var/www/app/app/Modules/ 


