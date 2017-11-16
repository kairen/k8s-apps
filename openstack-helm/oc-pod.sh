#!/bin/bash
#
# Watch oc service
#

kubectl -n openstack get po -l release_name=${1}
