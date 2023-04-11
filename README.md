# PurpleSec
This is purplesec, a collection of dockerfiles, docker-compose configurations, docker swarm stacks, ansible roles and playbooks with practical security automation applications.
It is my attempt to collect some of my other standalone repos into one comprehensive set of tools with a focus on automation.
Though most of the effort goes to the cyber defense part, some future components will include recon and stealth behavior to emulate attackers in realistic scenarios.
Additionally, there will be configurations for setting up wireguard tunnels anywhere, multi-host docker volumes via SSH and NFS, automated backups using borg.

The philosophy behind purplesec follows these basic principles:
  - low resource footprint (memory, I/O, cpu)
  - usability through simplicity (and visibility)
  - focus on the most likely attack vectors

The ultimate goal is to provide a collection of modules that can be applied separately or together, on most environments, with minimal manual setup, that provide tangible results without spending hundreds of hours learning how to use that particular vendor's solution.
Purplesec's capabilities sit between home firewalls and more sophisticated XDRs, moving homelabs and smaller organizations from zero to decent intrusion detection and response.
Powered by open source software.

Importing logs in the analysis stack is equivalent to defining a docker volume and adding it to your services.

Purplesec follows a strict directory structure:
 * ./docker folder, containing all docker compose bundles, and referred to by several ansible roles
 * ./ansible folder, containing playbooks and roles for deploying docker configurations in your environment
 * some bash scripts to bootstrap common scenarios

Refer to the corresponding subdirectories for more specific readme files.

## High level overview of how docker and ansible work together in purplesec
There will be a diagram here soon.

## Usage
```
# Put your compose project in ./docker, then:
bash link-files.sh

# Now set up your inventory following the given template:
cp ansible/inventory.template ansible/.inventory 

# Place an ansible vault for credentials and other sensitive data (this in mandatory)
ansible-vault create ansible/.vault

# ssh at least once in all hosts to fill up your ~/.ssh/known_hosts
# place known hosts file in ansible/.ssh/known_hosts so that hosts can open ssh tunnels to each others
mkdir ansible/.ssh
cp ~/.ssh/known_hosts ansible/.ssh/known_hosts

# edit ansible/vars/main.yml and set the required volumes and parameters

# set the name of the interface in your sniffer correctly
bash setup-interface.sh

# Now you can push your configurations wherever you want!
bash ansible.sh ansible/push-compose.yml

# check ./ansible for more playbooks
```

## Some tips for this specific setup
The current setup includes the 9xeb/purpleids, 9xeb/nsm and 9xeb/netpot compose configurations.
Additionally, 9xeb/sigmalert is present but not used.

[docker/analysis/rita/config.yaml]
Edit 'Filtering: InternalSubnets' to add any additional IP range to treat as internal
Edit 'Filtering: AlwaysInclude' to add any IP to exempt from internal filtering. Typically you should put your internal DNS servers here so that internal DNS queries are recorded

[docker/nsm/zeek]
Check zeek docs if you need to change the default list of networks to be considered as internal

## Caveats
 * ZEEK_INTERFACE and SURICATA_INTERFACE must match the actual interface name of your sniffing host
 * Make sure all your hosts agree on their timezone to avoid unexpected delays when analysing logs. Stick to UTC as a global time

[Notes]
- Apparently if filebeat is restarted and eve.json is big, something weird happens and suricata logs are not sent to elasticsearch
	- possible mitigation: rotate eve.json with bash tools and see how suricata reacts (removing the file does not work, suricata stops writing to eve.json)

### Future additions
- Attack surface recon, sensible vulnerability assessment using bash pipeline, from org name to vulnerabilities, through asset discovery and recording
- Remote security assessments via ssh

- zed query '' | crowdsec
- warninglists + virustotal in threatintel
- Let user declare policy for diamond2ban
- Regular suricata-update in running suricata container

#### Some notes
- elasticlean container, simple python script for dropping documents in indexes according to timestamp or size policy
