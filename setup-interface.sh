#!/bin/bash
read -p "Enter network interface of your NSM: " interface
sed -i 's/INTERFACE=.*/INTERFACE='${interface}'/g' docker/network/.env
