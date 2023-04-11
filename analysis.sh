#/bin/bash

#cd network
PREFIX='analysis'

# generate .env file with sensitive credentials if file does not exist
echo "[*] Generating sensitive credentials if ""$PREFIX""/.env file does not exist"
file -E docker/"$PREFIX"/.env || \
(cat << EOF
DB_USER=$(cat /proc/sys/kernel/random/uuid)
DB_PASSWORD=$(cat /proc/sys/kernel/random/uuid)
ELASTICSEARCH_USERNAME=elastic
ELASTICSEARCH_PASSWORD=$(cat /proc/sys/kernel/random/uuid)
LOGS_TIMEZONE_OFFSET=-01:00
EOF
 ) > docker/"$PREFIX"/.env

chmod 640 docker/"$PREFIX"/.env

# TODO: move this to grafana container entrypoint
#export $(grep '^DB_USER\|^DB_PASSWORD' "$PREFIX"/.env | xargs)
echo "[*] Setting up grafana"
sed -i 's/user:.*$/user: '${DB_USER}'/g' docker/"$PREFIX"/grafana/provisioning/datasources/datasource.yml
sed -i 's/password:.*$/password: "'${DB_PASSWORD}'"/g' docker/"$PREFIX"/grafana/provisioning/datasources/datasource.yml

grep -v '^#' docker/"$PREFIX"/.env

# TODO: run with ansible playbook if host is specified
sudo docker-compose -f docker/docker-compose.local.yml -f docker/"$PREFIX"/docker-compose.yml --env-file docker/"$PREFIX"/.env $@
#cd ..

