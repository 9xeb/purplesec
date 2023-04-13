#/bin/bash

#cd network
# read .env file
#grep '^DB_USER\|^DB_PASSWORD\|^ZEEK_INTERFACE\|^ZEEK_PROCS\|^SURICATA_INTERFACE' network/.env && \
#export $(grep '^DB_USER\|^DB_PASSWORD\|^ZEEK_INTERFACE\|^ZEEK_PROCS\|^SURICATA_INTERFACE' network/.env | xargs)

# Build zeek config file
#echo "[*] Setting up Zeek"
#cp network/zeek/node.cfg.template network/zeek/node.cfg
#sed -i 's/interface=.*/interface='${ZEEK_INTERFACE}'/g' network/zeek/node.cfg
#sed -i 's/lb_procs=.*/lb_procs='${ZEEK_PROCS}'/g' zeek/node.cfg

# Build suricata config file
#echo "[*] Setting up Suricata"
#cp network/suricata/suricata.yaml.template network/suricata/suricata.yaml
#sed -i 's/interface: eth.*/interface: '${SURICATA_INTERFACE}'/g' network/suricata/suricata.yaml


# TODO: run with ansible playbook if host is specified
bash ./setup-interface.sh && \
sudo docker-compose -f docker/docker-compose.local.yml -f docker/nsm/docker-compose.local.yml --env-file docker/nsm/.env $@
#cd ..
