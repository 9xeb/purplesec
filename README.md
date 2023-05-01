# PurpleSec
This is __PurpleSec__, a collection of dockerfiles, docker-compose configurations, ansible roles and playbooks with practical __automation__ applications.
It is an attempt to collect some of my other standalone repos into one comprehensive set of tools for easier deployment in my homelab.

Originally, PurpleSec used to be a collection of defensive cybersecurity tools that looked at network traffic and application logs for intrusion detection purposes.

Nowadays, through PurpleSec, you can also remotely manage Docker Compose configurations in multi-host environments, choose where each stack goes to, and do so from the same place. This makes PurpleSec a sort of minimalistic orchestrator with ingrained intrusion detection bundles.

Planned future components will include automated recon and stealth behavior for performing adversary emulation against the multi-host environment itself and boost security even further.



Powered by open source software. Currently tested on debian-like environments only.

# Security bundles
The goal here is to provide bundles that can be applied to most environments, with minimal manual setup, that provide tangible results without spending hundreds of hours learning how to use that particular vendor's solution.

The philosophy behind the available security bundles follows these basic principles:
  - low resource footprint (memory, I/O, cpu);
  - usability through simplicity;
  - focus on the most likely attack vectors first.

Current bundles that support automated deployment include:
 * a __network security monitor__ powered by Zeek and Suricata;
 * __log analysis services__ with the following capabilities:
   * spot __beacons__ in network traffic;
   * detect the most common __probing__, __brute forcing__, __DoS__ and __exploitation__ attempts against web servers;
   * highlight __observables__ of interest for __threat hunting__ purposes. These include IP addresses, domain names, fingerprints and URLs;
 * a __Zed data lake__ accessible via Zui for threat hunting;
 * a __vulnerable web app__ (DVWA) for testing the system's capabilities.

I encourage you to take a look at my other repos that appear as submodules for purplesec.

From the perspective of data flows, there are three distinct logical elements: __log producers__, __log collectors__ and __log consumers__. These three categories become more evident when orchestrating through ansible.

In terms of effectiveness, PurpleSec's security bundles stand between home firewalls and more sophisticated XDRs, driving homelabs and other small networks from zero to decent intrusion detection and response.

## High level overview
![Purplesec](./purplesec.png)

## How multi-host stateful data, including log collection, is achieved
For log collection, a clever way of deploying docker volumes is used. After struggling with Elasticsearch for long I realized that for low-budget security use cases Elasticsearch is way too resource hungry compared to the actual benefits it provides. Therefore, I developed a system for sharing __docker volumes across multiple hosts__ instead, powered by Ansible roles and playbooks.

Here's how it works briefly. At least one NFS server accepting requests from localhost only is setup. Docker hosts open SSH tunnels to NFS hosts so that they can access NFS exports through secure channels. Whenever required, some ansible roles make sure NFS hosts and docker hosts agree when mapping docker volume names to remote NFS exports.
The result is effortless and transparent data sharing through SSH tunnels, between containers regardless of their physical location and the docker host they are running on, for both reading and writing data.

In practice, importing or exporting logs across hosts becomes equivalent to simply defining a docker volume and mounting it inside the desired container, while SSH and NFS do their magic behind the scenes.


Purplesec follows a strict directory structure:
 * ./docker folder, containing all docker compose bundles, and referred to by several ansible roles
 * ./ansible folder, containing playbooks and roles for deploying docker configurations in your environment
 * some bash scripts to bootstrap common scenarios

Refer to subdirectories for more specific information.

Though the current setup is specific to security monitoring, some potential general applications are emerging from some of the ansible roles and playbooks I have been writing. By general applications I mean the same process that powers automation in purplesec can be applied to any docker-compose bundle one wishes to deploy across hosts. I will probably leverage them on a separate repo dedicated to docker orchestration soon.

# Other bundles
__Though this project was originally meant for security purposes only, it is rapidly becoming a generic orchestrator for multi host docker with multi host volumes. Since multi host volumes cannot be configured easily in docker and docker swarm, you might want to pull this repo and use it as a launchpad for your distributed docker-based applications.__

Hence, if you wish, you can add your own project's subdir in ./docker, and then operate your multi-host environment using the available helper scripts.

# Usage
First of all, __SSH at least once in storage hosts to fill up your ~/.ssh/known_hosts__, then place the file in ansible/.ssh/known_hosts. Since some hosts require to set up some SSH tunnels to other hosts in order to work with multi-host volumes, and they must to do so non-interactively and securely, they must also 'know' each other beforehand:
```
$ mkdir ansible/.ssh
$ cp ~/.ssh/known_hosts ansible/.ssh/known_hosts
```

I wrote a __helper script__ (requires nano) to simplify both configuration and deployment. This is especially useful for hiding the inner workings of multi host volume management, which spans across multiple configuration files the average user should not keep track of. The script is simply called 'purplesec'.

Edit your inventory file (a template is provided so you can configure credentials in an ansible vault):
```
$ ./purplesec inventory
```
Edit Ansible vault:
```
$ ./purplesec vault {create | edit | rekey}
```
Tailor variables to suit your specific environment:
```
$ ./purplesec vars
```
Example stack declaration in vars:
```
stacks:
  - { 
      name: nsm, 
      dir: nsm, 
      target: 'networkHosts', 
      status: present, 
      conf: [nsm/docker-compose-ansible.yml], 
      env: nsm/.env
    }
  - { 
      name: purpleids, 
      dir: purpleids, 
      target: 'analysisHosts', 
      status: present, 
      conf: [purpleids/docker-compose-ansible.yml], 
      env: purpleids/.env
    }
  - { 
      name: services, 
      dir: docker-bundles/services, 
      status: present,
      target: 'serviceHosts', 
      conf: [docker-bundles/services/docker-compose-ansible.yml], 
      env: docker-bundles/services/.env
    }
```
Mark some volumes as logs sources for security purposes. This is still broken so don't count on it yet:
```
$ ./purplesec logs
```
Push configuration (will setup everything, including NFS backend and all compose bundles):
```
$ ./purplesec push {volumes | compose}
```

# Cool features
* Security bundle exposes a Zed data lake to perform threat hunting on network logs;
* You can import your own dockerized projects and manage them from a unified platform;
* Volume declarations are parsed directly from your compose files, and a new file for transparently overriding those declarations is generated every time. This makes sure your volumes turn multi-host;

# Managing internal networks
Below you can find some additional tips to tailor your specific setup.

In *docker/purpleids/rita/config.yaml*:
 * Edit 'Filtering: InternalSubnets' to add any additional IP range to treat as internal;
 * Edit 'Filtering: AlwaysInclude' to add any IP to exempt from internal filtering. Typically you should put your internal DNS servers here so that internal DNS queries are recorded.

In *docker/nsm/zeek*:
 * Check zeek docs if you need to change the default list of networks to be considered as internal.

# Future additions
- Attack surface recon, automated red teaming with toolchains, from org name to vulnerabilities, through asset discovery and OSINT;
- Remote security assessments via ssh;
- Docker image to tail -F log files from local filesystem to remote volume (basically a replacement for filebeat);
- Support for Docker Swarm;
- High availability NFS in storage hosts.