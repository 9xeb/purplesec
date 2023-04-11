#!/bin/bash

# link project files to 9xeb.push-compose ansible role
echo "[*] Linking your ./docker to ansible roles that require it"
unlink ansible/roles/9xeb.push-compose/files && \
ln -s ../../../docker ansible/roles/9xeb.push-compose/files

unlink ansible/roles/9xeb.push-volumes/files && \
ln -s ../../../docker ansible/roles/9xeb.push-volumes/files
echo "[*] Done"

#!/bin/bash
read -p "Enter network interface of your NSM: " interface
sed -i 's/INTERFACE=.*/INTERFACE='${interface}'/g' docker/nsm/.env

file -E docker/purpleids/.env || \
(cat << EOF
DB_USER=$(cat /proc/sys/kernel/random/uuid)
DB_PASSWORD=$(cat /proc/sys/kernel/random/uuid)
EOF
 ) > docker/purpleids/.env
