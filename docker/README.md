# List
- [FEATURED] nsm
	- integrated zeek and suricata stack that works out-of-the-box
	- logs can be easily shared for inspection, across your infrastructure via docker volumes and sshnfs
	- specify the interface to listen to
	- typically you would want one of these sniffing a network tap at the frontier

- [FEATURED] purpleids
	- low footprint compared to fully fledged XDRs
	- thorough analysis of a selected groups of logs:
		- zeek logs (both current and rotated)
		- suricata eve.json
		- nginx and apache2 access.log
		- ... more in the future
	- superficial analysis of any kind of text coming from an Elasticsearch instance or a dedicated log directory
		- based on the diamond model of intrusion analysis
		- extracts various observables (IP addresses, hashes, domain names)
		- groups said observables in pairs or triads following the external <-> vector <-> internal logic
		- tags observables that might be false positives
	- automatically flags actors when:
		- known malicious fingerprints are found in diamond model triads
		- connection exhibits beaconing behavior
	- automatically flags and bans actors when:
		- a priority 1 or two priority 2 suricata alerts are triggered (WIP)
		- standard crowdsec web scenarios are triggered
	- exposes a dashboard for an overview on what the automation is doing
	- allows operator to perform threat hunts with Brim/Zui using zeek and suricata logs
	- allows operator to push malicious IP addresses to the local Crowdsec API for immediate response

- [WIP] crowdsec
	- template for a local crowdsec agent when needed
	- edit acquis.yml to add more logs to ingest (supports docker with unix socket)

- [WIP] honeypot
	- to detect internal mapping behavior with confidence
	- accepts incoming requests, performs handshake and resets
	- specify which ports to listen to
	- generates JSON logs

- [CONCEPT & WIP] provider
	- elasticsearch database with user/password authentication
	- sigma rules based detection with elastalert
	- nginx reverse proxy with ssl
	- wireguard server for communicating with customer's filebeat instance

- [CONCEPT & WIP] customer
	- filebeat for reading logs and pushing them to remote Elasticsearch instance
	- wireguard client for reaching provider's Elasticsearch instance

- [CONCEPT & WIP] redbot
	- performs public attack surface scanning
	- looks for low hanging fruits in unexplored environments

[Compose stacks]
This repositories comes with multiple bundled configurations:
- PurpleIDS (zeek + suricata + rita + zui + swag + threatintel + crowdsec + grafana + grafana_loki)
        - flagship product
        - covers network, and anything the crowdsec hub covers
        - low memory footprint
        - provides automated mitigation and response via the crowdsec api
        - users can set threatintel suspiciousness when translating diamond model records to crowdsec bans
        - can be provided as a service
                - import customer's access.log (for example via Elasticsearch+Filebeat and the Elasticsearch connector in threatintel)
                        - via elasticsearch env variables in threatintel
                        - import log files directly into threatintel
                - redirect customer's traffic through a VPN we can put a network tap on

- Elasticsearch + Sigmalert (for host based)
        - host based matching in elastalert_status index
        - currently not very interested in this due to the effort requried to manually triage alerts (host based solutions are prone to data swamps)
        - elastic is way too I/O heavy for small environments in relation to the benefits it actually provides
        - written to prove myself I could make a rule based HIDS work with sigma rules
        - mainly for windows hosts
        - missing dashboards apart from default kibana
