#!/bin/bash
#
# Upgrade replicas
#

set -e

helm upgrade horizon local/horizon \
  --set images.db_init=172.20.3.230:5000/kolla/ubuntu-source-horizon:5.0.0 \
  --set images.horizon=172.20.3.230:5000/kolla/ubuntu-source-horizon:5.0.0 \
  --set images.dep_check=172.20.3.230:5000/kolla/ubuntu-source-kubernetes-entrypoint:5.0.0 
