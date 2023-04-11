#/bin/bash

#cd network
PREFIX='purpleids'

# generate .env file with sensitive credentials if file does not exist
echo "[*] Generating sensitive credentials if ""$PREFIX""/.env file does not exist"
file -E docker/"$PREFIX"/.env || \
(cat << EOF
DB_USER=$(cat /proc/sys/kernel/random/uuid)
DB_PASSWORD=$(cat /proc/sys/kernel/random/uuid)
EOF
 ) > docker/"$PREFIX"/.env

chmod 640 docker/"$PREFIX"/.env

grep -v '^#' docker/"$PREFIX"/.env

# TODO: run with ansible playbook if host is specified
sudo docker-compose -f docker/docker-compose.local.yml -f docker/"$PREFIX"/docker-compose.yml --env-file docker/"$PREFIX"/.env $@
#cd ..

