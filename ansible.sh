#!/bin/bash

# check imported roles
ansible-galaxy install -r ansible/requirements.yml --roles-path ansible/roles

bash setup-interface.sh
# clear stale ssh pubkeys
echo "[*] Clearing stale ssh pubkeys"
rm -rf ansible/.ssh/*.pub

# run playbook
if [ $# -eq 0 ]; then
  echo "[*] Running full setup (disabled)"
  #for step in ansible/setup-nfs.yml ansible/setup-autossh-nfs.yml ansible/push-network.yml ansible/push-analysis.yml; do
  #  ansible-playbook -v -i ansible/.inventory -b ${step} -e@ansible/.vault --ask-vault-pass
  #done
else
  echo "[*] Running setup for "${1}
  ansible-playbook -vv -i ansible/.inventory -b ${1} -e@ansible/.vault --ask-vault-pass
fi
