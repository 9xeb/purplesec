#!/bin/bash

# link project files to 9xeb.push-compose ansible role
echo "[*] Linking your ./docker to ansible roles that require it"
unlink ansible/roles/9xeb.push-compose/files && \
ln -s ../../../docker ansible/roles/9xeb.push-compose/files

unlink ansible/roles/9xeb.push-volumes/files && \
ln -s ../../../docker ansible/roles/9xeb.push-volumes/files
echo "[*] Done"
