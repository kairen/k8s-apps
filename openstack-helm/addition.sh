#!/bin/bash
#
# Addition service
#

set -e

case $1 in
  heat)
    helm install --namespace=openstack --name=heat local/heat
  ;;
  magnum)
    helm install --namespace=openstack --name=magnum local/magnum
  ;;
esac
