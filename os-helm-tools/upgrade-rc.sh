#!/bin/bash
#
# Upgrade replicas
#

set -e

helm upgrade keystone local/keystone \
  --set pod.replicas.api=2
