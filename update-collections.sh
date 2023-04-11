#!/bin/bash

[[ "$(read -e -p 'Check the Crowdsec Hub for the name type of your desired collection. It must be specific in the file you are about to edit. Proceed? [y/N]> '; echo $REPLY)" == [Yy]* ]] || exit
$EDITOR docker/analysis/crowdsec/acquis.yaml
[[ "$(read -e -p 'Now mount your logs in the Crowdsec container. Location must match the entry you just set in the previous file. Proceed? [y/N]> '; echo $REPLY)" == [Yy]* ]] || exit
$EDITOR docker/analysis/docker-compose.yml
