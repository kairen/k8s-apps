#!/bin/bash
#
# Run a example for Heat template
#

set -ex

source openrc
export NET_ID=$(openstack network list | awk '/ provider / { print $2 }')
openstack stack create -t demo-template.yml --parameter "NetID=$NET_ID" sack

