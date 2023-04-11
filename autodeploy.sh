#!/bin/bash

[[ "$(read -e -p '[WARNING] Have you set up your inventory in ansible/.inventory? [y/N]> '; echo $REPLY)" == [Yy]* ]] || exit
[[ "$(read -e -p '[WARNING] Have you set all variables in ansible/vars/main.yml? [y/N]> '; echo $REPLY)" == [Yy]* ]] || exit
[[ "$(read -e -p '[WARNING] have you provided a known_hosts file for mutual ssh access? (if you have connected at least once to each host, you can use your own known_hosts file in ~/.ssh/known_hosts) [y/N]> '; echo $REPLY)" == [Yy]* ]] || exit

bash setup-interface.sh && \
{
bash ansible.sh ansible/push-sshnfs.yml;
bash ansible.sh ansible/push-network.yml;
bash ansible.sh ansible/push-analysis.yml;
}
